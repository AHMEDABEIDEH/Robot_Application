import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:robot_application/pages/AddMap.dart';
import 'package:robot_application/pages/NewAdded.dart';
import 'package:robot_application/pages/OtherMaps.dart';
import 'package:robot_application/pages/connection.dart';
import 'package:robot_application/pages/myMaps.dart';
import 'package:robot_application/pages/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 1;

  final screens = [
    getMyMaps(),
    homemainPage(),
    //newAdded(),
    addMap(),
    //FlutterBlueApp(),
    LedControlPage(
      esp8266IP: '192.168.1.37',
    ),
    //connection(),
  ];

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              indicatorColor: Colors.red.shade100,
              labelTextStyle: MaterialStateProperty.all(
                TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 97, 97, 97)),
              )),
          child: NavigationBar(
              height: 60,
              backgroundColor: Color.fromARGB(255, 236, 236, 236),
              selectedIndex: index,
              onDestinationSelected: (index) =>
                  setState(() => this.index = index),
              destinations: [
                NavigationDestination(
                    icon: Icon(Icons.note_add,
                        color: Color.fromARGB(255, 143, 143, 143)),
                    label: 'MyMaps'),
                NavigationDestination(
                    icon: Icon(Icons.home,
                        color: Color.fromARGB(255, 143, 143, 143)),
                    label: 'Home'),
                NavigationDestination(
                    icon: Icon(Icons.add_photo_alternate_outlined,
                        color: Color.fromARGB(255, 143, 143, 143)),
                    label: 'Add Map'),
                NavigationDestination(
                    icon: Icon(Icons.bluetooth_connected_outlined,
                        color: Color.fromARGB(255, 143, 143, 143)),
                    label: 'Connection'),
              ])),
    );
  }
}
