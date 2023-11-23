import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../types/textField_type.dart';
import 'components/custom_text_field_component.dart';

class CreateNewMotorcycle extends StatefulWidget {
  const CreateNewMotorcycle({super.key});

  @override
  State<CreateNewMotorcycle> createState() => _CreateNewMotorcycleState();
}

class _CreateNewMotorcycleState extends State<CreateNewMotorcycle> {
  TextEditingController brandController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController distance = TextEditingController();

  XFile? selectedImage;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

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
                  leading: Icon(Icons.photo_library),
                  title: Text('From gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _getImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Take a photo'),
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
          padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
          child: Column(children: [
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
                    : null, // Pokud je vybrána fotografie, nezobrazujte žádný další obsah
              ),
            ),
            SizedBox(
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
                    prefixIcon: const Icon(Icons.motorcycle_outlined,
                        color: Colors.white),
                    labelText: "Model *")),
            CustomTextField(
                props: CustomTextFieldType(
                    unit: 'km',
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    onValueChanged: (val) {
                      distance.text = val;
                    },
                    prefixIcon:
                        const Icon(Icons.place_outlined, color: Colors.white),
                    labelText: "Distance")),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: OutlinedButton(
                  onPressed: () {
                    //todo add new motorcycle to database
                    print('todo add new motorcycle to database');
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
        )));
  }
}
