import {NextFunction, Request, Response} from 'express';

interface RequestWithToken extends Request{
    token: string
}

export const checkToken = (req : RequestWithToken, res : Response, next : NextFunction) => {
    const header : string|undefined = req.headers['authorization'];
    if(typeof header !== 'undefined'){
        const bearer : string[] = header!.split(' ');
        req.token = bearer[1];
        next();
    }
    else{
        res.sendStatus(403);
    }

}