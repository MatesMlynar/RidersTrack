import { Request, Response } from 'express';
import { UserService } from '../services/user.service';
import User from "../types/models/user.type";

require('dotenv').config();


//Controller functions
export const register = async (req: Request, res: Response) => {
    try {
        const { username, email, password } = req.body;
        const response = await UserService.registerUser(username, email, password)

        if (!response.success) {
            if (response.message) {
                res.status(409).send({
                    status: 409,
                    message: response.message
                })
            }
            else{
                res.status(500).send({
                    status: 500,
                    message: "Error registering user"
                })
            }
        }

        res.status(200).send({
            status: 200,
            message: "User registered successfully",
            data: response.data
        })
    } catch (err) {
        console.log(err);
    }

}

export const login = async (req: Request, res: Response) => {
    try {
        const { email, password } = req.body;

        //search for user by his mail address
        const user: User | null = await UserService.findUser(email);

        if (!user) {
            res.status(404).send({
                status: 404,
                message: "User not found"
            })
        }else if(user){
            if (!await user!.comparePasswords(password)) {
                res.status(401).send({
                    status: 401,
                    message: "Incorrect password"
                })
            }
    
            //user exists and password is correct, generate token
            let userData: Object = {
                username: user!.username,
                email: user!.email,
                id: user!._id
            }
            const token = await UserService.generateToken({ userData }, process.env.JWT_SECRET!, '24h');
    
            if (!token) {
                res.status(500).send({
                    status: 500,
                    message: "Error generating token"
                })
            }
    
            res.status(200).send({
                status: 200,
                message: "User logged in successfully",
                token: token,
            })
        }
        else {
            res.status(500).send({
                status: 500,
                message: "Something went wrong"
            })
        }

    } catch (err) {
        console.log(err);
    }
}