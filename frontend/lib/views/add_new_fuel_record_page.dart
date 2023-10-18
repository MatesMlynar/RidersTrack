import 'package:flutter/material.dart';
import 'package:frontend/commands/fuel_records/get_all_fuel_records_command.dart';
import 'package:frontend/commands/motorcycle/get_all_motorcycles_command.dart';
import 'package:google_fonts/google_fonts.dart';

class AddNewFuelRecordPage extends StatefulWidget {
  const AddNewFuelRecordPage({super.key});

  @override
  State<AddNewFuelRecordPage> createState() => _AddNewFuelRecordPageState();
}

class _AddNewFuelRecordPageState extends State<AddNewFuelRecordPage> {

  final litersController = TextEditingController();
  final priceController = TextEditingController();
  final dateController = TextEditingController();

  bool isMotoFetching = false;

  late String? selectedMotorcycleId;
  late List<Map<String, dynamic>>? motorcycleIdsList = [];

  void fetchMotorcycles () async {
    isMotoFetching = true;

    List<Map<String, dynamic>> result = await GetAllMotorcycles().run();

    setState(() {
      motorcycleIdsList = result;
      isMotoFetching = false;
      selectedMotorcycleId = motorcycleIdsList?[0]['_id'];
      print(selectedMotorcycleId);
    });
    print(motorcycleIdsList);
  }
  
  
  @override
  void initState() {
    super.initState();
    fetchMotorcycles();
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                child: TextField(
                  autocorrect: false,
                  controller: litersController,
                  style:
                      GoogleFonts.readexPro(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(12),
                    labelText: "Fuel amount *",
                    labelStyle: GoogleFonts.readexPro(
                        color: Colors.white, fontSize: 16),
                    border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 29, 36, 40))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                child: TextField(
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  controller: priceController,
                  style:
                      GoogleFonts.readexPro(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(12),
                    labelText: "Price *",
                    labelStyle: GoogleFonts.readexPro(
                        color: Colors.white, fontSize: 16),
                    border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 29, 36, 40))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                child: TextField(
                  keyboardType: TextInputType.datetime,
                  autocorrect: false,
                  controller: dateController,
                  style:
                      GoogleFonts.readexPro(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(12),
                    labelText: "Date *",
                    labelStyle: GoogleFonts.readexPro(
                        color: Colors.white, fontSize: 16),
                    border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 29, 36, 40))),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                  child: isMotoFetching ? const CircularProgressIndicator() : DropdownButtonFormField(
                    value: selectedMotorcycleId,
                    items: motorcycleIdsList
                        ?.map((itemVal) => DropdownMenuItem(
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
                      prefixIcon: Icon(Icons.motorcycle, color: Colors.white),
                      border: OutlineInputBorder()
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                child: OutlinedButton(
                    onPressed: () {
                      //todo submit form
                      GetAllMotorcycles().run();
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
