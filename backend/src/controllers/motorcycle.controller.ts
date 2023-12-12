import {Request, Response} from 'express';
import jwt from 'jsonwebtoken';
import { MotorcycleService } from '../services/motorcycle.service';
import TokenType from "../types/auth/tokenType";
import authRequest from "../types/auth/authRequest";
import Motorcycle from "../types/models/motorcycle.type";


export const getAllMotorcycles = async (req: authRequest, res: Response) => {

    try{
        //check if token is valid
        const token : string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err : any) => {
            if(err){
                return res.status(403).send({
                    status: 403,
                    message: "Invalid token"
                })
            }
            else{
                //token is valid, return all motorcycles for this user
                const decodedToken : TokenType = jwt.decode(token) as TokenType;
                const response : Motorcycle[] | null = await MotorcycleService.getAllMotorcycles(decodedToken.userData.id);
                if(!response){
                    return res.status(500).send({
                        status: 500,
                        message: "Error getting motorcycles"
                    })
                }
                else{
                    return res.status(200).send({
                        status: 200,
                        message: "Motorcycles retrieved successfully",
                        data: response
                    })
                }
            }
        })
    }catch(err){
        console.log(err);
    }

}


export const getMotorcycleById = async (req: authRequest, res: Response) => {
    try{
        //check if token is valid
        const token : string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err : any) => {
            if(err){
                return res.status(403).send({
                    status: 403,
                    message: "Invalid token"
                })
            }
            else{
                //token is valid, return motorcycle by id
                const decodedToken : TokenType = jwt.decode(token) as TokenType;

                //get motorcycle id from url
                const motoId : string = req.params.id;

                if (!motoId){
                    return res.status(500).send({
                        status: 500,
                        message: "No motorcycle exists with this id"
                    })
                }

                const response : Motorcycle | null = await MotorcycleService.getMotorcycleById(motoId, decodedToken.userData.id);

                // add list of fueling records with id of this motorcycle to response

                if(!response){
                    return res.status(500).send({
                        status: 500,
                        message: "Error getting motorcycle"
                    })
                }
                else{
                    return res.status(200).send({
                        status: 200,
                        message: "Motorcycle retrieved successfully",
                        data: response
                    })
                }
            }
        })
    }catch(err){
        console.log(err);
    }
}


export const addMotorcycle = async (req: authRequest, res: Response) => {

    try{
        //check if token is valid
        const token : string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err : any, authData : any) => {
            if(err){
                return res.status(403).send({
                    status: 403,
                    message: "Invalid token"
                })
            }
            else{
                //token is valid, add motorcycle
                const decodedToken : TokenType = jwt.decode(token) as TokenType;
                const response : Motorcycle | null = await MotorcycleService.addMotorcycle(req.body.brand, req.body.model, decodedToken.userData.id, req.body.ccm, req.body.image, req.body.yearOfManufacture);
                if(!response){
                    return res.status(500).send({
                        status: 500,
                        message: "Error adding motorcycle"
                    })
                }
                else{
                    return res.status(200).send({
                        status: 200,
                        message: "Motorcycle added successfully",
                        data: response
                    })
                }
            }
        })
    }catch(err){
        console.log(err);
    }


}