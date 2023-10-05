import mongoose from "mongoose";
import { connection as db } from "../config/db";

const Schema = mongoose.Schema;

export interface FuelRecord extends Document {
    _id: string;
    user: string;
    motorcycle: string;
    date: Date;
    distance: number;
    liters: number;
    consumption: number;
    totalPrice: number;
}


const fuelRecordSchema = new Schema({
    user: {
        type: Schema.Types.ObjectId,
        ref: "user",
        required: true,
    },
    motorcycle: {
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