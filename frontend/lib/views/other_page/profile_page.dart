import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:frontend/commands/user/logout_command.dart';
import 'package:frontend/types/user_type.dart';
import 'package:frontend/views/components/no_connection_component.dart';
import 'package:frontend/views/components/profile_page_box_component.dart';
import 'package:frontend/views/motorcycle/motorcycle_list_page.dart';
import 'package:frontend/views/ride_record/ride_records_layout_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../commands/user/get_user_command.dart';
import '../../commands/user/update_profile_image_command.dart';
import '../../models/network_connection_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDeviceConnected = false;
  User? user;

  Uint8List? profileImageBytes = null;
  Uint8List? coverImageBytes = null;

  void logout(BuildContext context) async {
    await LogoutCommand().run(context);
  }

  void getUser() async {
    Map<String, dynamic> response = await GetUserCommand().run(context);
    if (response['success'] == true) {
      setState(() {
        user = response['user'];
        print(user!.profileImage);
        if (user!.profileImage.isNotEmpty) {
          List<int> decodedBase = base64Decode(user!.profileImage);
          profileImageBytes = Uint8List.fromList(decodedBase);
        }
        if (user!.coverImage.isNotEmpty) {
          List<int> decodedBase = base64Decode(user!.coverImage);
          coverImageBytes = Uint8List.fromList(decodedBase);
        }
      });
    } else {
      user = null;
    }
  }

  Future updateProfileImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
      try {
        XFile? image = await _picker.pickImage(source: source);

        if (image == null) {
          return null;
        }

        Map<String, dynamic> response = await UpdateProfileImageCommand().run(image);
        if(response['status'] != 200){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message']), backgroundColor: Colors.red,));
          return;
        }
        print(response);
        if (response['data'] != null) {
          List<int> decodedBase = base64Decode(response['data']);
          setState(() {
            profileImageBytes = Uint8List.fromList(decodedBase);
          });
        }

        return profileImageBytes;
      } catch (e) {
        print('Chyba při získávání fotografie: $e');
        return null;
      }
  }

  Future updateCoverImage(ImageSource source) async {
    if (coverImageBytes != null) {
      print("update cover image");
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void _showImagePickerBottomSheet(BuildContext context, bool isProfileImage) {
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
                  isProfileImage
                      ? await updateProfileImage(ImageSource.gallery)
                      : await updateCoverImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () async {
                  Navigator.pop(context);
                  isProfileImage
                      ? await updateProfileImage(ImageSource.camera)
                      : await updateCoverImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    isDeviceConnected =
        context.watch<NetworkConnectionModel>().isDeviceConnected;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFF14151B),
        body: SafeArea(
          top: true,
          child: isDeviceConnected
              ? SingleChildScrollView(
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
                              alignment:
                                  const AlignmentDirectional(-1.00, 1.00),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24, 0, 0, 16),
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 20, 24, 27),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          const Color.fromARGB(255, 20, 24, 27),
                                      width: 2,
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            4, 4, 4, 4),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: GestureDetector(
                                        onTap: () {
                                          _showImagePickerBottomSheet(
                                              context, true);
                                        },
                                        child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              image: profileImageBytes != null
                                                  ? DecorationImage(
                                                image: Image.memory(profileImageBytes!).image,
                                                fit: BoxFit.cover,
                                              )
                                                  : null,
                                            ),
                                            child: profileImageBytes == null
                                                ? const Icon(
                                                    Icons.camera_alt,
                                                    color: Colors.white,
                                                    size: 50,
                                                  )
                                                : null),
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
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
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
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(24, 4, 0, 16),
                        child: Text(
                          user != null ? user!.email : '',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const ProfilePageBox(
                          icon: Icons.list_alt_outlined,
                          label: "Ride records",
                          routeWidget: RideRecordsLayoutPage()),
                      const ProfilePageBox(
                          icon: Icons.motorcycle,
                          label: "Garage",
                          routeWidget: MotorcycleList()),
                      const ProfilePageBox(
                          icon: Icons.security,
                          label: "Change password",
                          isChangePasswordItem: true),
                      Align(
                          alignment: const AlignmentDirectional(0.00, 0.00),
                          child: GestureDetector(
                              onTap: () {
                                logout(context);
                              },
                              child: const Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: Text(
                                  'Log Out',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )))
                    ],
                  ),
                )
              : const NoConnectionComponent(),
        ),
      ),
    );
  }
}
