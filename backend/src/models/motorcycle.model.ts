import mongoose from 'mongoose';
import {connection as db} from '../config/db';

const Schema = mongoose.Schema;

export interface Motorcycle extends Document{
    _id: string;
    user: string;
    name: string;
    image: string;
    km: number;
}


const motorcycleSchema = new Schema({
    user: {
        type: Schema.Types.ObjectId,
        ref: "user",
        required: true,
    },
    name: {
        type: String,
        required: true,
    },
    image: {
        type: String,
    },
    km: {
        type: Number,
    },
})


const MotorcycleModel = db.model('motorcycle', motorcycleSchema);

export default MotorcycleModel;