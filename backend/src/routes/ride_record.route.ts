import {
    createRideRecord,
    deleteRideRecordById,
    getAllRideRecords, getPublicRideRecords,
    getRideRecordById, updateRideRecordById
} from "../controllers/ride_record.controller";


const router = require('express').Router();
import { checkToken } from "../middlewares/checkToken";

//get
router.get('/getAllRideRecords', checkToken, getAllRideRecords);
router.get('/getRideRecordById/:id', checkToken, getRideRecordById);
router.get('/getPublicRideRecords', checkToken, getPublicRideRecords);

//post
router.post('/createRideRecord', checkToken, createRideRecord);

//delete
router.delete('/deleteRideRecordById/:id', checkToken, deleteRideRecordById)

//update
router.put('/updateRideRecordById/:id', checkToken, updateRideRecordById)

export default router;