import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/views/components/no_connection_component.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../commands/motorcycle/create_new_motorcycle_command.dart';
import '../../models/network_connection_model.dart';
import '../../types/textField_type.dart';
import '../components/custom_text_field_component.dart';

class CreateNewMotorcycle extends StatefulWidget {
  const CreateNewMotorcycle({super.key});

  @override
  State<CreateNewMotorcycle> createState() => _CreateNewMotorcycleState();
}

class _CreateNewMotorcycleState extends State<CreateNewMotorcycle> {
  TextEditingController brandController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController yearOfManufacture = TextEditingController();
  TextEditingController ccm = TextEditingController();

  bool isDeviceConnected = false;
  bool isAddingNewMotorcycle = false;

  XFile? selectedImage;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    isDeviceConnected = context.watch<NetworkConnectionModel>().isDeviceConnected;

    void createNewMotorcycle() async {

      String brand = brandController.text;
      String model = modelController.text;
      num? yearOfManufacture = num.tryParse(this.yearOfManufacture.text);
      num? ccm = num.tryParse(this.ccm.text);

      if(brand.isEmpty || model.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in all required (*) fields"), backgroundColor: Colors.red,));
        return;
      }


      setState(() {
        isAddingNewMotorcycle = true;
      });

      Map<String,dynamic> result = await CreateNewMotorcycleCommand().run(brand, model, yearOfManufacture, ccm, selectedImage);

      if(result['status'] != 200){
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message']), backgroundColor: Colors.red,));
        }

        setState(() {
          isAddingNewMotorcycle = false;
        });

        return;
      }

      if(context.mounted && result['status'] == 200){
        Navigator.pop(context);
        setState(() {
          isAddingNewMotorcycle = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Motorcycle added"), backgroundColor: Colors.green,));
      }
    }


    Future<XFile?> _getImage(ImageSource source) async {
      final ImagePicker _picker = ImagePicker();
      try {
        selectedImage = await _picker.pickImage(source: source);

        if (selectedImage == null) {
          return null;
        }

        setState(() {
          selectedImage = selectedImage;
        });

        return selectedImage;
      } catch (e) {
        print('Chyba při získávání fotografie: $e');
        return null;
      }
    }

    void _showImagePickerBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('From gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _getImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _getImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 20, 24, 27),
        appBar: AppBar(
          title: const Text('Create new motorcycle'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
          child: isDeviceConnected ? Column(children: [
            GestureDetector(
              onTap: () {
                _showImagePickerBottomSheet(context);
              },
              child: Container(
                width: double.infinity,
                height: height * 0.25,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  image: selectedImage != null
                      ? DecorationImage(
                          image: Image.file(File(selectedImage!.path)).image,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: selectedImage == null
                    ? const Center(
                        child: Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomTextField(
                props: CustomTextFieldType(
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    onValueChanged: (val) {
                      brandController.text = val;
                    },
                    prefixIcon: const Icon(Icons.motorcycle_outlined,
                        color: Colors.white),
                    labelText: "Brand *")),
            CustomTextField(
                props: CustomTextFieldType(
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    onValueChanged: (val) {
                      modelController.text = val;
                    },
                    prefixIcon: const Icon(Icons.build_outlined,
                        color: Colors.white),
                    labelText: "Model *")),
            CustomTextField(
                props: CustomTextFieldType(
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    isNumberTextField: true,
                    onValueChanged: (val) {
                      yearOfManufacture.text = val;
                    },
                    prefixIcon:
                        const Icon(Icons.date_range, color: Colors.white),
                    labelText: "Year of manufacture")),
            CustomTextField(
                props: CustomTextFieldType(
                    unit: 'ccm',
                    isNumberTextField: true,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    onValueChanged: (val) {
                      ccm.text = val;
                    },
                    prefixIcon:
                    const Icon(Icons.speed, color: Colors.white),
                    labelText: "Engine size")),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: OutlinedButton(
                  onPressed: isAddingNewMotorcycle ? null : () {
                    createNewMotorcycle();
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      minimumSize: MaterialStateProperty.all<Size>(const Size(150, 50)),
                      backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 221, 28, 7))),
                  child: isAddingNewMotorcycle ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white,)) : Text(
                    "Add",
                    style: GoogleFonts.readexPro(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  )),
            ),
          ]) : const NoConnectionComponent(),
        )));
  }
}
