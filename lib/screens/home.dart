import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudstore/screens/upload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
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
            const ListTile(
              leading: Icon(
                Icons.text_snippet,
              ),
              title: Text("Texts"),
            ),
            const ListTile(
              leading: Icon(
                Icons.image,
              ),
              title: Text("Images"),
            ),
            const ListTile(
              leading: Icon(
                Icons.video_camera_back_rounded,
              ),
              title: Text("Videos"),
            ),
            const ListTile(
              leading: Icon(
                Icons.music_note,
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
    );
  }
}
