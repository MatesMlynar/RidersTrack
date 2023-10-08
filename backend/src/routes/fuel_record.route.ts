import {
    createFuelRecord,
    deleteFuelRecordById,
    getAllFuelRecords, getFuelRecordById,
    getFuelRecordsByMotorcycleId
} from "../controllers/fuel_record.controller";

const router = require('express').Router();
import { checkToken } from "../middlewares/checkToken";

//protected routes
router.post('/getAllFuelRecords', checkToken, getAllFuelRecords);
router.post('/createFuelRecord', checkToken, createFuelRecord);
router.post('/getFuelRecordById', checkToken, getFuelRecordById);
router.post('/getFuelRecordsByMotorcycleId', checkToken, getFuelRecordsByMotorcycleId);
router.post('/deleteFuelRecordById', checkToken, deleteFuelRecordById)

export default router;