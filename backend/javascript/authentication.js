"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateAccessToken = exports.authenticateTokenReturn = exports.authenticateToken = exports.tokenExpiryTime = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
exports.tokenExpiryTime = 3600;
/**
 * Authenticate incoming request. If the incoming request contains a valid authorization token, call the
 * next middleware. Otherwise respond with a 401 (Forbidden)
 * @param req Express Request object
 * @param res Express Response object
 * @param next next middleware
 */
function authenticateToken(req, res, next) {
    const authHeader = req.headers.authorization;
    if (!authHeader)
        return res.status(401).send("No authorization token found in the request header");
    const token = authHeader.split(' ')[1];
    jsonwebtoken_1.default.verify(token, process.env.JWT_TOKEN_SECRET, (err, user) => {
        if (err) {
            res.status(401).send(`${err.name}: ${err.message}`);
        }
        else {
            next(); // user is authorized, let them access the requested resource
        }
    });
}
exports.authenticateToken = authenticateToken;
/**
 * Authenticate this request. Returns a promise which resolve to true if
 * auth successful, else false
 * @param req Express Request object
 * @returns promise which resolves to true if auth successful, else false
 */
function authenticateTokenReturn(req) {
    return new Promise((resolve, reject) => {
        const authHeader = req.headers.authorization;
        if (!authHeader)
            resolve(false);
        const token = authHeader.split(' ')[1];
        jsonwebtoken_1.default.verify(token, process.env.JWT_TOKEN_SECRET, (err, user) => {
            if (err)
                resolve(false);
            else
                resolve(true); // user is authorized, let them access the requested resource
        });
    });
}
exports.authenticateTokenReturn = authenticateTokenReturn;
/**
 * Generate access token for an authenticated user. The generated access token will be valid for 3600 seconds, i.e., an hour.
 * Once the access token expires, user will need to request a new access token
 * @param uid Unique identifier for a user. This is used in the hashing process when generating the jwt
 */
function generateAccessToken(uid) {
    return jsonwebtoken_1.default.sign(uid, process.env.JWT_TOKEN_SECRET, { expiresIn: exports.tokenExpiryTime });
}
exports.generateAccessToken = generateAccessToken;
