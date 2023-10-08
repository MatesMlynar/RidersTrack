import mongoose from "mongoose";
import { connection as db } from "../config/db";

const Schema = mongoose.Schema;


const fuelRecordSchema = new Schema({
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
    },
    distance: {
        type: Number,
    },
    liters: {
        type: Number,
        required: true,
    },
    consumption: {
        type: Number,
    },
    totalPrice: {
        type: Number,
        required: true,
    },
})

const FuelRecordModel = db.model("fuelRecord", fuelRecordSchema);

export default FuelRecordModel;