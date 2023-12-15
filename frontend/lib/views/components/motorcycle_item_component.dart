import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../types/motorcycle_type.dart';
import '../motorcycle/motorcycle_detail_page.dart';

class MotorcycleItemComponent extends StatefulWidget {
  const MotorcycleItemComponent({super.key, required this.data});

  final Motorcycle data;

  @override
  State<MotorcycleItemComponent> createState() => _MotorcycleItemComponentState();
}

class _MotorcycleItemComponentState extends State<MotorcycleItemComponent> {

  Uint8List? imageBytes;

  void decodeImage() async {
    if(widget.data.image == null){
      return;
    }
    // Decode image from base64
    List<int> decodedBase = base64Decode(widget.data.image!);
    imageBytes = Uint8List.fromList(decodedBase);
  }

  @override
  void initState() {
    super.initState();
    decodeImage();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MotorcycleDetailPage(data: widget.data)));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16,10, 16, 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(100, 29, 36, 40),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              imageBytes == null ? const SizedBox(height: 0, width: 0,) :
              Container(
                width: double.infinity,
                height: height * 0.20,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.memory(imageBytes!).image,
                    fit: BoxFit.cover,
              ))),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.data.brand} ${widget.data.model}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          widget.data.yearOfManufacture == null ? const SizedBox(height: 0, width: 0,) :
                          Text(
                            widget.data.yearOfManufacture.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          widget.data.ccm == null ? const SizedBox(height: 0, width: 0,) :
                          Text(
                            '${widget.data.ccm} ccm',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${widget.data.consumption != null ? (widget.data.consumption)!.toStringAsFixed(2) : "0"} l/100km',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
