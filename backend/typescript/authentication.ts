import jwt from 'jsonwebtoken';
import Express from 'express';
import { AccessToken } from './interfaces';

export const tokenExpiryTime: number = 3600;
/**
 * Authenticate incoming request. If the incoming request contains a valid authorization token, call the
 * next middleware. Otherwise respond with a 401 (Forbidden)
 * @param req Express Request object
 * @param res Express Response object
 * @param next next middleware
 */
export function authenticateToken(req: Express.Request, res: Express.Response, next) {
    const authHeader = req.headers.authorization;
    if (!authHeader) return res.status(401).send("No authorization token found in the request header");

    const token = authHeader.split(' ')[1];
    jwt.verify(token, process.env.JWT_TOKEN_SECRET as string, (err, user) => {
        if (err) {
            res.status(401).send(`${err.name}: ${err.message}`);
        } else {
            next(); // user is authorized, let them access the requested resource
        }
    });
}

/**
 * Generate access token for an authenticated user. The generated access token will be valid for 3600 seconds, i.e., an hour.
 * Once the access token expires, user will need to request a new access token
 * @param uid Unique identifier for a user. This is used in the hashing process when generating the jwt
 */
export function generateAccessToken(uid: AccessToken): string {
    return jwt.sign(uid, process.env.JWT_TOKEN_SECRET as string, { expiresIn: tokenExpiryTime });
}
