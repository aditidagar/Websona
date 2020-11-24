import { ObjectID } from "mongodb";


export interface SignUpInfo {
    firstName: string;
    lastName: string;
    email: string;
    password: string;
    phone: string,
    socials?: {
        social: string;
        username: string;
    }[];
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
    phone: string,
    socials: {
        social: string;
        username: string;
    }[];
    activationId: string | undefined
}

export interface PartialUserData {
    firstName?: string;
    lastName?: string;
    email?: string;
    password?: string;
    phone?: string;
    socials?: {
        social: string;
        username: string;
    }[];
    codes?: Code[];
    activationId?: string | undefined
}

export interface Code {
    id: string;
    owner: string;
    socials: {
        social: string;
        username: string;
    }[];
    url?: string;
}
