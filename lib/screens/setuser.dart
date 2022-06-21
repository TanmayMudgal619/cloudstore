import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudstore/screens/home.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class setUser extends StatefulWidget {
  const setUser({Key? key}) : super(key: key);

  @override
  State<setUser> createState() => _setUserState();
}

class _setUserState extends State<setUser> {
  TextEditingController username = TextEditingController();
  String imgPath = "";
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 50,
                  backgroundImage: (imgPath == "")
                      ? (const AssetImage("assets/img/avatar.png"))
                      : (FileImage(File(imgPath))) as ImageProvider,
                  child: GestureDetector(
                    onTap: () async {
                      FilePickerResult? path =
                          await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      if (path == null) {
                        imgPath = "";
                      } else {
                        imgPath = path.paths[0] ?? "";
                        setState(() {});
                        final imgLink = await firebaseStorage
                            .ref("user_img/${firebaseAuth.currentUser!.uid}")
                            .putFile(File(imgPath));
                        await firebaseAuth.currentUser!
                            .updatePhotoURL(await imgLink.ref.getDownloadURL());
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: ((value) {
                    if (value == "") {
                      return "Enter Username";
                    }
                    return null;
                  }),
                  controller: username,
                  decoration: const InputDecoration(
                    label: Text("Username"),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        firebaseAuth.currentUser!
                            .updateDisplayName(username.text);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                          (route) => false,
                        );
                      }
                    },
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
