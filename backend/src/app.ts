import bodyParser from 'body-parser';
import express, {Request, Response, NextFunction, Application, ErrorRequestHandler} from 'express';
import {Server} from 'http';
import createHttpError from 'http-errors';
import userRoute from './routes/user.route';
import motorcycleRoute from './routes/motorcycle.route';
import fuel_recordRoute from "./routes/fuel_record.route";
import ride_recordRoute from "./routes/ride_record.route";
import appVersionRoute from "./routes/app_version.route";

require('dotenv').config();

const app: Application = express(); 

//BODY-PARSER
app.use(bodyParser.json({limit: '50mb'}));
app.use(bodyParser.urlencoded({limit: '50mb', extended: true}));

//MIDDLEWARE
app.use('/api/general', appVersionRoute);
app.use('/api/user', userRoute)
app.use('/api/motorcycle', motorcycleRoute)
app.use('/api/fuelRecord', fuel_recordRoute)
app.use('/api/rideRecord', ride_recordRoute)

app.use((req: Request, res: Response, next: NextFunction) => {
    next(new createHttpError.NotFound())
})


//ERROR HANDLING
const errorHandler : ErrorRequestHandler = (err,req,res,next) => {
    res.status(err.status || 500)
    res.send({
        status: err.status || 500,
        message: err.message,
    })
}

app.use(errorHandler)

//SERVER
const port : Number = Number(process.env.PORT) || 3000
const server: Server = app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});