import 'package:frontend/commands/base_command.dart';

class GetAllMotorcycles extends BaseCommand{
  Future<List<Map<String, dynamic>>> run () async {

    String? token = await secureStorage.getToken();
    if(token == null)
      return [];
    else{
      Map<String, dynamic> result = await motorcycleService.getAllMotorcycles(token);
      return (result['data'] as List).cast<Map<String, dynamic>>();
    }
  }
}