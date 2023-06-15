import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class addMap extends StatefulWidget {
  const addMap({Key? key}) : super(key: key);

  @override
  State<addMap> createState() => _addMapState();
}

class _addMapState extends State<addMap> {
  final user = FirebaseAuth.instance.currentUser!;
  String imageName = '';
  XFile? imagePath;
  String imageURL = '';

  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  FirebaseStorage storageRef = FirebaseStorage.instance;
  String collectionName = 'images';

  final MapTitleController = TextEditingController();
  final MapDescriptionController = TextEditingController();
  final timeToPrepareController = TextEditingController();

  @override
  void dispose() {
    MapTitleController.dispose();
    MapDescriptionController.dispose();
    timeToPrepareController.dispose();
    super.dispose();
  }

  final ImagePicker _pickerImage = ImagePicker();
  dynamic _pickImage;
  var profileImage;
  String url = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$imageName"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () {
                          imagePicker();
                        },
                        child: Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: Colors.blue,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () {
                          imagePicker();
                        },
                        child: Icon(
                          Icons.image,
                          size: 30,
                          color: Colors.blue,
                        ))
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: MapTitleController,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: new OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 224, 91, 91)),
                    ),
                    //  labelStyle: TextStyle(color: Color.fromARGB(255, 23, 5, 24)),
                    labelText: "Map Title",
                    hintText: "Enter Map's Title",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: timeToPrepareController,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: new OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 224, 91, 91)),
                    ),
                    // labelStyle: TextStyle(color: Color.fromARGB(255, 23, 5, 24)),
                    labelText: "Map Duration",
                    hintText: "Enter Map's Time to Prepare",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: MapDescriptionController,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: new OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 224, 91, 91)),
                    ),
                    // labelStyle: TextStyle(color: Color.fromARGB(255, 23, 5, 24)),
                    labelText: "Map Description",
                    hintText: "Enter Map's Description",
                  ),
                ),
                const SizedBox(
                  height: 45,
                  width: 60,
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(213, 248, 28, 12),
                      elevation: 5,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    icon: const Icon(Icons.add, size: 32),
                    label: const Text(
                      'Add Map',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () {
                      _uploadImage();
                    }),
                const SizedBox(
                  height: 45,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Recipeadder() async {
    addMapData(
      timeToPrepareController.text.trim(),
      MapTitleController.text.trim(),
      MapDescriptionController.text.trim(),
    );
  }

  addMapData(
    String MapTitle,
    String timeToPrepare,
    String MapDescription,
  ) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    String refid = FirebaseFirestore.instance.collection('Map').doc().id;
    await FirebaseFirestore.instance.collection('Map').add({
      'Map Title': MapTitle,
      'Map Description': MapDescription,
      'Created By': uid,
      'Time to prepare': timeToPrepare,
      'ImageURL': url,
    });
  }

  _uploadImage() async {
    var uniqueKey = firestoreRef.collection(collectionName).doc();
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    String uploadFileName =
        DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    Reference reference =
        storageRef.ref().child(collectionName).child(uploadFileName);
    UploadTask uploadTask = reference.putFile(File(imagePath!.path));
    uploadTask.snapshotEvents.listen((event) {
      print(event.bytesTransferred.toString() +
          "\t" +
          event.totalBytes.toString());
    });

    await uploadTask.whenComplete(() async {
      var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
      if (uploadPath.isNotEmpty) {
        firestoreRef.collection("Map").doc(uniqueKey.id).set({
          'createdAt': FieldValue.serverTimestamp(),
          'Map Title': MapTitleController.text,
          'Map Description': MapDescriptionController.text,
          'Created By': uid,
          'Time to prepare': timeToPrepareController.text,
          'imageURl': uploadPath,
        }).then((value) => _showPrompt("Map Added"));
      } else {
        _showPrompt("Something While Uploading Went Wrong");
      }
    });
  }

  _showPrompt(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
    ));
  }

  imagePicker() async {
    final XFile? image =
        await _pickerImage.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagePath = image;
        imageName = image.name.toString();
      });
    }
  }
}
