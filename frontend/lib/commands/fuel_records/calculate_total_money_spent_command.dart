import 'package:frontend/commands/base_command.dart';

class CalculateTotalMoneySpentCommand extends BaseCommand {

  Future<num> run () async {

    List<Map<String, dynamic>>? fuelRecords = fuelRecordModel.fuelRecords;

    num totalMoneySpent = 0;

    if(fuelRecords != null)
    {
      for (var fuelRecord in fuelRecords!) {
        if(fuelRecord.containsKey('totalPrice'))
        {
          totalMoneySpent += fuelRecord['totalPrice'];
        }
      }
    }

    fuelRecordModel.totalMoneySpent = totalMoneySpent;
    return totalMoneySpent;
  }



}