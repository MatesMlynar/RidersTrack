import mongoose from "mongoose";
import { connection as db } from "../config/db";

const Schema = mongoose.Schema;

const rideRecordSchema = new Schema({
    user: {
        type: Schema.Types.ObjectId,
        ref: "user",
        required: true,
    },
    motorcycleId: {
        type: Schema.Types.ObjectId,
        ref: "motorcycle",
        required: true,
    },
    date: {
        type: Date,
        required: true,
    },
    totalDistance: {
        type: Number,
        required: true,
    },
    duration: {
        type: Number,
        required: true,
    },
    maxSpeed: {
        type: Number,
        required: true,
    },
    positionPoints: {
        type: Array,
        required: true,
    }
})

const RideRecordModel = db.model('ride_record', rideRecordSchema);

export default RideRecordModel;