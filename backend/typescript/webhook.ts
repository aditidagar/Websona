import {createHmac, timingSafeEqual} from 'crypto';
import Express from 'express';

// Utility file to verify webhooks

const createComparisonSignature = (body) => {
  const hmac = createHmac('sha1', process.env.WEBHOOK_SECRET as string);
  const self_signature = hmac.update(JSON.stringify(body)).digest('hex');
  return `sha1=${self_signature}`; // shape in GitHub header
}

const compareSignatures = (signature, comparison_signature) => {
  const source = Buffer.from(signature);
  const comparison = Buffer.from(comparison_signature);
  return timingSafeEqual(source, comparison); // constant time comparison
}

export const verifyGithubPayload = (req: Express.Request) => {
  const { headers, body } = req;

  const signature = headers['x-hub-signature'];
  const comparison_signature = createComparisonSignature(body);

  return compareSignatures(signature, comparison_signature);
}