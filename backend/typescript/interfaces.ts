import { ObjectID } from "mongodb";


export interface SignUpInfo {
    firstName: string;
    lastName: string;
    email: string;
    password: string;
    activationId: string;
    contacts: {}
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
    codes: Code[];
    activationId: string | undefined;
    contacts: {};

}

export interface Code {
    id: string;
    owner: string;
    socials: {
        social: string;
        username: string;
    }[];
}
