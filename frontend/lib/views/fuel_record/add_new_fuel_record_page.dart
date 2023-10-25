import 'package:flutter/material.dart';
import 'package:frontend/commands/motorcycle/get_all_motorcycles_command.dart';
import 'package:frontend/types/fuel_record_textField_type.dart';
import 'package:frontend/views/components/fuel-records_text-field_component.dart';
import 'package:frontend/views/components/no_moto_found_component.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../commands/fuel_records/add_new_fuel_record_command.dart';

class AddNewFuelRecordPage extends StatefulWidget {
  const AddNewFuelRecordPage({super.key});

  @override
  State<AddNewFuelRecordPage> createState() => _AddNewFuelRecordPageState();
}

class _AddNewFuelRecordPageState extends State<AddNewFuelRecordPage> {

  final litersController = TextEditingController();
  final priceController = TextEditingController();
  final distanceController = TextEditingController();
  final consumptionController = TextEditingController();
  late DateTime selectedDate = DateTime(2023, 1, 1);

  bool isMotoFetching = false;

  late String? selectedMotorcycleId;
  late List<Map<String, dynamic>> motorcycleIdsList = [];
  late String message = "";


  void fetchMotorcycles () async {
    isMotoFetching = true;

    Map<String, dynamic> result = await GetAllMotorcycles().run();

    if(result['status'] != 200){
      isMotoFetching = false;
      message = result['message'];
      return;
    }


    setState(() {
      isMotoFetching = false;
      if(result['data'] != null && result['data'].isNotEmpty)
        {
          motorcycleIdsList = result['data'];
          selectedMotorcycleId = motorcycleIdsList[0]['_id'];
        }
    });
  }

  void addFuelRecord () async {
    String liters = litersController.text;
    String price = priceController.text;
    String distance = distanceController.text;
    String consumption = consumptionController.text;


    if(liters.isEmpty || price.isEmpty || selectedDate == DateTime(2023, 1, 1) || consumption.isEmpty || distance.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in all fields"), backgroundColor: Colors.red,));
      return;
    }

    Map<String, dynamic> result = await AddNewFuelRecordCommand().run(liters, price, selectedDate, selectedMotorcycleId!, consumption, distance);

    if(result['status'] != 200){
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message']), backgroundColor: Colors.red,));
      }
      return;
    }

    if(context.mounted){
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fuel record added"), backgroundColor: Colors.green,));
    }
  }
  
  @override
  void initState() {
    super.initState();
    fetchMotorcycles();
  }


  void _showDatePicker() {
    showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2022),
        lastDate: DateTime.now(),
    ).then((value) => {
      setState(() {
        if(value != null)
          {
            selectedDate = DateTime(value.year, value.month, value.day);
          }
      })
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 20, 24, 27),
        appBar:
            AppBar(title: const Text('Create fuel record'), centerTitle: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
            child: Column(children: [
              FuelRecordsTextField(props: FuelRecordTextFieldType(
                  unit: "liters",
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  onValueChanged: (val) {
                    litersController.text = val;
                  },
                  prefixIcon: const Icon(Icons.local_gas_station,
                      color: Colors.white),
                  labelText: "Fuel amount *"
              )),
              FuelRecordsTextField(props: FuelRecordTextFieldType(
                  unit: "czk",
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  onValueChanged: (val) {
                    priceController.text = val;
                  },
                  prefixIcon: const Icon(Icons.attach_money, color: Colors.white),
                  labelText: "Price *"
              )),
              FuelRecordsTextField(props: FuelRecordTextFieldType(
                  unit: "Km",
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  onValueChanged: (val) {
                    distanceController.text = val;
                  },
                  prefixIcon: const Icon(Icons.landscape, color: Colors.white),
                  labelText: "Distance"
              )),
              FuelRecordsTextField(props: FuelRecordTextFieldType(
                  unit: "l/100",
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  onValueChanged: (val) {
                    consumptionController.text = val;
                  },
                  prefixIcon: const Icon(Icons.water_drop, color: Colors.white),
                  labelText: "Consumption"
              )),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                child: GestureDetector(
                    onTap: _showDatePicker,
                  child:
                       Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: Colors.white),
                            const SizedBox(width: 15),
                            selectedDate == DateTime(2023, 1, 1) ? const Text("Select date *", style: TextStyle(color: Colors.white, fontSize: 16)) :
                            Text(selectedDate.toLocal().toString().split(' ')[0], style: const TextStyle(color: Colors.white, fontSize: 16)),
                          ],
                        ),
                    ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                  child: isMotoFetching ? const CircularProgressIndicator() : motorcycleIdsList.isEmpty ? const NoMotoFoundComponent() : DropdownButtonFormField(
                    value: selectedMotorcycleId,
                    items: motorcycleIdsList.map((itemVal) => DropdownMenuItem(
                              value: itemVal['_id'],
                              child: Text(itemVal['name']),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedMotorcycleId = val as String;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.white,
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    dropdownColor: const Color.fromARGB(255, 20, 24, 27),
                    decoration: const InputDecoration(
                      labelText: "Select motorcycle *",
                      labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                      prefixIcon: Icon(Icons.motorcycle, color: Colors.white),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1.5)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1.5)),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                child: OutlinedButton(
                    onPressed: () {
                      addFuelRecord();
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(150, 50)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 221, 28, 7))),
                    child: Text(
                      "Add",
                      style: GoogleFonts.readexPro(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    )),
              ),
            ]),
          ),
        ));
  }
}
