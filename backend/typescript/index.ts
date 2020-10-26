import dotenv from 'dotenv';
import express from 'express';
import { authenticateToken, generateAccessToken } from './authentication';

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

// routes created after the line below will be reachable only by the clients
// with a valid access token
app.use(authenticateToken);

app.get("/protectedResource", (req, res) => {
    res.status(200).send("This is a protected resource");
});


app.listen(process.env.PORT || PORT, () => {
    console.log(`Listening at http://localhost:${process.env.PORT || PORT}`);
});

