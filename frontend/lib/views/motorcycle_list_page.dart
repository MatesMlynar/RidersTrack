import 'package:flutter/material.dart';
import 'package:frontend/commands/motorcycle/get_all_motorcycles_command.dart';
import 'package:frontend/models/motorcycle_model.dart';
import 'package:frontend/models/network_connection_model.dart';
import 'package:frontend/types/motorcycle_type.dart';
import 'package:frontend/views/components/motorcycle_item_component.dart';
import 'package:frontend/views/components/no_connection_component.dart';
import 'package:frontend/views/create_new_motorcycle_page.dart';
import 'package:provider/provider.dart';

class MotorcycleList extends StatefulWidget {
  const MotorcycleList({super.key});

  @override
  State<MotorcycleList> createState() => _MotorcycleListState();
}

class _MotorcycleListState extends State<MotorcycleList> {
  List<Motorcycle>? motorcycleData = [];
  bool isLoading = false;
  bool isDeviceConnected = false;

  void fetchMotorcycleData() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> result = await GetAllMotorcycles().run();
    if (result['status'] == 200) {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMotorcycleData();
  }

  @override
  Widget build(BuildContext context) {
    motorcycleData = context.watch<MotorcycleModel>().motorcycles;
    isDeviceConnected = context.watch<NetworkConnectionModel>().isDeviceConnected;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 24, 27),
      appBar: AppBar(
        title: const Text(
          'Your motorcycles',
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      floatingActionButton: isDeviceConnected ? FloatingActionButton(
        heroTag: 'motorcycleListingTag',
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateNewMotorcycle()));
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add),
      ) : null,
      body: isDeviceConnected ? isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: motorcycleData != null && motorcycleData!.isNotEmpty
                  ? Column(
                      children: [
                        ...motorcycleData!.map((e) => MotorcycleItemComponent(
                              data: e,
                            )),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5),
                        const Center(
                          child: Column(
                            children: [
                              Text(
                                'No motorcycle found.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Create one!',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
            ) : const NoConnectionComponent(),
    );
  }
}
