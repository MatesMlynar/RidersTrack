import fuel_recordModel from "../models/fuel_record.model";
import FuelRecord from "../types/models/fuel_record.type";
import { ObjectId } from 'mongodb';

export class FuelRecordService{

    static async getAllFuelRecords(userId : string) : Promise<FuelRecord[] | null>{
        try{
            return await fuel_recordModel.find({user: userId})
        }catch(err){
            console.log(err);
            return null;
        }
    }

    static async getFuelRecordById(id: string, userId : string) : Promise<FuelRecord | null>{
        try{
           return await fuel_recordModel.findOne({_id: id, user: userId})
        }catch(err){
            console.log(err);
            return null;
        }
    }

    static async getFuelRecordsByMotorcycleId(motorcycleId: string, userId : string) : Promise<FuelRecord[] | null>{
        try{
           return await fuel_recordModel.find({motorcycleId: motorcycleId, user: userId})
        }catch(err){
            console.log(err);
            return null;
        }
    }

    static async createFuelRecord(recordBody : FuelRecord, userId: string) : Promise<FuelRecord | null>{
        try{
            const {motorcycleId, liters, totalPrice, date, distance, consumption} = recordBody;
            const user = userId;

            const fuel_record = new fuel_recordModel({motorcycleId, user, liters, totalPrice, date, distance, consumption});
            const response = await fuel_record.save()
            return response.toObject() as FuelRecord;
        }catch(err){
            console.log(err);
            return null;
        }
    }

    static async deleteFuelRecordById(id : String, userId : string) : Promise<Boolean>{
        try{
            const record = await fuel_recordModel.findOne({_id: id, user: userId});

            if(!record){
                return false;
            }

            await record!.deleteOne();
            return true;
        }catch(err){
            console.log(err);
            return false;
        }
    }

    static async updateFuelRecordById(id : String, userId : string, recordBody : FuelRecord) : Promise<FuelRecord | null>{
        try{
            const record = await fuel_recordModel.findOne({_id: id, user: userId});

            if(!record){
                return null;
            }

            const {motorcycleId, liters, totalPrice, date, distance, consumption} = recordBody;

            record.motorcycleId = new ObjectId(motorcycleId);
            record.liters = liters;
            record.totalPrice = totalPrice;
            record.date = date!;
            record.distance = distance != null ? +distance : undefined;
            record.consumption = consumption != null ? +consumption : undefined

            await record.save();
            return record.toObject() as FuelRecord;
        }catch(err){
            console.log(err);
            return null;
        }
    }



}