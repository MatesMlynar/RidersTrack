import 'package:flutter/material.dart';
import 'package:frontend/commands/fuel_records/delete_fuel_record_by_id_command.dart';
import 'package:frontend/commands/fuel_records/get_fuel_record_by_id_command.dart';
import 'package:frontend/views/components/fuel-records_disabled_date_picker_component.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../commands/fuel_records/update_fuel_record_by_id_command.dart';
import '../../commands/motorcycle/get_all_motorcycles_command.dart';
import '../../types/fuel_record_textField_type.dart';
import '../components/fuel-records_text-field_component.dart';
import '../components/no_moto_found_component.dart';

class FuelRecordDetailPage extends StatefulWidget {
  const FuelRecordDetailPage({super.key, required this.fuelRecordId});

  final String? fuelRecordId;

  @override
  State<FuelRecordDetailPage> createState() => _FuelRecordDetailPageState();
}

class _FuelRecordDetailPageState extends State<FuelRecordDetailPage> {
  bool isStatsLoading = false;
  final litersController = TextEditingController();
  final priceController = TextEditingController();
  final distanceController = TextEditingController();
  final consumptionController = TextEditingController();
  late DateTime selectedDate = DateTime(2023, 1, 1);

  bool enabled = false;
  late String message;

  bool isMotoFetching = false;
  late String? selectedMotorcycleId;
  late List<Map<String, dynamic>> motorcycleIdsList = [];
  late String motoMessage = "";

  void fetchFuelRecord() async {
    setState(() {
      isStatsLoading = true;
    });
    if (widget.fuelRecordId == null) {
      setState(() {
        message = "id not found";
        isStatsLoading = false;
      });
    } else {
      Map<String, dynamic> result = await GetFuelRecordByIdCommand().run(widget.fuelRecordId!);

      if (result['status'] == 200) {
        setState(() {
          isStatsLoading = false;

          litersController.text = result['data']['liters'].toString();
          priceController.text = result['data']['totalPrice'].toString();
          selectedDate = DateTime.parse(result['data']['date']);
          selectedMotorcycleId = result['data']['motorcycleId'].toString();

          message = result['message'];

          //optional

          if (result['data']['consumption'] != null) {
            consumptionController.text = result['data']['consumption'].toString();
          }

          if (result['data']['distance'] != null) {
            distanceController.text = result['data']['distance'].toString();
          }

        });

        //get all motorcycles

        isMotoFetching = true;

        Map<String, dynamic> motorcycleFetchResult = await GetAllMotorcycles().run();

        if (motorcycleFetchResult['status'] != 200) {
          isMotoFetching = false;
          motoMessage = motorcycleFetchResult['message'];
          return;
        }

        setState(() {
          isMotoFetching = false;
          if (motorcycleFetchResult['data'] != null && motorcycleFetchResult['data'].isNotEmpty) {
            motorcycleIdsList = motorcycleFetchResult['data'];
          }
        });
      }
    }
  }


