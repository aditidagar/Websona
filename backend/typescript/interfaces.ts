import { ObjectID } from "mongodb";


export interface SignUpInfo {
    firstName: string;
    lastName: string;
    email: string;
    password: string;
    activationId: string;
}

export interface LoginInfo {
    email: string;
    password: string;
}

export interface User {
    _id: ObjectID
    firstName: string;
    lastName: string;
    email: string;
    password: string;
    activationId: string | undefined
}
