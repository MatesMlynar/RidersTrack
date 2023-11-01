import {
    createFuelRecord,
    deleteFuelRecordById,
    getAllFuelRecords, getFuelRecordById,
    getFuelRecordsByMotorcycleId, updateFuelRecordById
} from "../controllers/fuel_record.controller";

const router = require('express').Router();
import { checkToken } from "../middlewares/checkToken";

//protected routes

//get
router.get('/getAllFuelRecords', checkToken, getAllFuelRecords);
router.get('/getFuelRecordById/:id', checkToken, getFuelRecordById);
router.get('/getFuelRecordsByMotorcycleId/:motoId', checkToken, getFuelRecordsByMotorcycleId);

//post
router.post('/createFuelRecord', checkToken, createFuelRecord);

//delete
router.delete('/deleteFuelRecordById/:id', checkToken, deleteFuelRecordById)

//put
//todo create put route to update fuel record
router.put('/updateFuelRecordById/:id', checkToken, updateFuelRecordById)


export default router;