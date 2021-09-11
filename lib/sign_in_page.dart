import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gammal_tech_mobile_app/Firebase/firebase.dart';
import 'package:gammal_tech_mobile_app/common_ui/common-ui.dart';
import 'package:gammal_tech_mobile_app/home_page.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class signInPage extends StatefulWidget {
  @override
  State<signInPage> createState() => _signInPageState();
}

class _signInPageState extends State<signInPage> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final phoneController = TextEditingController();
  late String zd;
  final otpController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String finalNumber = "";
  FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;

  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (authCredential.user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
        );
        CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('users');
        QuerySnapshot querySnapshot = await _collectionRef.get();
        int i = 0;
        for (i = 0; i < querySnapshot.docs.length; i++) {
          if (querySnapshot.docs[i]["phone"] == user!.phoneNumber) break;
          else if(i == querySnapshot.docs.length-1){

          }
        }

      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Color.fromARGB(215, 11, 108, 108),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TheHeadCardOfText("Sign In"),
                    Text(
                      "Enter your phone number to sign in or to sign up.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 40, left: 40),
                        child: Container(
                          color: Colors.white,
                          width: double.infinity,
                          child: Padding(
                            key: _scaffoldKey,
                            padding: const EdgeInsets.all(8.0),

                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          buildTheBottomContainer()
        ],
      ),
    );
  }

}
