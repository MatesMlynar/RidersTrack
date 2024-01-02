import { Request, Response } from 'express';
import { UserService } from '../services/user.service';
import User from "../types/models/user.type";
import jwt from "jsonwebtoken";
import authRequest from "../types/auth/authRequest";
import TokenType from "../types/auth/tokenType";

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
        const user: User | null = await UserService.findUserByEmail(email);

        if (!user) {
            return res.status(404).send({
                status: 404,
                message: "User not found"
            })
        }else if(user){
            if (!await user!.comparePasswords(password)) {
                return res.status(401).send({
                    status: 401,
                    message: "Incorrect password"
                })
            }
    
            //user exists and password is correct, generate token
            let userData: Object = {
                username: user!.username,
                email: user!.email,
                id: user!._id,
            }
            const token = await UserService.generateToken({ userData }, process.env.JWT_SECRET!, '24h');
    
            if (!token) {
                return res.status(500).send({
                    status: 500,
                    message: "Error generating token"
                })
            }
    
            return res.status(200).send({
                status: 200,
                message: "User logged in successfully",
                token: token,
            })
        }
        else {
            return res.status(500).send({
                status: 500,
                message: "Something went wrong"
            })
        }

    } catch (err) {
        console.log(err);
    }
}

export const changePassword = async (req: authRequest, res: Response) => {
    try {
        //check if token is valid
        const token : string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err : any, authData : any) => {
            const { oldPassword, newPassword, email } = req.body;

            const decodedToken : TokenType = jwt.decode(token) as TokenType;
            const userId : string = decodedToken.userData.id;
            const user: User | null = await UserService.findUserByEmail(email);

            if (!user) {
                return res.status(404).send({
                    status: 404,
                    message: "User not found"
                })
            }

            if (!(await user!.comparePasswords(oldPassword))) {
                return res.status(401).send({
                    status: 401,
                    message: "Incorrect password"
                })
            }

            const response = await UserService.changePassword(userId, newPassword);

            if (!response.success) {
                return res.status(500).send({
                    status: 500,
                    message: response.message
                })
            }

            return res.status(200).send({
                status: 200,
                message: response.message
            })
        })
    } catch (err) {
        console.log(err);
    }
}

export const findUsernameAndPhoto = async (req: authRequest, res: Response) => {
    try {
        //check if token is valid
        const token : string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err : any, authData : any) => {

            const { id } = req.params;
            const userObj: User | null = await UserService.findUser(id);
            if (!userObj) {
                return res.status(404).send({
                    status: 404,
                    message: "User not found"
                })
            }
            return res.status(200).send({
                status: 200,
                message: "User found",
                data: userObj
            })
        })
    } catch (err) {
        console.log(err);
    }
}

export const getProfileImage = async (req: authRequest, res: Response) => {
    try {
        //check if token is valid
        const token : string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err : any, authData : any) => {

            const { id } = req.params;
            const profileImage: String = await UserService.getProfileImageByUserId(id);
            if (!profileImage) {
                return res.status(404).send({
                    status: 404,
                    message: "User not found"
                })
            }
            return res.status(200).send({
                status: 200,
                message: "User found",
                image: profileImage
            })
        })
    } catch (err) {
        console.log(err);
    }
}

export const updateProfileImage = async (req: authRequest, res: Response) => {
    try {
        //check if token is valid
        const token : string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err : any, authData : any) => {

            const { id } = req.params;
            const { profileImage } = req.body;
            const response: boolean = await UserService.updateProfileImageByUserId(id, profileImage);
            if (!response) {
                return res.status(404).send({
                    status: 404,
                    message: "User not found"
                })
            }
            return res.status(200).send({
                status: 200,
                message: "User found",
                image: profileImage
            })
        })
    } catch (err) {
        console.log(err);
    }
}

export const getCoverImage = async (req: authRequest, res: Response) => {
    try {
        //check if token is valid
        const token : string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err : any, authData : any) => {

            const { id } = req.params;
            const coverImage: String = await UserService.getCoverImageByUserId(id);
            if (!coverImage) {
                return res.status(404).send({
                    status: 404,
                    message: "User not found"
                })
            }
            return res.status(200).send({
                status: 200,
                message: "User found",
                image: coverImage
            })
        })
    } catch (err) {
        console.log(err);
    }
}

export const updateCoverImage = async (req: authRequest, res: Response) => {
    try {
        //check if token is valid
        const token : string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err : any, authData : any) => {

            const { id } = req.params;
            const { coverImage } = req.body;
            const response: boolean = await UserService.updateCoverImageByUserId(id, coverImage);
            if (!response) {
                return res.status(404).send({
                    status: 404,
                    message: "User not found"
                })
            }
            return res.status(200).send({
                status: 200,
                message: "User found",
                image: coverImage
            })
        })
    } catch (err) {
        console.log(err);
    }
}