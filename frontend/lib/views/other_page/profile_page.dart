import 'package:flutter/material.dart';
import 'package:frontend/commands/user/logout_command.dart';
import 'package:frontend/types/user_type.dart';
import 'package:frontend/views/components/no_connection_component.dart';
import 'package:frontend/views/components/profile_page_box_component.dart';
import 'package:frontend/views/motorcycle/motorcycle_list_page.dart';
import 'package:frontend/views/ride_record/ride_record_list_page.dart';
import 'package:provider/provider.dart';

import '../../commands/user/get_user_command.dart';
import '../../models/network_connection_model.dart';
import '../layout/layout_page.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  bool isDeviceConnected = false;
  User? user;

  void logout(BuildContext context) async {
    Map<String, dynamic> result = await LogoutCommand().run(context);
  }

  void getUser() async {
    Map<String, dynamic> response = await GetUserCommand().run(context);
    if(response['success'] == true){
      setState(() {
        user = response['user'];
      });
    }
    else{
      user = null;
    }
  }


  @override
  void initState() {
    super.initState();
    getUser();
  }


  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    isDeviceConnected = context.watch<NetworkConnectionModel>().isDeviceConnected;

    return WillPopScope(
        onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFF14151B),
        body: SafeArea(
          top: true,
          child: isDeviceConnected ? SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.25,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: height * 0.18,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 20, 24, 27),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            //TODO: change image to custom one
                            image: Image.network(
                              'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                            ).image,
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(-1.00, 1.00),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 16),
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 20, 24, 27),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color.fromARGB(255, 20, 24, 27),
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1611004061856-ccc3cbe944b2?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                  child: Text(
                    user != null ? user!.username : '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 0, 16),
                  child: Text(
                    user != null ? user!.email : '',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const ProfilePageBox(icon: Icons.security, label: "Change password", isChangePasswordItem: true),
                const ProfilePageBox(icon: Icons.motorcycle, label: "My motorcycles", routeWidget: MotorcycleList()),
                const ProfilePageBox(icon: Icons.list_alt_outlined, label: "My rides", routeWidget: RideRecordListPage()),
                Align(
                  alignment: const AlignmentDirectional(0.00, 0.00),
                  child: GestureDetector(
                    onTap: () {
                        logout(context);
                    },
                    child: const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  )
                )
              ],
            ),
          ) : const NoConnectionComponent(),
        ),
      ),
    );
  }
}