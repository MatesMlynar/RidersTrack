import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:frontend/commands/user/register_command.dart';
import 'package:frontend/views/components/no_connection_component.dart';
import 'package:frontend/views/other_page/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../models/network_connection_model.dart';


class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool isDeviceConnected = false;

  //registrate user
  void registerUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      String emailPattern = r'^[^@]+@[^@]+\.[^@]+$';
      RegExp regex = RegExp(emailPattern);
      if (!regex.hasMatch(emailController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a valid email"), backgroundColor: Colors.red,));
        setState(() {
          isLoading = false;
        });
        return;
      }

      if (passwordController.text.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password should be at least 6 characters long"), backgroundColor: Colors.red,));
        setState(() {
          isLoading = false;
        });
        return;
      }

      var response = await RegisterCommand().run(emailController.text, usernameController.text, passwordController.text, confirmPasswordController.text);

      if(response['status'] == 200){
        setState(() {
          isLoading = false;
        });
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message']), backgroundColor: Colors.green,));
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
        }

      }
      else{
        setState(() {
          isLoading = false;
        });
        if(context.mounted)
          {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message']), backgroundColor: Colors.red,));
          }
      }

    }
    else{
      if(context.mounted)
        {
          ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Please fill out all fields"), backgroundColor: Colors.red,));
        }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    isDeviceConnected = context.watch<NetworkConnectionModel>().isDeviceConnected;

    return Scaffold(
        backgroundColor: const Color(0xFF14151B),
        body: isDeviceConnected ? SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
                minWidth: MediaQuery.of(context).size.width),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    alignment: Alignment.center,
                    child: Image(
                      image: const AssetImage('assets/images/logo/logo.png'),
                      fit: BoxFit.fitHeight,
                      height: 18.h,
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              "Create an account!",
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 28),
                              maxLines: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
                              child: AutoSizeText(
                                "Let's get started by filling out the form below.",
                                maxLines: 1,
                                style: GoogleFonts.readexPro(
                                  fontSize: 14,
                                  color:
                                      const Color.fromARGB(255, 149, 161, 172),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                              child: TextField(
                                autocorrect: false,
                                controller: emailController,
                                style: GoogleFonts.readexPro(
                                    color: Colors.white, fontSize: 16),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(12),
                                  labelText: "Email",
                                  labelStyle: GoogleFonts.readexPro(
                                      color: Colors.white, fontSize: 16),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 29, 36, 40))),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                              child: TextField(
                                autocorrect: false,
                                controller: usernameController,
                                style: GoogleFonts.readexPro(
                                    color: Colors.white, fontSize: 16),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(12),
                                  labelText: "Username",
                                  labelStyle: GoogleFonts.readexPro(
                                      color: Colors.white, fontSize: 16),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          Color.fromARGB(255, 29, 36, 40))),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                              child: TextField(
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: passwordController,
                                style: GoogleFonts.readexPro(
                                    color: Colors.white, fontSize: 16),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(12),
                                  labelText: "Password",
                                  labelStyle: GoogleFonts.readexPro(
                                      color: Colors.white, fontSize: 16),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 29, 36, 40))),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                              child: TextField(
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: confirmPasswordController,
                                style: GoogleFonts.readexPro(
                                    color: Colors.white, fontSize: 16),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(12),
                                  labelText: "Confirm password",
                                  labelStyle: GoogleFonts.readexPro(
                                      color: Colors.white, fontSize: 16),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 29, 36, 40))),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                              child: OutlinedButton(
                                  onPressed: isLoading ? null : () => registerUser(),
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                      minimumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 50)),
                                      backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 221, 28, 7)),
                                      ),
                                  child: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white,))  : Text(
                                    "Create Account",
                                    style: GoogleFonts.readexPro(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: GoogleFonts.readexPro(
                                      fontSize: 14,
                                      color: const Color.fromARGB(
                                          255, 149, 161, 172)),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()));
                                    },
                                    child: Text(
                                      "Sign in",
                                      style: GoogleFonts.readexPro(
                                          fontSize: 14,
                                          color: const Color.fromARGB(
                                              255, 221, 28, 7)),
                                    ))
                              ],
                            )
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ) : const NoConnectionComponent(),
    );
  }
}
