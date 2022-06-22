import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudstore/screens/image.dart';
import 'package:cloudstore/screens/music.dart';
import 'package:cloudstore/screens/text.dart';
import 'package:cloudstore/screens/video.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class upload extends StatefulWidget {
  const upload({Key? key}) : super(key: key);

  @override
  State<upload> createState() => _uploadState();
}

class _uploadState extends State<upload> {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  int selectedType = 0;
  List<String> typeList = ["Text", "Image", "Video", "Music"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          DropdownButton(
            value: selectedType,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(
                value: 0,
                child: Icon(
                  Icons.text_snippet,
                ),
              ),
              DropdownMenuItem(
                value: 1,
                child: Icon(
                  Icons.image,
                ),
              ),
              DropdownMenuItem(
                value: 2,
                child: Icon(
                  Icons.video_camera_back,
                ),
              ),
              DropdownMenuItem(
                value: 3,
                child: Icon(
                  Icons.music_note,
                ),
              ),
            ],
            onChanged: (dynamic value) {
              selectedType = value;
              setState(() {});
            },
          ),
        ],
      ),
      body: Center(
        child: [
          textUpload(firebaseStorage, firebaseAuth, firebaseFirestore),
          imageUpload(firebaseStorage, firebaseAuth, firebaseFirestore),
          videoUpload(firebaseStorage, firebaseAuth, firebaseFirestore),
          musicUpload(firebaseStorage, firebaseAuth, firebaseFirestore),
        ][selectedType],
      ),
    );
  }
}
