import AWS from 'aws-sdk';

AWS.config = new AWS.Config({
	accessKeyId: process.env.ACCESS_KEY,
	secretAccessKey: process.env.SECRET_KEY,
	region: process.env.BUCKET_REGION,
});

const Bucket = process.env.BUCKET_NAME;
const S3 = new AWS.S3();


export function generateSignedPutUrl(Key, filetype) {
	return new Promise((resolve, reject) => {
		const params = {
			Bucket,
			Key,
            Expires: 30,
            ContentType: filetype === undefined ? "image/jpeg" : filetype,
		};

		S3.getSignedUrl("putObject", params, (err, url) => {
			if (err) reject(err);
			else resolve(url);
		});
	});
}


