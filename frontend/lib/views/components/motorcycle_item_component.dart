import 'package:flutter/material.dart';

class MotorcycleItemComponent extends StatelessWidget {
  const MotorcycleItemComponent({super.key});

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;


    return GestureDetector(
      onTap: () {
        //todo add page where user will be able to view motorcycle details
        print('todo page where user will be able to view motorcycle details');
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
              Container(
                width: double.infinity,
                height: height * 0.20,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.network(
                      'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    ).image,
                    fit: BoxFit.cover,
              ))),
              const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Text(
                            'Yamaha YZF-R6',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '2018',
                            style: TextStyle(
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
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Text(
                            '600cc',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '4.5 l/100km',
                            style: TextStyle(
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
