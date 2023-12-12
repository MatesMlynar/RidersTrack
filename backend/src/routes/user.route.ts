const router = require('express').Router();
import {register as RegisterUser, login as LoginUser, changePassword} from '../controllers/user.controller';
import {checkToken} from '../middlewares/checkToken';
import {Request, Response} from 'express';
import jwt from 'jsonwebtoken';

//ROUTES
router.post('/register', RegisterUser);
router.post('/login', LoginUser)
router.post('/changePassword', checkToken, changePassword)

export default router;