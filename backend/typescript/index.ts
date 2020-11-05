import dotenv from 'dotenv';
dotenv.config();
import express from 'express';
import bcrypt from 'bcrypt';
import { createHash } from 'crypto';
import { insertUser, fetchUsers, updateUser } from "./utils/DatabaseHandler";
import { authenticateToken, generateAccessToken, tokenExpiryTime } from './authentication';
import { SignUpInfo, LoginInfo, User } from './interfaces';
import { MongoError } from 'mongodb';
import { json as _bodyParser } from 'body-parser';
import { verifyGithubPayload } from './webhook';
import { sendVerificationEmail } from './emailer';


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
    const currentDate = (new Date()).valueOf().toString();
    const random = Math.random().toString();

	const requestData: SignUpInfo = {
        firstName: req.body.first,
        lastName: req.body.last,
		email: req.body.email,
        password: bcrypt.hashSync(req.body.password, 10),
        activationId: createHash('sha1').update(currentDate + random).digest('hex')
	};

    insertUser(requestData)
		.then(async (result) => {
            sendVerificationEmail(requestData.activationId, requestData.email)
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

app.get("/protectedResource", (req, res) => {
    res.status(200).send("This is a protected resource");
});


app.listen(process.env.PORT || PORT, () => {
    console.log(`Listening at http://localhost:${process.env.PORT || PORT}`);
});

export default app;
