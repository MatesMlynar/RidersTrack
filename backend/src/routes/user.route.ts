const router = require('express').Router();
import {register as RegisterUser, login as LoginUser} from '../controllers/user.controller';
import {checkToken} from '../middlewares/checkToken';
import {Request, Response} from 'express';
import jwt from 'jsonwebtoken';

//ROUTES
router.post('/register', RegisterUser);
router.post('/login', LoginUser)

export default router;