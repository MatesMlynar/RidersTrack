import express, {Request, Response} from 'express';
import {UserService} from '../services/user.service';
import { User } from './../models/user.model';

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

export const login = async (req: Request, res: Response) => {
    try{
        const {email, password} = req.body;

        const user : User | null = await UserService.findUser(email);

        if(!user){
            res.status(404).send({
                status: 404,
                message: "User not found"
            })
        }

        if(!await user!.comparePasswords(password)){
            res.status(401).send({
                status: 401,
                message: "Incorrect password"
            })
        }



    }catch(err){
        console.log(err);
    }
}