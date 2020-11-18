

export interface SignUpInfo {

    firstName: string;
    lastName: string;
    email: string;
    password: string;
    events: {
        [key: string]: {
        name: string,
        location: string,
        }
    };  
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
    events: {
        [key: string]: {
        name: string,
        location: string,
        }
    };  
}
