import path from "path";
import * as fs from "fs";


export class AppVersionService{

        static async checkAppVersion(version : String) : Promise<boolean>{
            try{
                return path.basename(fs.readdirSync(path.join(__dirname, '../../../web/apk/'))[0], '.apk') === version;
            }catch(err){
                console.log(err);
                return false;
            }
    }

}