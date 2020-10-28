"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const dotenv_1 = __importDefault(require("dotenv"));
const express_1 = __importDefault(require("express"));
const bcrypt_1 = __importDefault(require("bcrypt"));
const DatabaseHandler_1 = require("./utils/DatabaseHandler");
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
app.post("/signup", (req, res) => {
    const requestData = {
        firstName: req.body.first,
        lastName: req.body.last,
        email: req.body.email,
        password: bcrypt_1.default.hashSync(req.body.password, 10)
    };
    DatabaseHandler_1.insertUser(requestData)
        .then((result) => __awaiter(void 0, void 0, void 0, function* () {
        res.status(201).send("success");
    }))
        .catch((err) => {
        // unsuccessful insert, reply back with unsuccess response code
        console.log(err);
        res.status(500).send("Insert Failed");
    });
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
