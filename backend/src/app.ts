import express, {Request, Response, NextFunction, Application, ErrorRequestHandler} from 'express';
import {Server} from 'http';
import createHttpError from 'http-errors';
const db = require('./config/db');

require('dotenv').config();

const app: Application = express(); 

app.get('/', (req: Request, res: Response, next: NextFunction) => {
    res.send('Hello from ts app');
})


app.use((req: Request, res: Response, next: NextFunction) => {
    next(new createHttpError.NotFound())
})

const errorHandler : ErrorRequestHandler = (err,req,res,next) => {
    res.status(err.status || 500)
    res.send({
        status: err.status || 500,
        message: err.message,
    })
}

app.use(errorHandler)


const port : Number = Number(process.env.PORT) || 3000
const server: Server = app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});