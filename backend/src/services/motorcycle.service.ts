import MotorcycleModel from "../models/motorcycle.model";
import Motorcycle from "../types/models/motorcycle.type";

export class MotorcycleService{

    static async getAllMotorcycles(userId: string) : Promise<Motorcycle[] | null>{
        try{
            return await MotorcycleModel.find({user : userId})
        }catch(err){
            console.log(err);
            return null;
        }
    }

    static async getMotorcycleById(id: string, userId: string) : Promise<Motorcycle | null>{
        try{
           return await MotorcycleModel.findOne({_id : id, user : userId})
        }catch(err){
            console.log(err);
            return null;
        }
    }

    static async addMotorcycle(name : String, km : Number, userId : String) : Promise<Motorcycle | null>{
        try{
            const motorcycle  = new MotorcycleModel({name, km, user : userId})
            const response = await motorcycle.save()
            return response.toObject() as Motorcycle;
        }catch(err){
            console.log(err);
            return null;
        }
    }

    static async deleteMotorcycle(id : String, userId: string) : Promise<Boolean>{
        try{
            await MotorcycleModel.deleteOne({_id : id, user : userId})
            return true;
        }catch(err){
            console.log(err);
            return false;
        }
    }

}
