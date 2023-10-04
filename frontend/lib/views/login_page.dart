import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:frontend/commands/user/login_command.dart';
import 'package:frontend/views/home_page.dart';
import 'package:frontend/views/registration_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../utils/secure_storage.dart';

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

  void loginUser() async{

    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      var result = await LoginCommand().run(emailController.text, passwordController.text);
      print(result);

      if(result['status'] == 200){
        setState(() {
          isLoading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
      else{
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message']), backgroundColor: Colors.red,));
      }

    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Please fill in all fields"), backgroundColor: Colors.red,));
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
    
    return isLoading ? const Center(child: CircularProgressIndicator()) :  Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 24, 27),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
              minWidth: MediaQuery.of(context).size.width),
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
                    image: AssetImage('assets/images/logo/logo.png'),
                    fit: BoxFit.fitHeight,
                    height: 18.h,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.loose,
                child: Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color.fromARGB(255, 29, 36, 40),
                      width: 2,
                    ),
                  ),
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
                                onPressed: () {
                                  loginUser();
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            const Size(double.infinity, 50)),
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        const Color.fromARGB(255, 221, 28, 7))),
                                child: Text(
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
      ),
    );
  }
}
