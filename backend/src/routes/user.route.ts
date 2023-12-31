const router = require('express').Router();
import {
    register as RegisterUser,
    login as LoginUser,
    changePassword,
    findUsername, getProfileImage, updateProfileImage
} from '../controllers/user.controller';
import {checkToken} from '../middlewares/checkToken';



//ROUTES
router.post('/register', RegisterUser);
router.post('/login', LoginUser)
router.post('/changePassword', checkToken, changePassword)
router.get('/getUsername/:id', checkToken, findUsername)
router.get('/getProfilePictureById/:id', checkToken, getProfileImage)

router.put('/updateProfilePicture/:id', checkToken, updateProfileImage)

export default router;