// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/pages/home/main_dashboard.dart';
import 'package:jahnhalle/components/utils/keys.dart';
import 'package:jahnhalle/components/utils/social_login.dart';
import 'package:jahnhalle/components/utils/sp.dart';
import 'package:jahnhalle/components/widgets/image_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "REGISTRIEREN / ANMELDEN",
                style: TextStyle(fontSize: dimensions.width * 0.04),
              ),
              SizedBox(
                height: dimensions.width * 0.03,
              ),
              InkWell(
                onTap: () async {
                  try {
                    final google = await SocialLogin.shared.googleSignIn();
                    if (google != null) {
                      final QuerySnapshot result = await FirebaseFirestore
                          .instance
                          .collection('users')
                          .where('email', isEqualTo: google.email)
                          .get();

                      final List<DocumentSnapshot> documents = result.docs;

                      if (documents.isEmpty) {
                        final data = await FirebaseFirestore.instance
                            .collection('users')
                            .add({
                          "email": google.email,
                          "is_login": "1",
                          "name": google.displayName,
                          "user_id": google.id
                        });
                        if (data.id.isNotEmpty) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => MainDashboard(),
                            ),
                            (route) => false,
                          );
                          SP.i.setString(key: SPKeys.isLoggedIn, value: "1");
                          SP.i.setString(key: SPKeys.userId, value: google.id);
                        }
                      } else {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => MainDashboard(),
                          ),
                          (route) => false,
                        );
                        SP.i.setString(
                            key: SPKeys.isLoggedIn,
                            value: documents.first.get("is_login").toString());
                        SP.i.setString(
                            key: SPKeys.userId,
                            value: documents.first.get("user_id").toString());
                      }
                    }
                  } catch (e) {
                    log("$e");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Row(
                    children: [
                      ImageWidget(
                        url: "assets/icons/icons8-google.svg",
                        height: 25,
                        width: 25,
                      ),
                      const Expanded(
                        child: Text(
                          "Continue with Google",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: dimensions.width * 0.03,
              ),
              if (Platform.isIOS)
                InkWell(
                  onTap: () async {
                    try {
                      final apple = await SocialLogin.shared.appleLogin();
                      if (apple != null) {
                        FirebaseFirestore.instance.collection('users').add({
                          "email": apple.email,
                          "is_login": "1",
                          "name": apple.familyName,
                          "user_id": apple.userIdentifier
                        });
                      }
                    } catch (e) {
                      log("$e");
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black),
                    child: Row(
                      children: [
                        ImageWidget(
                          url: "assets/icons/icons8-apple.svg",
                          height: 25,
                          width: 25,
                        ),
                        const Expanded(
                          child: Text(
                            "Continue with Apple",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
