const router = require('express').Router();
import {register as RegisterUser} from '../controllers/user.controller';

//ROUTES
router.post('/register', RegisterUser);

export default router;