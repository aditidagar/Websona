import dotenv from 'dotenv';
dotenv.config();
import express from 'express';
import bcrypt from 'bcrypt';
import { insertUser, fetchUsers } from "./utils/DatabaseHandler";
import { authenticateToken, generateAccessToken, tokenExpiryTime } from './authentication';
import { SignUpInfo, LoginInfo, User } from './interfaces';
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

app.get("/updateProfilePicture", async (req, res) => {
	const email = req.params.email;
	const url = await generateSignedPutUrl("profile-pictures/" + email);
	res.status(200).send(url);
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
