const router = require('express').Router();
import {register as RegisterUser, login as LoginUser} from '../controllers/user.controller';
import {checkToken} from '../middlewares/checkToken';
import {Request, Response} from 'express';
import jwt from 'jsonwebtoken';

interface RequestWithToken extends Request{
    token: string
}


//ROUTES
router.post('/register', RegisterUser);
router.post('/login', LoginUser)


//example of protected route
router.get('/protectedRoute', checkToken, (req: RequestWithToken, res: Response) => {
    jwt.verify(req.token, process.env.JWT_SECRET!, (err, authData) => {
        if(err){
            res.status(403).send({
                status: 403,
                message: "Invalid token"
            })
        }
        else{
            res.status(200).send({
                status: 200,
                message: "Protected route",
                jwtData: authData,
            })
        }
    })
})

export default router;