import { Collection, FilterQuery, InsertOneWriteOpResult, MongoClient, MongoError, ObjectId, UpdateQuery } from 'mongodb';
import { Code, User, Event } from '../interfaces';

const DB_NAME = "test";
const MONGO_URL =
    `mongodb+srv://websona_backend:${process.env.DATABASE_PASS}@cluster0.if06i.mongodb.net/${DB_NAME}?retryWrites=true&w=majority`;

let client = new MongoClient(MONGO_URL, { useUnifiedTopology: true, useNewUrlParser: true });
const COLLECTION_USERS = "Users";
const COLLECTION_CODES = "Codes";
const COLLECTION_EVENTS = "Events";
let USERS_COLLECTION_LOCAL: Collection<any> | null = null;
let CODES_COLLECTION_LOCAL: Collection<any> | null = null;
let EVENTS_COLLECTION_LOCAL: Collection<any> | null = null;


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
                resolve(USERS_COLLECTION_LOCAL ? USERS_COLLECTION_LOCAL : client.db(DB_NAME).collection(collectionName));
            }
            else if (collectionName === COLLECTION_CODES) {
                resolve(CODES_COLLECTION_LOCAL ? CODES_COLLECTION_LOCAL : client.db(DB_NAME).collection(collectionName));
            }
            else if (collectionName === COLLECTION_EVENTS) {
                resolve(EVENTS_COLLECTION_LOCAL ? EVENTS_COLLECTION_LOCAL : client.db(DB_NAME).collection(collectionName));
            }
            else throw Error("Invalid Collection Name");
        }
        else {
            connectToDatabse().then((connection: MongoClient) => {
                if (collectionName === COLLECTION_USERS) {
                    USERS_COLLECTION_LOCAL = connection.db(DB_NAME).collection(collectionName);
                    resolve(USERS_COLLECTION_LOCAL);
                }
                else if (collectionName === COLLECTION_CODES) {
                    CODES_COLLECTION_LOCAL = connection.db(DB_NAME).collection(collectionName);
                    resolve(CODES_COLLECTION_LOCAL);
                }
                else if (collectionName === COLLECTION_EVENTS) {
                    EVENTS_COLLECTION_LOCAL = connection.db(DB_NAME).collection(collectionName);
                    resolve(EVENTS_COLLECTION_LOCAL);
                }
                else throw Error("Invalid Collection Name");
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

export function fetchUsers(query, options={}): Promise<User[]> {

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

export function updateUser(updatedUserObject: UpdateQuery<any> | Partial<any>, queryObject: FilterQuery<any>) {

    return new Promise((resolve, reject) => {
        getCollection(COLLECTION_USERS).then((collection: Collection) => {
            const updateDoc = { $set: updatedUserObject }
            collection.updateOne(queryObject, updateDoc, (err, updateResult) => {
                if (err) reject(err);

                resolve(updateResult);
            });

        }).catch((reason) => {
            reject(reason);
        });

    });
}

export function insertCode(code: Code): Promise<InsertOneWriteOpResult<any>> {

    return new Promise((resolve, reject) => {
        getCollection(COLLECTION_CODES).then((collection: Collection) => {
            collection.insertOne(code).then((result) => {
                resolve(result);
            }).catch((err) => {
                reject(err);
            })

        }).catch((reason) => {
            reject(reason);
        });
    });
}

export function fetchCodes(query, options={}): Promise<Code[] | MongoError> {

    return new Promise((resolve, reject) => {
        getCollection(COLLECTION_CODES).then((collection: Collection) => {
            collection.find(query, options).toArray((err, result) => {
                if (err) { reject(err); }

                resolve(result);
            });
        }).catch((reason) => {
            reject(reason);
        });
    });
}

export function deleteCode(codeId: string) {

    return new Promise((resolve, reject) => {
        getCollection(COLLECTION_CODES).then((collection: Collection) => {
            collection.deleteOne({ id: codeId }).catch((err) => reject(err));
        }).catch((reason) => reject(reason))
    })
}

export function insertEvent(event: Event): Promise<InsertOneWriteOpResult<any>> {

    return new Promise((resolve, reject) => {
        getCollection(COLLECTION_EVENTS).then((collection: Collection) => {
            collection.insertOne(event).then((result) => {
                resolve(result);
            }).catch((err) => {
                reject(err);
            })

        }).catch((reason) => {
            reject(reason);
        });
    });
}

export function fetchEvents(query, options={}): Promise<Event[] | MongoError> {

    return new Promise((resolve, reject) => {
        getCollection(COLLECTION_EVENTS).then((collection: Collection) => {
            collection.find(query, options).toArray((err, result) => {
                if (err) { reject(err); }

                resolve(result);
            });
        }).catch((reason) => {
            reject(reason);
        });
    });
}

export function deleteEvent(_id: ObjectId) {

    return new Promise((resolve, reject) => {
        getCollection(COLLECTION_EVENTS).then((collection: Collection) => {
            collection.deleteOne({ _id }).catch((err) => reject(err));
        }).catch((reason) => reject(reason))
    })
}
