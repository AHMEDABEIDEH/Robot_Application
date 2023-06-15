import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:robot_application/pages/MapList.dart';

class homemainPage extends StatefulWidget {
  const homemainPage({Key? key}) : super(key: key);

  @override
  State<homemainPage> createState() => _homemainPageState();
}

class _homemainPageState extends State<homemainPage> {
  final user = FirebaseAuth.instance.currentUser!;

  List<String> docIDs = [];

  getDocId() async {
    await FirebaseFirestore.instance.collection('Map').get().then(
          (snapshot) => snapshot.docs.forEach((document) {
            print(document.reference);
            docIDs.add(document.reference.id);
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: FutureBuilder(
            future: getDocId(),
            builder: (context, snapshot) {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: docIDs.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 300,
                      width: width,
                      child: ListTile(
                        title: getMapsTapped(
                          documentId: docIDs[index],
                        ),
                      ),
                    );
                  });
            },
          )),
        ],
      )),
    );
  }
}
