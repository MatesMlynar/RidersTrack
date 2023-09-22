import mongoose from 'mongoose';
require('dotenv').config();

if (!process.env.MONGO_URI) {
    throw new Error("MONGO_URI environment variable is not defined.");
}

const connection = mongoose.createConnection(process.env.MONGO_URI).on('open', () => {
    console.log('Connected to MongoDB RidersTrack');
}).on('error', (err: Error) => {
    console.log(`Connection error: ${err.message}`);
});

module.exports = connection;