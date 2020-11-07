// import { ObjectID } from "mongodb";


export interface SignUpInfo {
    firstName: string;
    lastName: string;
    email: string;
    password: string;
}

export interface LoginInfo {
    email: string;
    password: string;
}

export interface User {
    firstName: string;
    lastName: string;
    email: string;
    password: string;
    codes: Code[];
}

export interface Code {
    id: string;
    src: string;
    owner: string
}
