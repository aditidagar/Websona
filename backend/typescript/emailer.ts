import { createTransport, SendMailOptions } from 'nodemailer';

export function sendVerificationEmail(activationId: string, to: string): Promise<boolean> {
    const transporter = createTransport(`smtps://${process.env.GMAIL_USER}%40gmail.com:${process.env.GMAIL_PASS}@smtp.gmail.com`);

    const verificationURL = `http://websona-alb-356962330.us-east-1.elb.amazonaws.com/verify/${activationId}`;
    const mailOptions: SendMailOptions = {
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
            } else {
                resolve(true);
            }
        })
    });
}
