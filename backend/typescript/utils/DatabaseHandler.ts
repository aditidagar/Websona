import { Collection, InsertOneWriteOpResult, MongoClient, MongoError } from 'mongodb';

const DB_NAME = "test";
const MONGO_URL =
    `mongodb+srv://websona_backend:${process.env.DATABASE_PASS}@cluster0.if06i.mongodb.net/${DB_NAME}?retryWrites=true&w=majority`;

let client = new MongoClient(MONGO_URL, { useUnifiedTopology: true, useNewUrlParser: true });
const COLLECTION_USERS = "Users";
let USERS_COLLECTION_LOCAL = null;


/**
 * Connect the client to database at the specified URL
 * @returns {Promise} A promise is returned which resolves to the connected client.
 *                    On failure, error is returned
 */
function connectToDatabse(): Promise<MongoClient | any> {
    client = new MongoClient(MONGO_URL, { useUnifiedTopology: true });
    // TODO: start a timer after connection is established. If the timer runs out,
    // close the connection. Timer will be reset upon every request to the database.
    // The time can be used to close the connection if there's no activity for extended
    // period of time
    return new Promise((resolve, reject) => {
        client.connect().then((connection) => {
            resolve(connection);
        }).catch((reason) => {
            client.close();
            reject(reason);
        });
    });
}

function closeConnection(): void { client.close(); }

/**
 * return a Promise which resolves to a reference to the collection with name provided.
 * On failure, error is returned
 * @param {String} collectionName
 * @returns {Promise} Promise which resolves to a reference to the collection
 */
function getCollection(collectionName): Promise<Collection | any> {
    return new Promise((resolve, reject) => {
        if (client.isConnected()) {
            if (collectionName === COLLECTION_USERS) {
                resolve(USERS_COLLECTION_LOCAL ? USERS_COLLECTION_LOCAL : client.db(DB_NAME).collection(collectionName))
            } else throw Error("Invalid Collection Name");
        }
        else {
            connectToDatabse().then((connection) => {
                if (collectionName === COLLECTION_USERS) {
                    USERS_COLLECTION_LOCAL = connection.db(DB_NAME).collection(collectionName);
                    resolve(USERS_COLLECTION_LOCAL);
                } else throw Error("Invalid Collection Name");
            }).catch((reason) => {
                reject(reason);
            })
        }
    });
}

export function insertUser(profile: object): Promise<InsertOneWriteOpResult<any>> {

    return new Promise((resolve, reject) => {
        getCollection(COLLECTION_USERS).then((collection: Collection) => {
            collection.insertOne(profile).then((result) => {
                resolve(result);
            }).catch((err) => {
                reject(err);
            })

        }).catch((reason) => {
            reject(reason);
        });
    });
}

export function fetchUsers(query, options={}): Promise<any[] | MongoError> {

    return new Promise((resolve, reject) => {
        getCollection(COLLECTION_USERS).then((collection: Collection) => {
            collection.find(query, options).toArray((err, result) => {
                if (err) { reject(err); }

                resolve(result);
            });
        }).catch((reason) => {
            reject(reason);
        });
    });
}

