import mongoose from 'mongoose';
import {connection as db} from '../config/db';

const Schema = mongoose.Schema;

const motorcycleSchema = new Schema({
    user: {
        type: Schema.Types.ObjectId,
        ref: "user",
        required: true,
    },
    brand: {
        type: String,
        required: true,
    },
    model: {
        type: String,
        required: true,
    },
    image: {
        type: String,
    },
    yearOfManufacture: {
        type: Number,
    },
    ccm: {
        type: Number,
    }
})


const MotorcycleModel = db.model('motorcycle', motorcycleSchema);

export default MotorcycleModel;