"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateSignedPutUrl = void 0;
const aws_sdk_1 = __importDefault(require("aws-sdk"));
aws_sdk_1.default.config = new aws_sdk_1.default.Config({
    accessKeyId: process.env.ACCESS_KEY,
    secretAccessKey: process.env.SECRET_KEY,
    region: process.env.BUCKET_REGION,
});
const Bucket = process.env.BUCKET_NAME;
const S3 = new aws_sdk_1.default.S3();
function generateSignedPutUrl(Key, filetype) {
    return new Promise((resolve, reject) => {
        const params = {
            Bucket,
            Key,
            Expires: 30,
            ContentType: filetype === undefined ? "image/jpeg" : filetype,
        };
        S3.getSignedUrl("putObject", params, (err, url) => {
            if (err)
                reject(err);
            else
                resolve(url);
        });
    });
}
exports.generateSignedPutUrl = generateSignedPutUrl;
