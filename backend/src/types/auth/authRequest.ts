import {Request} from "express";

export default interface RequestWithToken extends Request{
    token: string
}

