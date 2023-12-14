const router = require('express').Router();
import { checkToken } from "../middlewares/checkToken";
import { Request, Response } from 'express';
import {
    addMotorcycle,
    getAllMotorcycles,
    getMotorcycleById,
    updateAvgConsumptionById
} from "../controllers/motorcycle.controller";


// protected routes
router.get('/getAllMoto', checkToken, getAllMotorcycles);
router.get('/getMotoById/:id', checkToken, getMotorcycleById);
router.post('/addMoto', checkToken, addMotorcycle);
router.put('/updateAvgConsumptionById/:id', checkToken, updateAvgConsumptionById)

//todo create a route to update and delete motorcycle

export default router;