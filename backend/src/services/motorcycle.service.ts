import MotorcycleModel from "../models/motorcycle.model";
import { Motorcycle } from '../models/motorcycle.model';

export class MotorcycleService{

    static async getAllMotorcycles() : Promise<Motorcycle[] | null>{
        try{
            return await MotorcycleModel.find({})
        }catch(err){
            console.log(err);
            return null;
        }
    }

    static async getMotorcycleById(id: string) : Promise<Motorcycle | null>{
        try{
           return await MotorcycleModel.findById(id)
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

    static async deleteMotorcycle(id : String) : Promise<Boolean>{
        try{
            await MotorcycleModel.findByIdAndDelete(id)
            return true;
        }catch(err){
            console.log(err);
            return false;
        }
    }

}
