import UserModel from "../models/user.model";

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

}
