import {Request, Response} from "express";
import jwt from "jsonwebtoken";
import {FuelRecordService} from "../services/fuel_record.service";
import authRequest from "../types/auth/authRequest";
import FuelRecord from "../types/models/fuel_record.type";

export const getAllFuelRecords = async (req : authRequest, res: Response) => {
    try{
        //check if token is valid
        const token : string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err : any) => {
            if(err){
                res.status(403).send({
                    status: 403,
                    message: "Invalid token"
                })
            }
            else{
                //token is valid, return all fuel records
                const response : FuelRecord[] | null = await FuelRecordService.getAllFuelRecords();
                if(!response){
                    res.status(500).send({
                        status: 500,
                        message: "Error getting fuel records"
                    })
                }
                else{
                    res.status(200).send({
                        status: 200,
                        message: "Fuel records retrieved successfully",
                        data: response
                    })
                }
            }
        })
    }catch(err){
        console.log(err);
    }
}


export const getFuelRecordById = async (req: authRequest, res: Response) => {
    try{
        //check if token is valid
        const token : string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err : any) => {
            if(err){
                res.status(403).send({
                    status: 403,
                    message: "Invalid token"
                })
            }
            else{
                //token is valid, return fuel record by id
                const response : FuelRecord | null = await FuelRecordService.getFuelRecordById(req.body.id);
                if(!response){
                    res.status(500).send({
                        status: 500,
                        message: "Error getting fuel record"
                    })
                }
                else{
                    res.status(200).send({
                        status: 200,
                        message: "Fuel record retrieved successfully",
                        data: response
                    })
                }
            }
        })
    }catch(err){
        console.log(err);
    }
}


export const createFuelRecord = async (req: authRequest, res: Response) => {
    try{
        //check if token is valid
        const token : string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err : any) => {
            if(err){
                res.status(403).send({
                    status: 403,
                    message: "Invalid token"
                })
            }
            else{
                //token is valid, create fuel record
                const response : FuelRecord | null = await FuelRecordService.createFuelRecord(req.body);
                if(!response){
                    res.status(500).send({
                        status: 500,
                        message: "Error creating fuel record"
                    })
                }
                else{
                    res.status(200).send({
                        status: 200,
                        message: "Fuel record created successfully",
                        data: response
                    })
                }
            }
        })
    }catch(err){
        console.log(err);
    }
}

export const getFuelRecordsByMotorcycleId = async (req: authRequest, res: Response) => {
    try{
        //check if token is valid
        const token : string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err : any) => {
            if(err){
                res.status(403).send({
                    status: 403,
                    message: "Invalid token"
                })
            }
            else{
                //token is valid, return fuel records by motorcycle id
                const response : FuelRecord[] | null = await FuelRecordService.getFuelRecordsByMotorcycleId(req.body.id);
                if(!response){
                    res.status(500).send({
                        status: 500,
                        message: "Error getting fuel records"
                    })
                }
                else{
                    res.status(200).send({
                        status: 200,
                        message: "Fuel records retrieved successfully",
                        data: response
                    })
                }
            }
        })
    }catch(err){
        console.log(err);
    }
}

export const deleteFuelRecordById = async (req: authRequest, res: Response) => {
    try{
        //check if token is valid
        const token : string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err : any) => {
            if(err){
                res.status(403).send({
                    status: 403,
                    message: "Invalid token"
                })
            }
            else{
                //token is valid, delete fuel record by id
                const response : Boolean = await FuelRecordService.deleteFuelRecordById(req.body.id);
                if(!response){
                    res.status(500).send({
                        status: 500,
                        message: "Error deleting fuel record"
                    })
                }
                else{
                    res.status(200).send({
                        status: 200,
                        message: "Fuel record deleted successfully",
                        data: response
                    })
                }
            }
        })
    }catch(err){
        console.log(err);
    }
}