export default interface User extends Document{
    _id: string;
    email: string;
    username: string;
    password: string;
    comparePasswords(userPassword: string): Promise<boolean>;
}