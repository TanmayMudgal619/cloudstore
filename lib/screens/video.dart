import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class videoUpload extends StatefulWidget {
  final FirebaseStorage firebaseStorage;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  const videoUpload(
      this.firebaseStorage, this.firebaseAuth, this.firebaseFirestore,
      {Key? key})
      : super(key: key);

  @override
  State<videoUpload> createState() => _videoUploadState();
}

class _videoUploadState extends State<videoUpload> {
  String videopath = "";
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
                    icon: const Icon(Icons.video_file),
                    color: Colors.blueAccent,
                  ),
                ),
                Text(videopath.substring(videopath.lastIndexOf("/") + 1))
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              child: TextButton(
                onPressed: () {
                  if (videopath != "") {
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
            "text/${DateTime.now().toString() + widget.firebaseAuth.currentUser!.uid}")
        .putFile(File(videopath));
    await widget.firebaseFirestore.collection("users").add({
      "user": widget.firebaseAuth.currentUser!.phoneNumber,
      "fileType": "video",
      "downloadLink": await imgLink.ref.getDownloadURL(),
      "createdAt": Timestamp.now(),
      "fileName": videopath.substring(videopath.lastIndexOf("/") + 1),
    }).whenComplete(() => Navigator.pop(context));
  }

  void selectFile() async {
    FilePickerResult? path = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (path == null) {
      videopath = "";
    } else {
      videopath = path.paths[0] ?? "";
    }
    setState(() {});
  }
}
