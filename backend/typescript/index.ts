import dotenv from 'dotenv';
dotenv.config();
import express from 'express';
import https from 'https';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { createHash } from 'crypto';
import { insertUser, fetchUsers, updateUser, fetchCodes, insertCode, deleteCode, insertEvent, deleteEvent, fetchEvents } from "./utils/DatabaseHandler";
import { authenticateToken, generateAccessToken, tokenExpiryTime } from './authentication';
import { SignUpInfo, LoginInfo, User, Code, PartialUserData, Event } from './interfaces';
import { MongoError, ObjectId } from 'mongodb';
import { json as _bodyParser } from 'body-parser';
import { verifyGithubPayload } from './webhook';
import { sendVerificationEmail } from './emailer';

import { generateSignedPutUrl, generateSignedGetUrl, deleteObject } from './AWSPresigner'

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

        const accessToken: string = generateAccessToken({ email });
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
        socials: [],
        activationId: createHash('sha1').update(currentDate + random).digest('hex')
    };

    insertUser(requestData)
        .then(async (result) => {
            if (process.env.NODE_ENV !== 'test') sendVerificationEmail(requestData.activationId, requestData.email)
                .catch((err) => console.log(err));

            const accessToken: string = generateAccessToken({
                firstName: requestData.firstName,
                email: requestData.email
            });
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
                });
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

// routes created after the line below will be reachable only by the clients
// with a valid access token
app.use(authenticateToken);

app.get("/updateProfilePicture", async (req, res) => {
    const email = req.query.email;
    const profilePicture = bcrypt.hashSync(email, 1);
    const url = await generateSignedPutUrl("profile-pictures/" + profilePicture, req.query.type);
    res.status(200).send(url);
});

app.get("/protectedResource", (req, res) => {
    res.status(200).send("This is a protected resource");
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
    const singleUser: PartialUserData = {
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        phone: req.body.phone,
        email: req.body.email,
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
        const decodedToken = jwt.decode(token) as { [key: string]: any };
        const socials = req.body.socials;
        const type = req.query.type as string;
        // insert code into db
        insertCode({ id: codeId, socials, owner: decodedToken.email, type }).then((writeResult) => {
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

app.get("/code/:id", (req, res) => {
    const codeId = req.params.id;
    fetchCodes({ id: codeId }).then((codes) => {
        codes = codes as Code[];
        if (codes.length === 0) {
            res.status(404).send('Code not found');
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
    }).catch((err) => {
        console.log(err);
        res.status(500).send('500: Internal Server Error during db fetch');
    })
});

app.get("/events", (req, res) => {
    const token = req.headers.authorization?.split(' ')[1] as string;
    const decodedToken = jwt.decode(token) as { [key: string]: any };
    fetchEvents({ owner: decodedToken.email }).then((events) => {
        res.status(200).send(events);
    }).catch((err) => res.status(500).send("500: Server Error"));
});

app.post("/newEvent", async (req, res) => {
    const token = req.headers.authorization?.split(' ')[1] as string;
    const decodedToken = jwt.decode(token) as { [key: string]: any };
    // check all args are there in the body
    if (!validateObjectProps(req.body, ["codeId", "name", "location", "date"])) {
        res.status(400).send("missing parameters in the request");
        return;
    }
    const event: Event = {
        codeId: req.body.codeId,
        owner: decodedToken.email,
        name: req.body.name,
        location: req.body.location,
        date: Number(req.body.date),
        attendees: []
    };

    try {
        await insertEvent(event);
        res.status(201).send("success").end();
    } catch (error) {
        console.log(error);
        res.status(500).send("500: Server error, try again later");
    }
});

app.post("/deleteEvent", async (req, res) => {
    const token = req.headers.authorization?.split(' ')[1] as string;
    const decodedToken = jwt.decode(token) as { [key: string]: any };
    const email = decodedToken.email;
    if (!req.body.id) {
        res.status(400).send("missing parameters in the request");
        return;
    }

    const _id = ObjectId.createFromHexString(req.body.id);

    const events: Event[] = (await fetchEvents({ _id })) as Event[];
    if (events.length === 0) {
        res.status(404).send("no such event found");
        return;
    }

    const event = events[0];
    if (event.owner !== email) {
        res.status(403).send("User not authorized to delete this event");
        return;
    }

    deleteEvent(_id);
    deleteCode(event.codeId);
    deleteObject(`codes/${event.codeId}`);
    res.status(201).send("success");
})

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
 * Check if the given object has all the required keys
 * @param obj Object to validate
 * @param requiredKeys the keys that must be present in the object
 */
function validateObjectProps(obj: object, requiredKeys: string[]): boolean {
    const keys = Object.keys(obj);
    for (const key of requiredKeys) {
        if (keys.findIndex((val) => val === key) === -1) return false;
    }
    return true;
}

export default app;
