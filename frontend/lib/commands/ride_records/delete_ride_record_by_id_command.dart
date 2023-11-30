import '../base_command.dart';

class DeleteRideRecordByIdCommand extends BaseCommand {

    Future<Map<String, dynamic>> run(String id) async {

      if(networkConnectionModel.isDeviceConnected == false){
        return {
          "status": 400,
          "message": "No internet connection"
        };
      }

      //get token from secure storage
      String? token = await secureStorage.getToken();

      if(token == null){
        return {
          "status": 400,
          "message": "Token not found"
        };
      }
      else{

        Map<String, dynamic> result = await rideRecordService.deleteRideRecordById(token, id);

        if(result['status'] != 200){
          return {
            "status": result['status'],
            "message": result['message']
          };
        }

        else{

          rideRecordModel.rideRecords!.removeWhere((item) => item.id == id);
          rideRecordModel.notifyListeners();

          return {
            "status": 200,
            "message": "Success"
          };
        }
      }

    }
}