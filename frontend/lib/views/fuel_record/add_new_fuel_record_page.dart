import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/commands/motorcycle/get_all_motorcycles_command.dart';
import 'package:frontend/types/motorcycle_type.dart';
import 'package:frontend/types/textField_type.dart';
import 'package:frontend/views/components/custom_text_field_component.dart';
import 'package:frontend/views/components/no_connection_component.dart';
import 'package:frontend/views/components/no_moto_found_component.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../commands/fuel_records/add_new_fuel_record_command.dart';
import '../../models/network_connection_model.dart';

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
  late DateTime selectedDate = DateTime.now();


  bool isMotoFetching = false;
  bool isAddingNewFuelRecord = false;


  late String? selectedMotorcycleId;
  late List<Motorcycle> motorcycleIdsList = [];
  late String message = "";
  bool isDeviceConnected = false;

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
          selectedMotorcycleId = motorcycleIdsList[0].id;
        }
    });
  }

  void calculateConsumption() {
    String liters = litersController.text;
    String distance = distanceController.text;

    if(liters.isEmpty || distance.isEmpty){
      return;
    }

    double consumption = (num.parse(liters) / num.parse(distance)) * 100;
    setState(() {
      consumptionController.text = consumption.toStringAsFixed(2);
    });
  }


  void addFuelRecord () async {
    String liters = litersController.text;
    String price = priceController.text;
    String distance = distanceController.text;
    String consumption = consumptionController.text;


    if(liters.isEmpty || price.isEmpty || selectedDate == DateTime(2023, 1, 1)){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in all fields"), backgroundColor: Colors.red,));
      return;
    }

    setState(() {
      isAddingNewFuelRecord = true;
    });

    Map<String, dynamic> result = await AddNewFuelRecordCommand().run(liters, price, selectedDate, selectedMotorcycleId!, consumption, distance);

    if(result['status'] != 200){
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message']), backgroundColor: Colors.red,));
      }
      setState(() {
        isAddingNewFuelRecord = false;
      });
      return;
    }

    if(context.mounted){
      setState(() {
        isAddingNewFuelRecord = true;
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fuel record added"), backgroundColor: Colors.green,));
    }
  }
  
  @override
  void initState() {
    super.initState();
    fetchMotorcycles();
    calculateConsumption();

    litersController.addListener(calculateConsumption);
    distanceController.addListener(calculateConsumption);
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

    isDeviceConnected = context.watch<NetworkConnectionModel>().isDeviceConnected;

    return Scaffold(
        backgroundColor: const Color(0xFF14151B),
        appBar:
            AppBar(title: const Text('Create fuel record'), centerTitle: true, backgroundColor: const Color(0xFF14151B)),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
            child: isDeviceConnected ? Column(children: [
              CustomTextField(props: CustomTextFieldType(
                  unit: "liters",
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  isNumberTextField: true,
                  onValueChanged: (val) {
                    litersController.text = val;
                  },
                  prefixIcon: const Icon(Icons.local_gas_station,
                      color: Colors.white),
                  labelText: "Fuel amount *"
              )),
              CustomTextField(props: CustomTextFieldType(
                  unit: "czk",
                  keyboardType: TextInputType.number,
                  isNumberTextField: true,
                  autocorrect: false,
                  onValueChanged: (val) {
                    priceController.text = val;
                  },
                  prefixIcon: const Icon(Icons.attach_money, color: Colors.white),
                  labelText: "Price *"
              )),
              CustomTextField(props: CustomTextFieldType(
                  unit: "Km",
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  isNumberTextField: true,
                  onValueChanged: (val) {
                    distanceController.text = val;
                  },
                  prefixIcon: const Icon(Icons.landscape, color: Colors.white),

                  labelText: "Distance"
              )),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
              child: TextField(
                keyboardType: TextInputType.number,
                readOnly: true,
                autocorrect: false,
                controller: consumptionController,
                style:
                GoogleFonts.readexPro(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  suffix: Text("l/100", style: GoogleFonts.readexPro(color: Colors.grey, fontSize: 16),),
                  prefixIcon: const Icon(Icons.water_drop, color: Colors.white),
                  contentPadding: const EdgeInsets.all(12),
                  labelText: "Consumption",
                  labelStyle: GoogleFonts.readexPro(
                      color: Colors.white, fontSize: 16),
                  enabledBorder: const OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.grey, width: 1.5)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1.5)),
                ),
              ),
            ),
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
                  child: isMotoFetching ? const CircularProgressIndicator(color: Colors.white,) : motorcycleIdsList.isEmpty ? const NoMotoFoundComponent() : DropdownButtonFormField(
                    value: selectedMotorcycleId,
                    items: motorcycleIdsList.map((itemVal) => DropdownMenuItem(
                              value: itemVal.id,
                              child: Text("${itemVal.brand} ${itemVal.model}"),
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
                    onPressed: isAddingNewFuelRecord ? null : () {
                      addFuelRecord();
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        minimumSize: MaterialStateProperty.all<Size>(const Size(150, 50)),
                        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 221, 28, 7))),
                    child: isAddingNewFuelRecord ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white,)) : Text(
                      "Add",
                      style: GoogleFonts.readexPro(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    )),
              ),
            ]) : const NoConnectionComponent(),
          ),
        ));
  }
}
