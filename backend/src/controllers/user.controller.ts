import express, {Request, Response} from 'express';
import {UserService} from '../services/user.service';


//Controller functions
export const register = async (req: Request, res: Response) => {
    try{
        const {username, email, password} = req.body;
        const response = await UserService.registerUser(username, email, password)

        res.status(200).send({
            status: 200,
            message: "User registered successfully",
            data: response
        })
    }catch(err){
        console.log(err);
    }
    
}

