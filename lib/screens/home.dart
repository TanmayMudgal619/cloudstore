import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudstore/screens/seeimg.dart';
import 'package:cloudstore/screens/seemusic.dart';
import 'package:cloudstore/screens/seetext.dart';
import 'package:cloudstore/screens/seevideo.dart';
import 'package:cloudstore/screens/upload.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Map<String, dynamic> icons = {
    "text": Icons.text_snippet,
    "image": Icons.image,
    "video": Icons.video_file,
    "music": Icons.audio_file
  };
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white38,
                  backgroundImage: (firebaseAuth.currentUser!.photoURL == null)
                      ? (const AssetImage("assets/img/avatar.png"))
                      : (CachedNetworkImageProvider(
                              firebaseAuth.currentUser!.photoURL ?? ""))
                          as ImageProvider,
                  child: GestureDetector(
                    onTap: () {
                      _globalKey.currentState!.openDrawer();
                    },
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => allTexts(
                            firebaseAuth, firebaseFirestore, firebaseStorage)));
              },
              leading: const Icon(
                Icons.text_snippet,
              ),
              title: Text("Texts"),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => allImgs(
                            firebaseAuth, firebaseFirestore, firebaseStorage)));
              },
              leading: const Icon(
                Icons.image,
              ),
              title: Text("Images"),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => allVideos(
                            firebaseAuth, firebaseFirestore, firebaseStorage)));
              },
              leading: const Icon(
                Icons.video_file,
              ),
              title: Text("Videos"),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => allMusics(
                            firebaseAuth, firebaseFirestore, firebaseStorage)));
              },
              leading: const Icon(
                Icons.audio_file,
              ),
              title: Text("Music"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => upload()));
        },
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        title: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: TextField(
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              fillColor: Colors.blueAccent.withOpacity(0.2),
              hintText: "Search....",
              filled: true,
            ),
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: CircleAvatar(
            backgroundColor: Colors.white38,
            backgroundImage: (firebaseAuth.currentUser!.photoURL == null)
                ? (const AssetImage("assets/img/avatar.png"))
                : (CachedNetworkImageProvider(
                    firebaseAuth.currentUser!.photoURL ?? "")) as ImageProvider,
            child: GestureDetector(
              onTap: () {
                _globalKey.currentState!.openDrawer();
              },
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firebaseFirestore
            .collection("users")
            .where(
              "user",
              isEqualTo: firebaseAuth.currentUser!.phoneNumber,
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
                          icon: Icon(
                            icons[e["fileType"]],
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
                              downloadFile(
                                  firebaseStorage.ref("${e['downloadName']}"));
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

Future downloadFile(Reference ref) async {
  final dir = await getTemporaryDirectory();
  final path = dir.path + ref.name;
  print(ref.name);
  final url = await ref.getDownloadURL();
  print(url);
  await Dio().download(url, path);
}
