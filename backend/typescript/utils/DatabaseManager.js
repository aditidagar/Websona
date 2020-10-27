const MongoClient = require("mongodb").MongoClient;

const MONGO_URL =
    "mongodb+srv://websona_backend:" + process.env.DATABASE_PASS + "@cluster0.if06i.mongodb.net/<dbname>?retryWrites=true&w=majority";  
var client = new MongoClient(MONGO_URL, { useUnifiedTopology: true, useNewUrlParser: true });

const COLLECTION_USERS = "Users";
const DB = "test";

var USERS_COLLECTION_LOCAL = null;


/**
 * Connect the client to database at the specified URL
 * @returns {Promise} A promise is returned which resolves to the connected client. 
 *                    On failure, error is returned
 */
function connectToDatabse() {
    client = new MongoClient(MONGO_URL, { useUnifiedTopology: true });
    // TODO: start a timer after connection is established. If the timer runs out,
    // close the connection. Timer will be reset upon every request to the database.
    // The time can be used to close the connection if there's no activity for extended
    // period of time
    return new Promise(function (resolve, reject) {
        client.connect().then((connection) => {
            resolve(connection);
        }).catch((reason) => {
            client.close();
            reject(reason);
        });
    });
}

function closeConnection() { client.close(); }

/**
 * return a Promise which resolves to a reference to the collection with name provided.
 * On failure, error is returned
 * @param {String} collectionName
 * @returns {Promise} Promise which resolves to a reference to the collection
 */
function getCollection(collectionName) {
    return new Promise(function (resolve, reject) {
        if (client.isConnected()) {
            if (collectionName === COLLECTION_USERS) {
                resolve(USERS_COLLECTION_LOCAL ? USERS_COLLECTION_LOCAL : client.db(DB).collection(collectionName))
            } else throw Error("Invalid Collection Name");
        }
        else {
            connectToDatabse().then((connection) => {
                if (collectionName === COLLECTION_USERS) {
                    USERS_COLLECTION_LOCAL = connection.db(DB).collection(collectionName);
                    resolve(USERS_COLLECTION_LOCAL);
                } else throw Error("Invalid Collection Name"); 
            }).catch((reason) => {
                reject(reason);
            })
        }
    });
}

function insertUser(profile) {

    return new Promise(function (resolve, reject) {
        getCollection(COLLECTION_USERS).then((collection) => {
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

function fetchUsers(query, options={}) {

    return new Promise(function (resolve, reject) {
        getCollection(COLLECTION_USERS).then((collection) => {
            collection.find(query, options).toArray(function (err, result) {
                if (err) { reject(err); }

                resolve(result);
            });
        }).catch((reason) => {
            reject(reason);
        });
    });
}


module.exports.insertUser = insertUser;

module.exports.fetchUsers = fetchUsers;

module.exports.getCollection = getCollection;

