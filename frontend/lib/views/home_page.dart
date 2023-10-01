import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../utils/secure_storage.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SecureStorage _secureStorage = SecureStorage();


  void logout() async{
    await _secureStorage.deleteToken();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }


  @override
  Widget build(BuildContext context) {

    var user = context.watch<UserModel>().currentUser;
    print(user);

    return Scaffold(
        body: Center(child: FloatingActionButton(onPressed: () {logout();},child: const Icon(Icons.logout), backgroundColor: Colors.red,)));
  }
}
