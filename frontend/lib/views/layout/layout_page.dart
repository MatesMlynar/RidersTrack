import 'package:flutter/material.dart';
import 'package:frontend/commands/checkAppVersion_command.dart';
import 'package:frontend/views/other_page/home_page.dart';
import 'package:frontend/views/ride_record/pre-tracking_page.dart';
import 'package:frontend/views/other_page/profile_page.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  int currentPage = 0;

  bool isOffline = false;
  bool isAppVersionTheLatest = false;
  bool versionChecked = false;

  checkIfAppVersionIsTheLatest() async {
    Map<String, dynamic> result = await CheckAppVersionCommand().run();

    if(result['status'] == 200){
      setState(() {
        isAppVersionTheLatest = true;
      });
    }
    setState(() {
      versionChecked = true;
    });

    if (!isAppVersionTheLatest) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('New version available'),
            content: Text('Please update the app to the latest version.'),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }


  }

  List<Widget> pages = const [
    HomePage(),
    ProfilePage()
  ];

  @override void initState() {
    super.initState();
    if(!versionChecked){
      checkIfAppVersionIsTheLatest();
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: pages.elementAt(currentPage),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor:  Colors.black,
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
                (Set<MaterialState> states) => states.contains(MaterialState.selected)
                ? const TextStyle(color: Colors.white)
                : const TextStyle(color: Colors.grey),
          ),
        ),
        child: NavigationBar(
          //TODO create bottomAppBar widget with this settings clipBehavior: Clip.antiAlias,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home,), label: "Home"),
            NavigationDestination(
                icon: Icon(Icons.account_circle_rounded), label: "Profile", ),
          ],
          selectedIndex: currentPage,
          onDestinationSelected: (int value) {
            setState(() {
              currentPage = value;
            });
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 70.0,
        width: 70.0,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: "homepageButton",
            shape: const CircleBorder(),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const PreTrackingPage();
              }));
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.play_arrow),
          ),
        ),
      ),
    );
  }
}
