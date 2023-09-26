import {Request, Response, NextFunction} from 'express';

interface RequestWithToken extends Request{
    token: string
}

export const checkToken = (req : RequestWithToken, res : Response, next : NextFunction) => {

    const header = req.headers['authorization'];

    if(typeof header !== 'undefined'){
        const bearer = header!.split(' ');
        const token = bearer[1];

        req.token = token;
        next();
    }
    else{
        res.sendStatus(403);
    }

}