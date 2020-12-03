import AWS from 'aws-sdk';
import { resolve } from 'path';

AWS.config = new AWS.Config({
	accessKeyId: process.env.ACCESS_KEY,
	secretAccessKey: process.env.SECRET_KEY,
	region: process.env.BUCKET_REGION,
});

const Bucket = process.env.BUCKET_NAME;
const S3 = new AWS.S3();

export function generateSignedGetUrl(Key, timeout=10): Promise<string> {
	return new Promise((res, reject) => {
		const params = {
			Bucket,
			Key,
			Expires: timeout,
		};

		S3.getSignedUrl("getObject", params, (err, url) => {
			if (err) reject(err);
			else res(url);
		});
	});
}



export function generateSignedPutUrl(Key: string, filetype): Promise<string> {
	return new Promise((res, reject) => {
		const params = {
			Bucket,
			Key,
            Expires: 30,
            ContentType: filetype === undefined ? "image/jpeg" : filetype
		};

		S3.getSignedUrl("putObject", params, (err, url) => {
			if (err) reject(err);
			else res(url);
		});
	});
}

export function deleteObject(Key: string): Promise<boolean> {
	return new Promise((res, reject) => {
		const params = {
			Bucket: Bucket as string,
			Key
		};

		S3.deleteObject(params, (err, data) => {
			res(true);
		})
	});
}
