import {
    createRideRecord,
    deleteRideRecordById,
    getAllRideRecords,
    getRideRecordById
} from "../controllers/ride_record.controller";


const router = require('express').Router();
import { checkToken } from "../middlewares/checkToken";

//get
router.get('/getAllRideRecords', checkToken, getAllRideRecords);
router.get('/getRideRecordById/:id', checkToken, getRideRecordById);

//post
router.post('/createRideRecord', checkToken, createRideRecord);

//delete
router.delete('/deleteRideRecordById/:id', checkToken, deleteRideRecordById)

export default router;