import 'package:flutter/material.dart';
import 'package:frontend/views/components/motorcycle_item_component.dart';
import 'package:frontend/views/create_new_motorcycle_page.dart';

class MotorcycleList extends StatefulWidget {
  const MotorcycleList({super.key});

  @override
  State<MotorcycleList> createState() => _MotorcycleListState();
}

class _MotorcycleListState extends State<MotorcycleList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 24, 27),
      appBar: AppBar(
        title: const Text('Your motorcycles', style: TextStyle(),),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'motorcycleListingTag',
        onPressed: () {
          //todo add page where user will be able to create new motorcycle
          print('todo page where user will be able to create new motorcycle');
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateNewMotorcycle()));
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            MotorcycleItemComponent(),
            MotorcycleItemComponent(),
          ],
        ),
      ),
    );
  }
}
