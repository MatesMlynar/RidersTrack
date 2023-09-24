import bodyParser from 'body-parser';
import express, {Request, Response, NextFunction, Application, ErrorRequestHandler} from 'express';
import {Server} from 'http';
import createHttpError from 'http-errors';
import userRoute from './routes/user.route';

require('dotenv').config();

const app: Application = express(); 

//BODY-PARSER
app.use(bodyParser.json());


//MIDDLEWARE
app.use('/api/user', userRoute)

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