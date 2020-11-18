import dotenv from 'dotenv';
dotenv.config();
import express from 'express';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { createHash } from 'crypto';
import { insertUser, fetchUsers, updateUser, fetchCodes, insertCode } from "./utils/DatabaseHandler";
import { authenticateToken, generateAccessToken, tokenExpiryTime } from './authentication';
import { SignUpInfo, LoginInfo, User, Code } from './interfaces';
import { MongoError } from 'mongodb';
import { json as _bodyParser } from 'body-parser';
import { verifyGithubPayload } from './webhook';
import { generateSignedPutUrl} from './AWSPresigner'

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
        const username = req.query.name;
        if (!username) {
            res.status(400).send('Missing username for access token request');
            return;
        }

        const accessToken: string = generateAccessToken({ username });
        res.status(200).send(accessToken);
    });
}


app.post("/signup", (req, res) => {

	const requestData: SignUpInfo = {
        firstName: req.body.first,
        lastName: req.body.last,
		email: req.body.email,
		password: bcrypt.hashSync(req.body.password, 10)
	};

    insertUser(requestData)
		.then(async (result) => {
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

app.post("/newCode", async (req, res) => {
    const codeId = await getUniqueCodeId();
    if (codeId === null) res.status(500).send('500: Internal Server Error during db lookup').end();
    else {
        // generate a PUT URL to allow for qr code upload from client (waiting on aditi's task)
        const putUrl = "";
        const token = req.headers.authorization?.split(' ')[1] as string;
        const decodedToken = jwt.decode(token) as { [key: string]: any };
        // insert code into db
        insertCode({ id: codeId, src: putUrl, owner: decodedToken.email }).then((writeResult) => {
            res.status(201).send({ codeId, putUrl});
            // enqueue a get request for this qr for future (60 seconds or so?)
            // to verify if client uploaded the code or not. On failure, delete this entry
            // from the database (waiting on aditi's task to implement this)
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

            res.status(200).send(users[0]);
        }).catch((err) => {
            console.log(err);
            res.status(500).send('500: Internal Server Error during db fetch');
        })
    }).catch((err) => {
        console.log(err);
        res.status(500).send('500: Internal Server Error during db fetch');
    })
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

export default app;
