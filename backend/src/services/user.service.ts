import UserModel from "../models/user.model";
import { User } from "../models/user.model";
import jwt from 'jsonwebtoken';

export class UserService{

    //Service functions
    static async registerUser(username:String, email: String, password: String){
        try{
            
            var doesUserEmailExist = await UserModel.exists({email})
            var doesUserNameExist = await UserModel.exists({username})


            if(doesUserEmailExist)
            {
                return {success: false, message: "Email already exists"}
            }
            else if(doesUserNameExist)
            {
                return {success: false, message: "Username already exists"}
            }

            const user = new UserModel({email, username, password})
            await user.save()
            return {success: true, data: user}
        }catch(err : any){
            return {success: false, message: err.message}
        }
    }


    static async findUser(email:String) : Promise<User | null>{
        try{
            return await UserModel.findOne({email})
        }catch(err){
            console.log(err);
            return null;
        }
    }


    static async generateToken(tokenData : Object, secretKey : jwt.Secret, expiresIn : string | number) : Promise<string | null>{{
        try{
            return await jwt.sign(tokenData, secretKey, {expiresIn})
        }catch(err){
            console.log(err);
            return null;
        }
    }}
}