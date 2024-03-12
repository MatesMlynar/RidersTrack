import authRequest from "../types/auth/authRequest";
import {Response} from "express";
import jwt from "jsonwebtoken";
import {AppVersionService} from "../services/app_version.service";

export const checkAppVersionController = async (req: authRequest, res: Response) => {
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
                const response : Boolean = await AppVersionService.checkAppVersion(req.body.version);

                if(!response){
                    return res.status(500).send({
                        status: 500,
                        message: "App version is not up to date"
                    })
                }
                else{
                    return res.status(200).send({
                        status: 200,
                        message: "App version is up to date",
                    })
                }
            }
        })
    }catch(err){
        console.log(err);
    }
}