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
        backgroundColor: const Color.fromARGB(255, 20, 24, 27),
        appBar: AppBar(
          title: const Text('RIDERS TRACK', style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),),
          centerTitle: true,
          leading: null,
          actions: [
            Padding(padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.account_circle_rounded,
                  size: 26.0,
                ),
              ),
            )],
          backgroundColor: Colors.white,
        ),
        body: Center(child: FloatingActionButton(onPressed: () {logout();},child: const Icon(Icons.logout), backgroundColor: Colors.red,)));
  }
}
