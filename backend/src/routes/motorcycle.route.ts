const router = require('express').Router();
import { checkToken } from "../middlewares/checkToken";
import { Request, Response } from 'express';
import { addMotorcycle, getAllMotorcycles, getMotorcycleById } from "../controllers/motorcycle.controller";


// protected routes

//get all motorcycles
router.get('/getAllMoto', checkToken, getAllMotorcycles);
router.post('/getMotoById', checkToken, getMotorcycleById);
router.post('/addMoto', checkToken, addMotorcycle);

export default router;