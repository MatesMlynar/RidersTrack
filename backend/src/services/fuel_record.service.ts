import fuel_recordModel from "../models/fuel_record.model";
import FuelRecord from "../types/models/fuel_record.type";

export class FuelRecordService{

    static async getAllFuelRecords() : Promise<FuelRecord[] | null>{
        try{
            return await fuel_recordModel.find({})
        }catch(err){
            console.log(err);
            return null;
        }
    }

    static async getFuelRecordById(id: string) : Promise<FuelRecord | null>{
        try{
           return await fuel_recordModel.findById(id)
        }catch(err){
            console.log(err);
            return null;
        }
    }

    static async getFuelRecordsByMotorcycleId(motorcycleId: string) : Promise<FuelRecord[] | null>{
        try{
           return await fuel_recordModel.find({motorcycleId})
        }catch(err){
            console.log(err);
            return null;
        }
    }

    static async createFuelRecord(recordBody : FuelRecord) : Promise<FuelRecord | null>{
        try{
            const {motorcycleId, user, liters, totalPrice, date, distance, consumption} = recordBody;

            const fuel_record = new fuel_recordModel({motorcycleId, user, liters, totalPrice, date, distance, consumption});
            const response = await fuel_record.save()
            return response.toObject() as FuelRecord;
        }catch(err){
            console.log(err);
            return null;
        }
    }

    static async deleteFuelRecordById(id : String) : Promise<Boolean>{
        try{
            await fuel_recordModel.findByIdAndDelete(id)
            return true;
        }catch(err){
            console.log(err);
            return false;
        }
    }

}