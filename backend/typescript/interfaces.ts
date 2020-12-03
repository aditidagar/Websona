import { ObjectId } from "mongodb";

export interface AccessToken {
    firstName: string;
    email: string;
}

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
    contacts: any[]
}

export interface LoginInfo {
    email: string;
    password: string;
}

export interface Contact {
    id: ObjectId;
    user: string;
    sharedSocials: {
        social: string;
        username: string;
    }[];
}

export interface User {
    _id: ObjectId
    firstName: string;
    lastName: string;
    email: string;
    password: string;
    codes: Code[];
    activationId: string | undefined;
    contacts: any[];
    phone: string,
    socials: {
        social: string;
        username: string;
    }[];
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
    type: string;
}

export interface Event {
    _id?: ObjectId;
    codeId: string;
    owner: string;
    name: string;
    location: string;
    date: number; // Unix timestamp
    attendees: {
        firstName: string;
        lastName: string;
        email: string;
    }[];
}
