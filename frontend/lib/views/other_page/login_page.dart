import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:frontend/commands/user/login_command.dart';
import 'package:frontend/views/other_page/registration_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../models/network_connection_model.dart';
import '../../utils/secure_storage.dart';
import '../components/no_connection_component.dart';
import '../layout/layout_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final SecureStorage _secureStorage = SecureStorage();
  bool isLoading = false;
  bool isDeviceConnected = false;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  void loginUser(BuildContext context) async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      var result = await LoginCommand().run(
          emailController.text, passwordController.text);

      if (result['status'] == 200) {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LayoutPage()));
        }
      }
      else {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message']), backgroundColor: Colors.red));
        }
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill in all fields"),
        backgroundColor: Colors.red,));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSecureStorageData();
  }

  Future<void> fetchSecureStorageData() async {
    emailController.text = await _secureStorage.getEmail() ?? "";
    passwordController.text = await _secureStorage.getPassword() ?? "";
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    isDeviceConnected = context.watch<NetworkConnectionModel>().isDeviceConnected;

    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF14151B),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery
                  .of(context)
                  .size
                  .height,
              minWidth: MediaQuery
                  .of(context)
                  .size
                  .width),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                flex: 1,
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
              isDeviceConnected ?
              Flexible(
                flex: 3,
                fit: FlexFit.loose,
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText("Welcome Back",
                              maxLines: 1,
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 36)),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
                            child: AutoSizeText(
                              "Let's get started by filling out the form below.",
                              maxLines: 1,
                              style: GoogleFonts.readexPro(
                                fontSize: 14,
                                color: const Color.fromARGB(255, 149, 161, 172),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                            child: TextField(
                              autocorrect: false,
                              enableSuggestions: false,
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
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                            child: OutlinedButton(
                                onPressed: isLoading ? null : () {
                                  loginUser(context);
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                    minimumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 50)),
                                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 221, 28, 7))),
                                child: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white,)) : Text(
                                  "Sign In",
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
                                "Don't have an account?",
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
                                            const RegistrationPage()));
                                  },
                                  child: Text(
                                    "Sign Up Here",
                                    style: GoogleFonts.readexPro(
                                        fontSize: height * 0.014,
                                        color: const Color.fromARGB(
                                            255, 221, 28, 7)),
                                  ))
                            ],
                          )
                        ]),
                  ),
                ),
              ) : const NoConnectionComponent()
            ],
          ),
        ),
      ),
    );
  }
}
