import mongoose from 'mongoose';
import bcrypt from 'bcrypt';
import {connection as db} from '../config/db';
import User from "../types/models/user.type";

const Schema = mongoose.Schema;

const userSchema = new Schema({
    email: {
        type: String,
        required: true,
        unique: true,
    },
    username: {
        type: String,
        required: true,
        unique: true,
    },
    password: {
        type: String,
        required: true
    },
    profileImage: {
        type: String,
        default: ""
    },
    coverImage: {
        type: String,
        default: ""
    }
})

userSchema.pre('save', async function(){
    try{
        const salt = await bcrypt.genSalt(10);
        const hashedPassword =  await bcrypt.hash(this.password, salt);
        this.password = hashedPassword;
    }catch(err){
        console.log(err);
    }
})



userSchema.methods.comparePasswords = async function(userPassword: string) : Promise<Boolean> {

    const user = this as User;

    try{
        return await bcrypt.compare(userPassword, user.password)
    }catch(err){
        console.log(err);
        return false;
    }
}


const UserModel = db.model<User>('user', userSchema);

export default UserModel;