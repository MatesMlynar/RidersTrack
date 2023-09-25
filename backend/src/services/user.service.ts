import UserModel from "../models/user.model";
import { User } from "../models/user.model";

export class UserService{

    //Service functions
    static async registerUser(username:String, email: String, password: String){
        try{
            const user = new UserModel({email, username, password})
            return await user.save()
        }catch(err){
            console.log(err);
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
}
