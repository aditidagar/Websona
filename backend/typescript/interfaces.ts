

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
}
//      socials: {
//     social: string;
//     username: string;
// }[];
