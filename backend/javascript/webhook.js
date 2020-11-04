"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.verifyGithubPayload = void 0;
const crypto_1 = require("crypto");
// Utility file to verify webhooks
const createComparisonSignature = (body) => {
    const hmac = crypto_1.createHmac('sha1', process.env.WEBHOOK_SECRET);
    const selfSignature = hmac.update(JSON.stringify(body)).digest('hex');
    return `sha1=${selfSignature}`; // shape in GitHub header
};
const compareSignatures = (signature, comparisonSignature) => {
    const source = Buffer.from(signature);
    const comparison = Buffer.from(comparisonSignature);
    return crypto_1.timingSafeEqual(source, comparison); // constant time comparison
};
exports.verifyGithubPayload = (req) => {
    const { headers, body } = req;
    const signature = headers['x-hub-signature'];
    const comparisonSignature = createComparisonSignature(body);
    return compareSignatures(signature, comparisonSignature);
};
