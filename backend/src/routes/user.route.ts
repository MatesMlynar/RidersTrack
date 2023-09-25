const router = require('express').Router();
import {register as RegisterUser, login as LoginUser} from '../controllers/user.controller';

//ROUTES
router.post('/register', RegisterUser);
router.post('/login', LoginUser)

export default router;