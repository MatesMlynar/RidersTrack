import ride_recordModel from "../models/ride_record.model";
import RideRecord from "../types/models/ride_record.type";

export class RideRecordService{

    static async getAllRideRecords(userId : string) : Promise<RideRecord[] | null>{
        try{
            return await ride_recordModel.find({user: userId})
        }catch(err){
            console.log(err);
            return null;
        }
    }

    static async getRideRecordById(id: string, userId : string) : Promise<RideRecord | null>{
        try{
           return await ride_recordModel.findOne({_id: id, user: userId})
        }catch(err){
            console.log(err);
            return null;
        }
    }

    static async createRideRecord(recordBody : RideRecord, userId: string) : Promise<RideRecord | null>{
        try{
            const {motorcycleId, date, totalDistance, duration, maxSpeed, positionPoints} = recordBody;
            const user = userId;

            const ride_record = new ride_recordModel({motorcycleId, user, date, totalDistance, duration, maxSpeed, positionPoints});
            const response = await ride_record.save();
            return response.toObject() as RideRecord;
        }catch(err){
            console.log(err);
            return null;
        }
    }

    static async deleteRideRecordById(id : String, userId : string) : Promise<Boolean>{
        try{
            const record = await ride_recordModel.findOne({_id: id, user: userId});

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

}