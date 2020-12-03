import dotenv from 'dotenv';
dotenv.config();
import express from 'express';
import https from 'https';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { createHash } from 'crypto';
import { insertUser, fetchUsers, updateUser, fetchCodes, insertCode, deleteCode } from "./utils/DatabaseHandler";
import { authenticateToken, authenticateTokenReturn, generateAccessToken, tokenExpiryTime } from './authentication';
import { SignUpInfo, LoginInfo, User, Code, AccessToken, Contact, PartialUserData } from './interfaces';
import { MongoError, ObjectId } from 'mongodb';
import { json as _bodyParser } from 'body-parser';
import { verifyGithubPayload } from './webhook';
import { sendVerificationEmail } from './emailer';
import { generateSignedPutUrl, generateSignedGetUrl } from './AWSPresigner'
import { stringify } from 'querystring';

const PORT = process.env.PORT;
const app: express.Express = express();
let isServerOutdated = false;

app.use((req, res, next) => {
    if (!isServerOutdated) next();
    else res.status(503).send("Server is updating...").end();
});

app.use(_bodyParser());

app.get("/", (req, res) => {
    res.status(200).send("Websona Backend");
});

if (process.env.NODE_ENV === "test") {
    app.get("/token", (req, res) => {
        const email = req.query.name;
        if (!email) {
            res.status(400).send('Missing username for access token request');
            return;
        }

        const accessToken: string = generateAccessToken({ email: email as string, firstName: "" });
        res.status(200).send(accessToken);
    });
}


app.post("/signup", (req, res) => {
    const currentDate = (new Date()).valueOf().toString();
    const random = Math.random().toString();

    const requestData: SignUpInfo = {
        firstName: req.body.first,
        lastName: req.body.last,
        email: req.body.email,
        phone: req.body.phone,
        password: bcrypt.hashSync(req.body.password, 10),
        activationId: createHash('sha1').update(currentDate + random).digest('hex'),
        socials: [],
        contacts: []
    };

    insertUser(requestData)
        .then(async (result) => {
            if (process.env.NODE_ENV !== 'test') sendVerificationEmail(requestData.activationId, requestData.email)
                .catch((err) => console.log(err));

            const accessToken: string = generateAccessToken({
                firstName: requestData.firstName,
                email: requestData.email
            } as AccessToken);
            res.status(201).send({
                accessToken,
                tokenExpiryTime
            });
        })
        .catch((err) => {
            // unsuccessful insert, reply back with unsuccess response code
            console.log(err);
            res.status(500).send("Insert Failed");
        });

});

app.post("/login", (req, res) => {
    const requestData: LoginInfo = {
        email: req.body.email,
        password: req.body.password,
    };
    fetchUsers({ email: requestData.email })
        .then((users: User[] | MongoError) => {
            const user: User = users[0];
            if (user.activationId) {
                res.status(403).send("Account isn't verified. Check your email for the verification mail");
                return;
            }
            if (bcrypt.compareSync(requestData.password, user.password)) {
                // Passwords match
                const accessToken: string = generateAccessToken({
                    firstName: user.firstName,
                    email: user.email
                } as AccessToken);
                res.status(200).send({
                    accessToken,
                    tokenExpiryTime
                });
            } else {
                // Passwords don't match
                res.status(401).send("Invalid password");
            }
        })
        .catch((err) => {
            console.log(err);
            res.status(500).send("Server error");
        });
});

app.get("/verify/:id", (req, res) => {
    if (!req.params.id) res.status(400).send("Missing activation id").end();
    else {
        fetchUsers({ activationId: req.params.id }).then((users: User[]) => {
            if (users.length === 0) res.status(404).send("User not found");
            else {
                updateUser({ activationId: undefined }, { _id: users[0]._id })
                    .then((val) => res.status(201).send("Verification Successful"))
                    .catch((err) => res.status(500).send("500: Server Error. Verification failed"));
            }

        });
    }
});

