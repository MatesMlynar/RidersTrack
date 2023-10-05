import {Request, Response} from 'express';
import jwt from 'jsonwebtoken';
import { MotorcycleService } from '../services/motorcycle.service';
import { Motorcycle } from '../models/motorcycle.model';

interface RequestWithToken extends Request{
    token: string
}

export const getAllMotorcycles = async (req: RequestWithToken, res: Response) => {

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
                //token is valid, return all motorcycles
                const response : Motorcycle[] | null = await MotorcycleService.getAllMotorcycles();
                if(!response){
                    res.status(500).send({
                        status: 500,
                        message: "Error getting motorcycles"
                    })
                }
                else{
                    res.status(200).send({
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


export const getMotorcycleById = async (req: RequestWithToken, res: Response) => {
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
                //token is valid, return motorcycle by id
                const response : Motorcycle | null = await MotorcycleService.getMotorcycleById(req.body.id);
                if(!response){
                    res.status(500).send({
                        status: 500,
                        message: "Error getting motorcycle"
                    })
                }
                else{
                    res.status(200).send({
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


export const addMotorcycle = async (req: RequestWithToken, res: Response) => {

    try{
        //check if token is valid
        const token : string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err : any, authData : any) => {
            if(err){
                res.status(403).send({
                    status: 403,
                    message: "Invalid token"
                })
            }
            else{
                //token is valid, add motorcycle
                console.log(req.body);
                const response : Motorcycle | null = await MotorcycleService.addMotorcycle(req.body.name, req.body.km, req.body.user);
                if(!response){
                    res.status(500).send({
                        status: 500,
                        message: "Error adding motorcycle"
                    })
                }
                else{
                    res.status(200).send({
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