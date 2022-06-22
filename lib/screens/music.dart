import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class musicUpload extends StatefulWidget {
  final FirebaseStorage firebaseStorage;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  const musicUpload(
      this.firebaseStorage, this.firebaseAuth, this.firebaseFirestore,
      {Key? key})
      : super(key: key);

  @override
  State<musicUpload> createState() => _musicUploadState();
}

class _musicUploadState extends State<musicUpload> {
  String musicpath = "";
  bool uploading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: IconButton(
                    onPressed: () {
                      if (!uploading) selectFile();
                    },
                    iconSize: 150,
                    icon: const Icon(Icons.audio_file),
                    color: Colors.blueAccent,
                  ),
                ),
                Text(musicpath.substring(musicpath.lastIndexOf("/") + 1))
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              child: TextButton(
                onPressed: () {
                  if (musicpath != "") {
                    setState(() {
                      uploading = true;
                    });
                    upload();
                  }
                },
                child: (uploading)
                    ? (const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      ))
                    : (const Text("Upload")),
              ),
            ),
          )
        ],
      ),
    );
  }

  void upload() async {
    final imgLink = await widget.firebaseStorage
        .ref(
            "music/${DateTime.now().toString().replaceAll(".", " ") + widget.firebaseAuth.currentUser!.uid + musicpath.substring(musicpath.lastIndexOf("/") + 1)}")
        .putFile(File(musicpath));
    await widget.firebaseFirestore.collection("users").add({
      "user": widget.firebaseAuth.currentUser!.phoneNumber,
      "fileType": "music",
      "downloadLink": await imgLink.ref.getDownloadURL(),
      "createdAt": Timestamp.now(),
      "fileName": musicpath.substring(musicpath.lastIndexOf("/") + 1),
      "downloadName": imgLink.ref.fullPath,
    }).whenComplete(() => Navigator.pop(context));
  }

  void selectFile() async {
    FilePickerResult? path = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (path == null) {
      musicpath = "";
    } else {
      musicpath = path.paths[0] ?? "";
    }
    setState(() {});
  }
}
