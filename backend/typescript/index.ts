import dotenv from 'dotenv';
import express from 'express';
import bcrypt from 'bcrypt';
import { insertUser, fetchUsers } from "./utils/DatabaseHandler";
import { authenticateToken, generateAccessToken } from './authentication';
import { SignUpInfo, LoginInfo } from './interfaces';

dotenv.config();
const PORT = process.env.PORT;
const app: express.Express = express();

app.get("/", (req, res) => {
    res.status(200).send("Websona Backend");
});


/**
 * Sample route on how to generate access tokens for a user. On the actual route,
 * we need to first authenticate a user and then issue an access token.
 *
 * ** This is for reference only **
 *
 * Once actual login/signup is implemented, we need to re-write an actual token route
 * with authentication
 */
app.get("/token", (req, res) => {
    const username = req.query.name;
    if (!username) {
        res.status(400).send('Missing username for access token request');
        return;
    }

    const accessToken: string = generateAccessToken({ username });
    res.status(200).send(accessToken);
});


app.post("/signup", (req, res) => {

	const requestData: SignUpInfo = {
        firstName: req.body.first,
        lastName: req.body.last,
		email: req.body.email,
		password: bcrypt.hashSync(req.body.password, 10)
	};

    insertUser(requestData)
		.then(async (result) => {
            const accessToken: string = generateAccessToken( requestData );
            res.status(200).send(accessToken);
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
        .then((users) => {
            const user = users[0];
            if (bcrypt.compareSync(requestData.password, user.password)) {
                // Passwords match
                delete user.password;
                const accessToken: string = generateAccessToken( requestData );
                res.status(200).send(accessToken);
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