app.post('/updateWebhook', (req, res) => {
    if (!verifyGithubPayload(req)) {
        res.status(401).send("Payload couldn't be verified").end();
        return;
    }
    const isMaster = req.body.ref === "refs/heads/master";
    if (isMaster) {
        isServerOutdated = true;
    }

    res.status(200);
    res.end();
});

app.get("/code/:id", (req, res) => {
    const codeId = req.params.id;
    fetchCodes({ id: codeId }).then(async (codes) => {
        codes = codes as Code[];
        if (codes.length === 0) {
            res.status(404).send('Code not found');
            return;
        }

        if (!(await authenticateTokenReturn(req))) {
            // send the playstore/appstore link page. This is just a placeholder
            res.status(403).send(`
            <html>
                <body>
                    <span>Please download the app to continue</span>
                </body>
            </html>`).end();
            return;
        }

        const email = codes[0].owner;
        fetchUsers({ email }).then((users) => {
            users = users as User[];
            if (users.length === 0) {
                res.status(404).send('User not found');
                return;
            }
            const user = users[0] as PartialUserData;
            // delete unneccessary fields
            delete user.password;
            delete user.phone;
            delete user.activationId;
            delete user.email;
            delete user.codes;
            // only provide socials associated with the code
            user.socials = (codes[0] as Code).socials;
            res.status(200).send(user);
        }).catch((err) => {
            console.log(err);
            res.status(500).send('500: Internal Server Error during db fetch');
        })
    });
});

app.get("/getContact", async (req, res) => {
    const user = req.query.email;
    fetchUsers({ email: user }).then(async (users: User[]) => {
        if (users.length === 0) res.status(404).send("User not found");
        else {
            const userContacts = users[0].contacts;
            res.status(201).send(userContacts);
        }
    }).catch((err) => {
        console.log(err);
        res.status(500).send('500: Internal Server Error during db fetch');
    });
});


// routes created after the line below will be reachable only by the clients
// with a valid access token
app.use(authenticateToken);

app.get("/updateProfilePicture", async (req, res) => {
    const token = req.headers.authorization?.split(' ')[1] as string;
    const decodedToken = jwt.decode(token) as AccessToken;
    const email = decodedToken.email;
    const profilePicture = bcrypt.hashSync(email, 1);
    const url = await generateSignedPutUrl("profile-pictures/" + profilePicture, req.query.type);
    res.status(200).send(url);
});

app.get("/protectedResource", (req, res) => {
    res.status(200).send("This is a protected resource");
});

app.post("/addContact", async (req, res) => {
    const token = req.headers.authorization?.split(' ')[1] as string;
    const user1 = (jwt.decode(token) as AccessToken).email;
    const code_id = req.body.code_id;

    try {
        const codes = await fetchCodes({ id: code_id }) as Code[];
        const code = codes[0]

        fetchUsers({ email: user1 }).then(async (users: User[]) => {
            if (users.length === 0) res.status(404).send("User not found");
            else {
                const userContacts = users[0].contacts;
                const shared = [] as any;
                for (const x of code.socials) {
                    shared.push({ social: x.social, username: x.username })
                }
                let contactId: ObjectId | null = null;
                let owner = "";
                try {
                    const ownerList = (await fetchUsers({ email: code.owner }));
                    contactId = (ownerList)[0]._id;
                    owner = (ownerList)[0].firstName + " " + (ownerList)[0].lastName;
                } catch (error) {
                    res.status(500).send("500: Server Error. Failed to add contact").end();
                }
                const contact: Contact = { id: contactId as ObjectId, user: owner, sharedSocials: shared }
                userContacts.push(contact)
                updateUser({ contacts: userContacts }, { email: users[0].email })
                    .then((val) => res.status(201).send("Contact added successfully"))
                    .catch((err) => res.status(500).send("500: Server Error. Failed to add contact"));
            }

        }).catch((err) => {
            console.log(err);
            res.status(500).send('500: Internal Server Error during db fetch');
        });


    } catch (error) {
        return null;
    }
});

