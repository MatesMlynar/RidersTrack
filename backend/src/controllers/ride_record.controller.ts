import jwt from "jsonwebtoken";
import authRequest from "../types/auth/authRequest";
import {Response} from "express";
import TokenType from "../types/auth/tokenType";
import {RideRecordService} from "../services/ride_record.service";
import RideRecord from "../types/models/ride_record.type";

export const getAllRideRecords = async (req: authRequest, res: Response) => {
    try {

        const token: string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err: any) => {
            if (err) {
                return res.status(403).send({
                    status: 403,
                    message: "Invalid token"
                })
            } else {

                const decodedToken: TokenType = jwt.decode(token) as TokenType;

                const response: RideRecord[] | null = await RideRecordService.getAllRideRecords(decodedToken.userData.id);

                if (response == null) {
                    return res.status(500).send({
                        status: 500,
                        message: "Error getting ride records"
                    })
                } else {
                    return res.status(200).send({
                        status: 200,
                        message: "Ride records retrieved successfully",
                        data: response
                    })
                }

            }
        })


    } catch (err) {
        console.log(err);
    }
}


export const getRideRecordById = async (req: authRequest, res: Response) => {
    try {

        const token: string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err: any) => {
            if (err) {
                return res.status(403).send({
                    status: 403,
                    message: "Invalid token"
                })
            } else {

                const decodedToken: TokenType = jwt.decode(token) as TokenType;

                const response: RideRecord | null = await RideRecordService.getRideRecordById(req.params.id, decodedToken.userData.id);

                if (response == null) {
                    return res.status(500).send({
                        status: 500,
                        message: "Error getting ride record"
                    })
                } else {
                    return res.status(200).send({
                        status: 200,
                        message: "Ride record retrieved successfully",
                        data: response
                    })
                }

            }
        })
    } catch (err) {
        console.log(err);
    }
}


export const createRideRecord = async (req: authRequest, res: Response) => {
    try {

        const token: string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err: any) => {
            if (err) {
                return res.status(403).send({
                    status: 403,
                    message: "Invalid token"
                })
            } else {

                const decodedToken: TokenType = jwt.decode(token) as TokenType;

                const response: RideRecord | null = await RideRecordService.createRideRecord(req.body, decodedToken.userData.id);

                if (response == null) {
                    return res.status(500).send({
                        status: 500,
                        message: "Error creating ride record"
                    })
                } else {
                    return res.status(200).send({
                        status: 200,
                        message: "Ride record created successfully",
                        data: response
                    })
                }

            }
        })
    } catch (err) {
        console.log(err);
    }
}

export const deleteRideRecordById = async (req: authRequest, res: Response) => {
    try {

        const token: string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err: any) => {
            if (err) {
                return res.status(403).send({
                    status: 403,
                    message: "Invalid token"
                })
            } else {

                const decodedToken: TokenType = jwt.decode(token) as TokenType;

                const response: Boolean = await RideRecordService.deleteRideRecordById(req.params.id, decodedToken.userData.id);

                if (response == null) {
                    return res.status(500).send({
                        status: 500,
                        message: "Error deleting ride record"
                    })
                } else {
                    return res.status(200).send({
                        status: 200,
                        message: "Ride record deleted successfully",
                        data: response
                    })
                }

            }
        })
    } catch (err) {
        console.log(err);
    }
}


export const getPublicRideRecords = async (req: authRequest, res: Response) => {

    try {

        const token: string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err: any) => {
            if (err) {
                return res.status(403).send({
                    status: 403,
                    message: "Invalid token"
                })
            } else {

                const response: RideRecord[] | null = await RideRecordService.getPublicRideRecords();

                if (response == null) {
                    return res.status(500).send({
                        status: 500,
                        message: "Error getting ride records"
                    })
                } else {
                    return res.status(200).send({
                        status: 200,
                        message: "Ride records retrieved successfully",
                        data: response
                    })
                }

            }
        })
    } catch (err) {
        console.log(err);
    }

}

export const updateRideRecordById = async (req: authRequest, res: Response) => {
    try {
        console.log(req)
        const token: string = req.token;
        jwt.verify(token, process.env.JWT_SECRET!, async (err: any) => {
            if (err) {
                return res.status(403).send({
                    status: 403,
                    message: "Invalid token"
                })
            } else {

                const decodedToken: TokenType = jwt.decode(token) as TokenType;

                const response: RideRecord | null = await RideRecordService.updateRideRecordById(req.params.id, decodedToken.userData.id, req.body );

                if (response == null) {
                    return res.status(500).send({
                        status: 500,
                        message: "Error updating ride record"
                    })
                } else {
                    return res.status(200).send({
                        status: 200,
                        message: "Ride record updated successfully",
                        data: response
                    })
                }

            }
        })
    } catch (err) {
        console.log(err);
    }
}