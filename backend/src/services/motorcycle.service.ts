import MotorcycleModel from "../models/motorcycle.model";
import Motorcycle from "../types/models/motorcycle.type";
import RideRecordModel from "../models/ride_record.model";
import FuelRecordModel from "../models/fuel_record.model";

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

    static async addMotorcycle(brand : String, model : String, userId : String, ccm: Number, image : String, yearOfManufacture : number) : Promise<Motorcycle | null>{
        try{
            const motorcycle  = new MotorcycleModel({brand, model, user : userId, ccm, image, yearOfManufacture});
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
            let response = await RideRecordModel.deleteMany({motorcycleId : id, user : userId})
            await FuelRecordModel.deleteMany({motorcycleId : id, user : userId})
            return true;
        }catch(err){
            console.log(err);
            return false;
        }
    }

    static async updateAvgConsumptionById(id : String, userId: string, avgConsumption : number) : Promise<Motorcycle | null>{
        try{
            const response = await MotorcycleModel.findOneAndUpdate({_id : id, user : userId}, {consumption : avgConsumption}, {new : true})
            return response?.toObject() as Motorcycle;
        }catch(err){
            console.log(err);
            return null;
        }

    }

}
