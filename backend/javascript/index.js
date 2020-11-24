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
var __asyncValues = (this && this.__asyncValues) || function (o) {
    if (!Symbol.asyncIterator) throw new TypeError("Symbol.asyncIterator is not defined.");
    var m = o[Symbol.asyncIterator], i;
    return m ? m.call(o) : (o = typeof __values === "function" ? __values(o) : o[Symbol.iterator](), i = {}, verb("next"), verb("throw"), verb("return"), i[Symbol.asyncIterator] = function () { return this; }, i);
    function verb(n) { i[n] = o[n] && function (v) { return new Promise(function (resolve, reject) { v = o[n](v), settle(resolve, reject, v.done, v.value); }); }; }
    function settle(resolve, reject, d, v) { Promise.resolve(v).then(function(v) { resolve({ value: v, done: d }); }, reject); }
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const dotenv_1 = __importDefault(require("dotenv"));
dotenv_1.default.config();
const express_1 = __importDefault(require("express"));
const https_1 = __importDefault(require("https"));
const bcrypt_1 = __importDefault(require("bcrypt"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const crypto_1 = require("crypto");
const DatabaseHandler_1 = require("./utils/DatabaseHandler");
const authentication_1 = require("./authentication");
const body_parser_1 = require("body-parser");
const webhook_1 = require("./webhook");
const emailer_1 = require("./emailer");
const AWSPresigner_1 = require("./AWSPresigner");
const PORT = process.env.PORT;
const app = express_1.default();
let isServerOutdated = false;
app.use((req, res, next) => {
    if (!isServerOutdated)
        next();
    else
        res.status(503).send("Server is updating...").end();
});
app.use(body_parser_1.json());
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
        const accessToken = authentication_1.generateAccessToken({ email });
        res.status(200).send(accessToken);
    });
}
app.post("/signup", (req, res) => {
    const currentDate = (new Date()).valueOf().toString();
    const random = Math.random().toString();
    const requestData = {
        firstName: req.body.first,
        lastName: req.body.last,
        email: req.body.email,
        phone: req.body.phone,
        password: bcrypt_1.default.hashSync(req.body.password, 10),
        socials: [],
        activationId: crypto_1.createHash('sha1').update(currentDate + random).digest('hex')
    };
    DatabaseHandler_1.insertUser(requestData)
        .then((result) => __awaiter(void 0, void 0, void 0, function* () {
        if (process.env.NODE_ENV !== 'test')
            emailer_1.sendVerificationEmail(requestData.activationId, requestData.email)
                .catch((err) => console.log(err));
        const accessToken = authentication_1.generateAccessToken({
            firstName: requestData.firstName,
            email: requestData.email
        });
        res.status(201).send({
            accessToken,
            tokenExpiryTime: authentication_1.tokenExpiryTime
        });
    }))
        .catch((err) => {
        // unsuccessful insert, reply back with unsuccess response code
        console.log(err);
        res.status(500).send("Insert Failed");
    });
});
app.post("/login", (req, res) => {
    const requestData = {
        email: req.body.email,
        password: req.body.password,
    };
    DatabaseHandler_1.fetchUsers({ email: requestData.email })
        .then((users) => {
        const user = users[0];
        if (user.activationId) {
            res.status(403).send("Account isn't verified. Check your email for the verification mail");
            return;
        }
        if (bcrypt_1.default.compareSync(requestData.password, user.password)) {
            // Passwords match
            const accessToken = authentication_1.generateAccessToken({
                firstName: user.firstName,
                email: user.email
            });
            res.status(200).send({
                accessToken,
                tokenExpiryTime: authentication_1.tokenExpiryTime
            });
        }
        else {
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
    if (!req.params.id)
        res.status(400).send("Missing activation id").end();
    else {
        DatabaseHandler_1.fetchUsers({ activationId: req.params.id }).then((users) => {
            if (users.length === 0)
                res.status(404).send("User not found");
            else {
                DatabaseHandler_1.updateUser({ activationId: undefined }, { _id: users[0]._id })
                    .then((val) => res.status(201).send("Verification Successful"))
                    .catch((err) => res.status(500).send("500: Server Error. Verification failed"));
            }
        });
    }
});
app.post('/updateWebhook', (req, res) => {
    if (!webhook_1.verifyGithubPayload(req)) {
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
app.use(authentication_1.authenticateToken);
app.get("/updateProfilePicture", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const email = req.query.email;
    const profilePicture = bcrypt_1.default.hashSync(email, 1);
    const url = yield AWSPresigner_1.generateSignedPutUrl("profile-pictures/" + profilePicture, req.query.type);
    res.status(200).send(url);
}));
app.get("/protectedResource", (req, res) => {
    res.status(200).send("This is a protected resource");
});
app.get("/user/:email", (req, res) => {
    DatabaseHandler_1.fetchUsers({ email: req.params.email })
        .then((users) => __awaiter(void 0, void 0, void 0, function* () {
        var e_1, _a;
        const user = users[0];
        const codes = yield DatabaseHandler_1.fetchCodes({ owner: user.email });
        try {
            // generate get urls for all the codes so the app can load the images for the codes
            for (var codes_1 = __asyncValues(codes), codes_1_1; codes_1_1 = yield codes_1.next(), !codes_1_1.done;) {
                const code = codes_1_1.value;
                const url = yield AWSPresigner_1.generateSignedGetUrl("codes/" + code.id, 30);
                code.url = url;
            }
        }
        catch (e_1_1) { e_1 = { error: e_1_1 }; }
        finally {
            try {
                if (codes_1_1 && !codes_1_1.done && (_a = codes_1.return)) yield _a.call(codes_1);
            }
            finally { if (e_1) throw e_1.error; }
        }
        user.codes = codes;
        delete user.password;
        res.status(200).send(user);
    }))
        .catch((err) => {
        console.log(err);
        res.status(500).send("Server error");
    });
});
app.post("/updateUser", (req, res) => {
    const singleUser = {
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        phone: req.body.phone,
        email: req.body.email,
        socials: req.body.socials
    };
    DatabaseHandler_1.fetchUsers({ email: singleUser.email }).
        then((users) => {
        const user = users[0];
        const emailT = singleUser.email;
        delete singleUser.email;
        DatabaseHandler_1.updateUser(singleUser, { email: emailT });
        res.status(200).send("update successful");
    }).catch((err) => {
        res.status(500).send("Error with server");
    });
});
app.post("/newCode", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    const codeId = yield getUniqueCodeId();
    if (codeId === null)
        res.status(500).send('500: Internal Server Error during db lookup').end();
    else {
        // generate a PUT URL to allow for qr code upload from client
        const putUrl = yield AWSPresigner_1.generateSignedPutUrl('codes/' + codeId, 'image/png');
        const token = (_a = req.headers.authorization) === null || _a === void 0 ? void 0 : _a.split(' ')[1];
        const decodedToken = jsonwebtoken_1.default.decode(token);
        const socials = req.body.socials;
        // insert code into db
        DatabaseHandler_1.insertCode({ id: codeId, socials, owner: decodedToken.email }).then((writeResult) => {
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
}));
app.get("/code/:id", (req, res) => {
    const codeId = req.params.id;
    DatabaseHandler_1.fetchCodes({ id: codeId }).then((codes) => {
        codes = codes;
        if (codes.length === 0) {
            res.status(404).send('Code not found');
            return;
        }
        const email = codes[0].owner;
        DatabaseHandler_1.fetchUsers({ email }).then((users) => {
            users = users;
            if (users.length === 0) {
                res.status(404).send('User not found');
                return;
            }
            const user = users[0];
            // delete unneccessary fields
            delete user.password;
            delete user.phone;
            delete user.activationId;
            delete user.email;
            delete user.codes;
            // only provide socials associated with the code
            user.socials = codes[0].socials;
            res.status(200).send(user);
        }).catch((err) => {
            console.log(err);
            res.status(500).send('500: Internal Server Error during db fetch');
        });
    }).catch((err) => {
        console.log(err);
        res.status(500).send('500: Internal Server Error during db fetch');
    });
});
app.listen(process.env.PORT || PORT, () => {
    console.log(`Listening at http://localhost:${process.env.PORT || PORT}`);
});
/**
 * Generate unique id for a qr code
 */
function getUniqueCodeId() {
    return __awaiter(this, void 0, void 0, function* () {
        const currentDate = (new Date()).valueOf().toString();
        const random = Math.random().toString();
        while (true) {
            const newId = crypto_1.createHash('sha1').update(currentDate + random).digest('hex');
            try {
                const codes = yield DatabaseHandler_1.fetchCodes({ id: newId });
                if (codes.length === 0)
                    return newId;
            }
            catch (error) {
                return null;
            }
        }
    });
}
function verifyQRupload(codeId) {
    return __awaiter(this, void 0, void 0, function* () {
        const downloadUrl = yield AWSPresigner_1.generateSignedGetUrl('codes/' + codeId, 3000);
        https_1.default.get(downloadUrl, ((res) => {
            if (res.statusCode !== 200) {
                // client didn't upload the code, delete it's entry from db
                DatabaseHandler_1.deleteCode(codeId);
            }
        }));
    });
}
exports.default = app;
