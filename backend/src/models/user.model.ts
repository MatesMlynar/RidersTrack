import mongoose from 'mongoose';
const bcrypt = require('bcrypt');
import {connection as db} from '../config/db';

const Schema = mongoose.Schema;

const userSchema = new Schema({
    email: {
        type: String,
        required: true,
        unique: true,
    },
    username: {
        type: String,
        required: true,
        unique: true,
    },
    password: {
        type: String,
        required: true
    },
})

const UserModel = db.model('user', userSchema);

export default UserModel;