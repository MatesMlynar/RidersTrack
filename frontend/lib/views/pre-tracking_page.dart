import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:frontend/commands/motorcycle/get_all_motorcycles_command.dart';
import 'package:frontend/utils/snack_bar_service.dart';
import 'package:frontend/views/tracking_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class PreTrackingPage extends StatefulWidget {
  const PreTrackingPage({super.key});

  @override
  State<PreTrackingPage> createState() => _PreTrackingPageState();
}

class _PreTrackingPageState extends State<PreTrackingPage> {
  bool isMotoFetching = false;

  late String? selectedMotorcycleId;
  late List<Map<String, dynamic>> motorcycleIdsList = [];
  late String message = "";

  void fetchMotorcycles() async {
    isMotoFetching = true;

    Map<String, dynamic> result = await GetAllMotorcycles().run();

    if (result['status'] != 200) {
      isMotoFetching = false;
      message = result['message'];
      return;
    }

    setState(() {
      isMotoFetching = false;
      if (result['data'] != null && result['data'].isNotEmpty) {
        motorcycleIdsList = result['data'];
        selectedMotorcycleId = motorcycleIdsList[0]['_id'];
      }
    });
  }


  void checkPermission() async{

    //check the permissions and if valid -> route
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      SnackBarService.showSnackBar(content: 'Location services are disabled. You won\'t be able to track your ride', color: Colors.red);

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        SnackBarService.showSnackBar(content: 'You won\'t be able to record your ride due deny location permission', color: Colors.red);
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      SnackBarService.showSnackBar(content: 'Location permissions are permanently denied, we cannot request permissions', color: Colors.red);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    if(context.mounted){
      Navigator.push(context, MaterialPageRoute(builder: (context) => TrackingPage(motorcycleId: selectedMotorcycleId!)));
    }
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
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 20, 24, 27),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AutoSizeText(
                    "Start with choosing one of your motorcycles",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    maxLines: 1),
                const SizedBox(
                  height: 20,
                ),
                isMotoFetching
                    ? const CircularProgressIndicator()
                    : Column(
                      children: [
                        DropdownButtonFormField(
                            value: selectedMotorcycleId,
                            //onChange method
                            onChanged: (val) {
                              setState(() {
                                selectedMotorcycleId = val as String;
                              });
                            },
                            //items
                            items: motorcycleIdsList
                                .map((itemVal) => DropdownMenuItem(
                                      value: itemVal['_id'],
                                      child: Text(itemVal['name']),
                                    ))
                                .toList(),
                            //style
                            icon: const Icon(
                              Icons.arrow_drop_down_circle,
                              color: Colors.white,
                            ),
                            style:
                                const TextStyle(color: Colors.white, fontSize: 16),
                            dropdownColor: const Color.fromARGB(255, 20, 24, 27),
                            decoration: const InputDecoration(
                              labelText: "Select motorcycle *",
                              labelStyle:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              prefixIcon:
                                  Icon(Icons.motorcycle, color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 1.5)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white, width: 1.5)),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              child: const Text("create motorcycle", style: TextStyle(color: Colors.grey, fontSize: 14, decoration: TextDecoration.underline, decorationColor: Colors.white),),
                              onTap: () {
                                print('todo add navigator that will open page where user can create new motorcycle');
                                //todo add navigator that will open page where user can create new motorcycle
                              },
                            )
                          ],
                        )
                      ],
                    ),
                const SizedBox(
                  height: 40,
                ),
                OutlinedButton(
                    onPressed: () {
                      if (selectedMotorcycleId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select motorcycle or create one!'), backgroundColor: Colors.red,));
                        return;
                      }
                      //todo create method that will check the user location permission
                      checkPermission();
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
                      "Start tracking!",
                      style: GoogleFonts.readexPro(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    )),
              ],
            ),
          ),
        ));
  }
}
