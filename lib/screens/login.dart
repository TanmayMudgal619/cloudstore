import 'package:cloudstore/screens/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController mobileNumber = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool logging = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/img/logo.png",
                width: 100,
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: mobileNumber,
                decoration: const InputDecoration(
                  label: Text(
                    "Mobile Number",
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  if (!logging) {
                    setState(() {
                      logging = true;
                    });
                    verifyNumber();
                  }
                },
                child: (logging)
                    ? (const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        ),
                      ))
                    : (const Text(
                        "Next",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void verifyNumber() {
    firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+91 ${mobileNumber.text}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException exception) {
        print("EXCEPTION: ${exception.message}");
      },
      codeSent: (String verificationId, _) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OTP(verificationId)));
      },
      codeAutoRetrievalTimeout: (String codeAutoRetrivalTimeout) {},
    );
  }
}
