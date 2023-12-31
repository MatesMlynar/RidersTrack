export default interface User extends Document{
    _id: string;
    email: string;
    username: string;
    password: string;
    profileImage: string;
    coverImage: string;
    comparePasswords(userPassword: string): Promise<boolean>;
}