app.get("/user/:email", (req, res) => {
    fetchUsers({ email: req.params.email })
        .then(async (users: User[] | MongoError) => {
            const user: PartialUserData = users[0];
            const codes = await fetchCodes({ owner: user.email }) as Code[];

            // generate get urls for all the codes so the app can load the images for the codes
            for await (const code of codes) {
                const url = await generateSignedGetUrl("codes/" + code.id, 120);
                code.url = url;
            }

            user.codes = codes;
            delete user.password;

            res.status(200).send(user);
        })
        .catch((err) => {
            console.log(err);
            res.status(500).send("Server error");
        });
})

app.post("/updateUser", (req, res) => {
    const token = req.headers.authorization?.split(' ')[1] as string;
    const decodedToken = jwt.decode(token) as AccessToken;
    const singleUser: PartialUserData = {
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        phone: req.body.phone,
        email: decodedToken.email,
        socials: req.body.socials
    };
    fetchUsers({ email: singleUser.email }).
        then((users: User[] | MongoError) => {
            const user: User = users[0];
            const emailT = singleUser.email;
            delete singleUser.email;
            updateUser(singleUser, { email: emailT })
            res.status(200).send("update successful")
        }
        ).catch((err) => {
            res.status(500).send("Error with server")
        })
})

app.post("/newCode", async (req, res) => {
    const codeId = await getUniqueCodeId();
    if (codeId === null) res.status(500).send('500: Internal Server Error during db lookup').end();
    else {
        // generate a PUT URL to allow for qr code upload from client
        const putUrl = await generateSignedPutUrl('codes/' + codeId, 'image/png');
        const token = req.headers.authorization?.split(' ')[1] as string;
        const decodedToken = jwt.decode(token) as AccessToken;
        const socials = req.body.socials;
        objectCleanup(socials);
        // insert code into db
        insertCode({ id: codeId, socials, owner: decodedToken.email }).then((writeResult) => {
            res.status(201).send({ codeId, putUrl });
            // enqueue a get request for this qr for future to verify
            // if client uploaded the code or not. On failure, delete this entry
            // from the database
            setTimeout(verifyQRupload, 1000 * 10, codeId);
        }).catch((err) => {
            console.log(err);
            res.status(500).send('500: Internal Server Error during db insertion');
        });
    }
});

app.listen(process.env.PORT || PORT, () => {
    console.log(`Listening at http://localhost:${process.env.PORT || PORT}`);
});

/**
 * Generate unique id for a qr code
 */
async function getUniqueCodeId() {
    const currentDate = (new Date()).valueOf().toString();
    const random = Math.random().toString();

    while (true) {
        const newId = createHash('sha1').update(currentDate + random).digest('hex');
        try {
            const codes = await fetchCodes({ id: newId }) as Code[];
            if (codes.length === 0) return newId;
        } catch (error) {
            return null;
        }
    }
}

/**
 * Check if the code's image was uploaded to s3. If not, delete entry from the database
 * @param codeId code id for code whose upload needs to be validated
 */
async function verifyQRupload(codeId: string): Promise<void> {
    const downloadUrl = await generateSignedGetUrl('codes/' + codeId, 3000);
    https.get(downloadUrl as string, ((res) => {
        if (res.statusCode !== 200) {
            // client didn't upload the code, delete it's entry from db
            deleteCode(codeId);
        }
    }));
}

/**
 * Delete invalid entries from an object
 * @param obj object to clean up
 */
function objectCleanup(obj: object) {
    const keys = Object.keys(obj);
    const keysToRemove: any[] = [];
    for (const key of keys) {
        if (key.trim().length === 0) keysToRemove.push(key);
        else if (key === "null" || key === "undefined") keysToRemove.push(key);
    }

    while (keysToRemove.length > 0) {
        delete obj[keysToRemove[0]];
        keysToRemove.shift();
    }
}

export default app;
