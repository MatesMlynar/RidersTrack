import {checkAppVersionController} from "../controllers/app_version.controller";

const router = require('express').Router();
import { checkToken } from "../middlewares/checkToken";

router.post('/checkAppVersion', checkToken, checkAppVersionController)

export default router;