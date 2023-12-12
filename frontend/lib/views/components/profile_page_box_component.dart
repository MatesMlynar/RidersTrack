import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../commands/user/change_password_command.dart';

class ProfilePageBox extends StatefulWidget {
  const ProfilePageBox({super.key, required this.icon, required this.label, this.routeWidget, this.isChangePasswordItem = false});

  final IconData icon;
  final String label;
  final Widget? routeWidget;
  final bool isChangePasswordItem;

  @override
  State<ProfilePageBox> createState() => _ProfilePageBoxState();
}

class _ProfilePageBoxState extends State<ProfilePageBox> {

  bool isPasswordChanging = false;

  Future<String?> changePassword(BuildContext context, String oldPass, String newPass, String confPas) async {

    if(oldPass.isEmpty || newPass.isEmpty || confPas.isEmpty){
      return 'Please fill all the fields';
    }

    setState(() {
      isPasswordChanging = true;
    });

    Map<String, dynamic> result = await ChangePasswordCommand().run(oldPass, newPass, confPas);

    if(result['status'] == 200){
      setState(() {
        isPasswordChanging = false;
      });
      if(context.mounted){
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
      }

      return null;
    }
    else{
      setState(() {
        isPasswordChanging = false;
      });
      return result['message'];
    }
  }

  void openBottomSheet(BuildContext context) {

    TextEditingController oldPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmNewPasswordController = TextEditingController();

    String? message;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
           return SingleChildScrollView(
            child: Container(
              color: const Color(0xFF14151B),
              padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Change Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please enter your old password and the new password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      controller: oldPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Old Password',
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      controller: newPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'New Password',
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      controller: confirmNewPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirm New Password',
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    message != null ? message!.isNotEmpty ? Column(children: [SizedBox(height: 20, child: Text(message!, style: const TextStyle(color: Colors.red),)), const SizedBox(height: 20,)],) : const SizedBox() : const SizedBox(),
                    ElevatedButton(
                      onPressed: () async {
                        String? res = await changePassword(context, oldPasswordController.text, newPasswordController.text, confirmNewPasswordController.text);
                        setState(() {
                          message = res;
                        });
                      },
                      child: isPasswordChanging ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white,)) : const Text('Reset Password'),
                    ),
                  ],
                ),
              ),
            ),
          );}
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isChangePasswordItem ? () => openBottomSheet(context) : () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => widget.routeWidget!),
        );
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color.fromARGB(100, 29, 36, 40),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
            child: ListTile(
              leading: Icon(
                widget.icon,
                color: Colors.white,
                size: 20,
              ),
              title: Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
