import UserModel from "../models/user.model";
import jwt from 'jsonwebtoken';
import User from "../types/models/user.type";

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


    static async findUserByEmail(email:String) : Promise<User | null>{
        try{
            return await UserModel.findOne({email: email})
        }catch(err){
            console.log(err);
            return null;
        }
    }

    static async findUser(id:String) : Promise<User | null>{
        try{
            return await UserModel.findOne({_id: id})
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

    static async changePassword(userId : string, newPassword: String) : Promise<{success: boolean, message: string}>{
        try{

            const user = await UserModel.findOne({_id: userId});

            if (!user) {
                return {success: false, message: "User not found"}
            }

            user.password = newPassword as string;
            await user.save();
            return {success: true, message: "Password changed successfully"}
        }catch (err){
            return {success: false, message: 'Error while changing password'};
        }
    }

    static async getProfileImageByUserId(userId : string) : Promise<string>{
        try{
            const user = await UserModel.findOne({_id: userId});
            if(!user){
                return "";
            }
            return user.profileImage;
        }catch (err){
            return "";
        }
    }

    static async updateProfileImageByUserId(userId : string, profileImage : string) : Promise<boolean>{
        try{
            const user = await UserModel.findOne({_id: userId});
            if(!user){
                return false;
            }
            user.profileImage = profileImage;
            await user.save();
            return true;
        }catch (err){
            return false;
        }
    }

    static async getCoverImageByUserId(userId : string) : Promise<string>{
        try{
            const user = await UserModel.findOne({_id: userId});
            if(!user){
                return "";
            }
            return user.coverImage;
        }catch (err){
            return "";
        }
    }

    static async updateCoverImageByUserId(userId : string, coverImage : string) : Promise<boolean>{
        try{
            const user = await UserModel.findOne({_id: userId});
            if(!user){
                return false;
            }
            user.coverImage = coverImage;
            await user.save();
            return true;
        }catch (err){
            return false;
        }
    }


}