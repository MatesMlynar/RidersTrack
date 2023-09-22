import mongoose from 'mongoose';
const bcrypt = require('bcrypt');
const db = require('../config/db');

const Schema = mongoose.Schema;

const userSchema = new Schema({
    email: {
        type: String,
        required: true,
        unique: true,
    },
    nickname: {
        type: String,
        required: true,
        unique: true,
    },
    password: {
        type: String,
        required: true
    },
})

const userModel = db.model('user', userSchema);

module.exports = userModel;