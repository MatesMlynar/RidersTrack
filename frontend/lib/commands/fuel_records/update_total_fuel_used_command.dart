import 'package:frontend/commands/base_command.dart';

class UpdateTotalFuelUsedCommand extends BaseCommand {
  Future<num> run() async {
    List<Map<String, dynamic>>? fuelRecords = fuelRecordModel.fuelRecords;

    num totalFuelUsed = 0;

    if (fuelRecords != null) {
      for (var fuelRecord in fuelRecords) {
        if (fuelRecord.containsKey('liters')) {
          totalFuelUsed += fuelRecord['liters'];
        }
      }
    }

    fuelRecordModel.totalFuelUsed = totalFuelUsed;
    return totalFuelUsed;
  }
}
