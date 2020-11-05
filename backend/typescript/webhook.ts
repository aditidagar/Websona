import {createHmac, timingSafeEqual} from 'crypto';
import Express from 'express';

// Utility file to verify webhooks

const createComparisonSignature = (body) => {
  const hmac = createHmac('sha1', process.env.WEBHOOK_SECRET as string);
  const selfSignature = hmac.update(JSON.stringify(body)).digest('hex');
  return `sha1=${selfSignature}`; // shape in GitHub header
}

const compareSignatures = (signature, comparisonSignature) => {
  const source = Buffer.from(signature);
  const comparison = Buffer.from(comparisonSignature);
  return timingSafeEqual(source, comparison); // constant time comparison
}

export const verifyGithubPayload = (req: Express.Request) => {
  const { headers, body } = req;

  const signature = headers['x-hub-signature'];
  const comparisonSignature = createComparisonSignature(body);

  return compareSignatures(signature, comparisonSignature);
}