import {Request, Response} from "express";
import jwt from "jsonwebtoken";
import {FuelRecordService} from "../services/fuel_record.service";
import authRequest from "../types/auth/authRequest";
import FuelRecord from "../types/models/fuel_record.type";
import TokenType from "../types/auth/tokenType";

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

                const decodedToken : TokenType = jwt.decode(token) as TokenType;

                const response : FuelRecord[] | null = await FuelRecordService.getAllFuelRecords(decodedToken.userData.id);

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

                const decodedToken : TokenType = jwt.decode(token) as TokenType;

                //get fuel record id from url
                const recordId : string = req.params.id;

                if (!recordId){
                    res.status(400).send({
                        status: 400,
                        message: "Fuel record id not provided or is invalid"
                    })
                }

                const response : FuelRecord | null = await FuelRecordService.getFuelRecordById(recordId, decodedToken.userData.id);
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

                const decodedToken : TokenType = jwt.decode(token) as TokenType;

                console.log(req.body)

                const response : FuelRecord | null = await FuelRecordService.createFuelRecord(req.body, decodedToken.userData.id);
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

                const decodedToken : TokenType = jwt.decode(token) as TokenType;

                //get motorcycle id from url
                const motoId : string = req.params.motoId;

                if (!motoId){
                    res.status(400).send({
                        status: 400,
                        message: "Motorcycle id not provided or is invalid"
                    })
                }

                const response : FuelRecord[] | null = await FuelRecordService.getFuelRecordsByMotorcycleId(motoId, decodedToken.userData.id);
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

                const decodedToken : TokenType = jwt.decode(token) as TokenType;

                const recordId : string = req.params.id;

                if(!recordId){
                    res.status(400).send({
                        status: 400,
                        message: "Fuel record id not provided or is invalid"
                    })
                }

                const response : Boolean = await FuelRecordService.deleteFuelRecordById(recordId, decodedToken.userData.id);
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