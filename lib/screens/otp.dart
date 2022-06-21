import 'package:cloudstore/screens/home.dart';
import 'package:cloudstore/screens/setuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class OTP extends StatefulWidget {
  final String verificationId;
  const OTP(this.verificationId, {Key? key}) : super(key: key);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  TextEditingController otp = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool verifying = false;
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
                controller: otp,
                decoration: const InputDecoration(
                  label: Text(
                    "OTP",
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  if (!verifying) {
                    setState(() {
                      verifying = true;
                    });
                    verifyOTP(context);
                  }
                },
                child: (verifying)
                    ? (const Center(
                        child: CircularProgressIndicator(),
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

  void verifyOTP(BuildContext context) {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otp.text,
    );
    firebaseAuth.signInWithCredential(phoneAuthCredential).whenComplete(() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                (firebaseAuth.currentUser!.displayName == null)
                    ? (setUser())
                    : (Home())),
        (route) => false,
      );
    });
  }
}
