const router = require('express').Router();
import {
    register as RegisterUser,
    login as LoginUser,
    changePassword,
    getProfileImage, updateProfileImage, getCoverImage, updateCoverImage, findUsernameAndPhoto
} from '../controllers/user.controller';
import {checkToken} from '../middlewares/checkToken';



//ROUTES
router.post('/register', RegisterUser);
router.post('/login', LoginUser)
router.post('/changePassword', checkToken, changePassword)
router.get('/getUsernameAndPhoto/:id', checkToken, findUsernameAndPhoto)
router.get('/getProfilePictureById/:id', checkToken, getProfileImage)
router.get('/getCoverImageById/:id', checkToken, getCoverImage)

router.put('/updateProfilePicture/:id', checkToken, updateProfileImage)
router.put('/updateCoverImage/:id', checkToken, updateCoverImage)

export default router;