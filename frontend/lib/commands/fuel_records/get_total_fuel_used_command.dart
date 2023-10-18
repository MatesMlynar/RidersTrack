import 'package:frontend/commands/base_command.dart';

class GetTotalFuelUsedCommand extends BaseCommand {
  Future<num> run () async {
    //get token from secure storage
    String? token = await secureStorage.getToken();

    if(token == null){
      return 0;
    }
    else{
      //Map<String, dynamic> result = await fuelRecordService.getTotalFuelUsed(token);
     // num data = result['data'];
      //if(result['status'] != 200){
       // return 0;
      //}
      //else{
       // return data;
      //}
    }
    return 0;
  }
}