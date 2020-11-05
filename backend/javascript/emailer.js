"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendVerificationEmail = void 0;
const nodemailer_1 = require("nodemailer");
function sendVerificationEmail(activationId, to) {
    const transporter = nodemailer_1.createTransport(`smtps://${process.env.GMAIL_USER}%40gmail.com:${process.env.GMAIL_PASS}@smtp.gmail.com`);
    const verificationURL = `http://localhost:3000/verify/${activationId}`;
    const mailOptions = {
        from: 'noreply.websona@gmail.com',
        to,
        subject: 'Websona Account Registration',
        text: `Please verify your email to finish registration for Websona: ${verificationURL}`,
        html: `<span>Please <a href=${verificationURL}>verify</a> your email to finish registration for Websona</span>`
    };
    return new Promise((resolve, reject) => {
        transporter.sendMail(mailOptions, (err, info) => {
            if (err) {
                reject(false);
            }
            else {
                resolve(true);
            }
        });
    });
}
exports.sendVerificationEmail = sendVerificationEmail;
