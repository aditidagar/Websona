"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const dotenv_1 = __importDefault(require("dotenv"));
const express_1 = __importDefault(require("express"));
const authentication_1 = require("./authentication");
dotenv_1.default.config();
const PORT = process.env.PORT;
const app = express_1.default();
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
    const accessToken = authentication_1.generateAccessToken({ username });
    res.status(200).send(accessToken);
});
// routes created after the line below will be reachable only by the clients
// with a valid access token
app.use(authentication_1.authenticateToken);
app.get("/protectedResource", (req, res) => {
    res.status(200).send("This is a protected resource");
});
app.listen(process.env.PORT || PORT, () => {
    console.log(`Listening at http://localhost:${process.env.PORT || PORT}`);
});
exports.default = app;
