import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudstore/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class allImgs extends StatefulWidget {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  const allImgs(this.firebaseAuth, this.firebaseFirestore, this.firebaseStorage,
      {Key? key})
      : super(key: key);

  @override
  State<allImgs> createState() => _allImgsState();
}

class _allImgsState extends State<allImgs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Images",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: widget.firebaseFirestore
            .collection("users")
            .where(
              "user",
              isEqualTo: widget.firebaseAuth.currentUser!.phoneNumber,
            )
            .where(
              "fileType",
              isEqualTo: "image",
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = snapshot.requireData;
          if (data.docs.isEmpty) {
            return const Center(
              child: Text("Upload Something....."),
            );
          }
          return GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(10),
            children: data.docs
                .map(
                  (e) => Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.image,
                          ),
                        ),
                        ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          title: Text(
                            e["fileName"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          contentPadding: const EdgeInsets.only(left: 10),
                          trailing: IconButton(
                            icon: const Icon(Icons.download),
                            onPressed: () {
                              downloadFile(widget.firebaseStorage
                                  .ref("${e['downloadName']}"));
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