  void deleteFuelRecordById() async {

    if(widget.fuelRecordId == null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("id is not provided"), backgroundColor: Colors.red,));
    }else{
      Map<String, dynamic> response = await DeleteFuelRecordByIdCommand().run(widget.fuelRecordId!);

      if(response['status'] == 200){
        if(context.mounted){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("fuel record successfully deleted"), backgroundColor: Colors.green,));
          Navigator.pop(context);
        }
      }
    }
  }

  void updateFuelRecordById() async {

    if(widget.fuelRecordId == null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("id is not provided"), backgroundColor: Colors.red,));
    }else{

      String liters = litersController.text;
      String price = priceController.text;
      String distance = distanceController.text;
      String consumption = consumptionController.text;


      if(liters.isEmpty || price.isEmpty || selectedDate == DateTime(2023, 1, 1)){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in all fields"), backgroundColor: Colors.red,));
        return;
      }

      Map<String, dynamic> response = await UpdateFuelRecordByIdCommand().run(widget.fuelRecordId!,liters, price, selectedDate, selectedMotorcycleId!, consumption, distance );

      if(response['status'] == 200){
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("fuel record successfully edited"), backgroundColor: Colors.green,));
        }
        setState(() {
          enabled = false;
        });
      }
      else{
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message']), backgroundColor: Colors.red,));
        }
      }
    }


  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((value) => {
          setState(() {
            if (value != null) {
              selectedDate = DateTime(value.year, value.month, value.day);
            }
          })
        });
  }

  @override
  void initState() {
    super.initState();
    fetchFuelRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 20, 24, 27),
        appBar: AppBar(
          title: const Text('Fuel Record detail'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    enabled = !enabled;
                  });
                },
                icon: const Icon(Icons.edit)),
            IconButton(
              onPressed: () {
                deleteFuelRecordById();
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
            child: isStatsLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(children: [
                    FuelRecordsTextField(
                        props: FuelRecordTextFieldType(
                            enabled: enabled,
                            unit: "liters",
                            initVal: litersController.text,
                            keyboardType: TextInputType.number,
                            autocorrect: false,
                            onValueChanged: (val) {
                              litersController.text = val;
                            },
                            prefixIcon: const Icon(Icons.local_gas_station,
                                color: Colors.white),
                            labelText: "Fuel amount *")),
                    FuelRecordsTextField(
                        props: FuelRecordTextFieldType(
                            enabled: enabled,
                            unit: "czk",
                            initVal: priceController.text,
                            keyboardType: TextInputType.number,
                            autocorrect: false,
                            onValueChanged: (val) {
                              priceController.text = val;
                            },
                            prefixIcon: const Icon(Icons.attach_money,
                                color: Colors.white),
                            labelText: "Price *")),
                    FuelRecordsTextField(
                        props: FuelRecordTextFieldType(
                            enabled: enabled,
                            unit: "Km",
                            initVal: distanceController.text,
                            keyboardType: TextInputType.number,
                            autocorrect: false,
                            onValueChanged: (val) {
                              distanceController.text = val;
                            },
                            prefixIcon: const Icon(Icons.landscape,
                                color: Colors.white),
                            labelText: "Distance")),
                    FuelRecordsTextField(
                        props: FuelRecordTextFieldType(
                            enabled: enabled,
                            unit: "l/100",
                            initVal: consumptionController.text,
                            keyboardType: TextInputType.number,
                            autocorrect: false,
                            onValueChanged: (val) {
                              consumptionController.text = val;
                            },
                            prefixIcon: const Icon(Icons.water_drop,
                                color: Colors.white),
                            labelText: "Consumption")),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                      child: !enabled
                          ? DisabledDatePicker(date: selectedDate)
                          : GestureDetector(
                              onTap: _showDatePicker,
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.grey, width: 1.5),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        color: Colors.white),
                                    const SizedBox(width: 15),
                                    selectedDate == DateTime(2023, 1, 1)
                                        ? const Text("Select date *",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16))
                                        : Text(
                                            selectedDate
                                                .toLocal()
                                                .toString()
                                                .split(' ')[0],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16)),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                        child: isMotoFetching
                            ? const CircularProgressIndicator()
                            : motorcycleIdsList.isEmpty
                                ? const NoMotoFoundComponent()
                                : DropdownButtonFormField(
                                    value: selectedMotorcycleId,
                                    items: motorcycleIdsList
                                        .map((itemVal) => DropdownMenuItem(
                                              value: itemVal['_id'],
                                              child: Text(
                                                itemVal['name'],
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: !enabled
                                        ? null
                                        : (val) {
                                            setState(() {
                                              selectedMotorcycleId =
                                                  val as String;
                                            });
                                          },
                                    icon: !enabled
                                        ? null
                                        : const Icon(
                                            Icons.arrow_drop_down_circle,
                                            color: Colors.white,
                                          ),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                    dropdownColor:
                                        const Color.fromARGB(255, 20, 24, 27),
                                    decoration: InputDecoration(
                                      labelText: !enabled
                                          ? "Selected motorcycle"
                                          : "Select motorcycle *",
                                      labelStyle: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      prefixIcon: const Icon(Icons.motorcycle,
                                          color: Colors.white),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.5)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1.5)),
                                    ),
                                  )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                      child: OutlinedButton(
                          onPressed: enabled ? () {
                            updateFuelRecordById();
                          } : null,
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(150, 50)),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return Colors.grey;
                                  }
                                  return const Color.fromARGB(255, 221, 28, 7);
                                },
                              )),
                          child: Text(
                            "Edit",
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