import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jahnhalle/components/drawer/my_drawer_tile.dart';
import 'package:jahnhalle/components/drawer/user_modal.dart';
import 'package:jahnhalle/pages/mohsim/login.dart';
import 'package:jahnhalle/pages/mohsim/utils/keys.dart';
import 'package:jahnhalle/pages/mohsim/utils/sp.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  User? user;
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final user = await FirebaseFirestore.instance
          .collection("users")
          .where("user_id", isEqualTo: SP.i.getString(key: SPKeys.userId))
          .get();
      final List<DocumentSnapshot> documents = user.docs;
      this.user = userFromJson(jsonEncode(documents.first.data()));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context)
            .scaffoldBackgroundColor, // Use the seed color for background
        child: Column(
          children: <Widget>[
            const SizedBox(height: 60), // Add space to the top
            Container(
              color: Theme.of(context)
                  .scaffoldBackgroundColor, // Same as the background color
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30, // Adjust the radius as needed
                    backgroundImage: AssetImage(
                        'assets/profile.png'), // Path to profile image
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kunde',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium, // Use defined text style
                        ),
                        Text(
                          user?.name ?? "",
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge, // Use defined text style
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 3.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  MyDrawerTile(
                    text: 'Home',
                    icon: Icons.home,
                    onTap: () => Navigator.pop(context),
                  ),
                  MyDrawerTile(
                    text: 'Profil',
                    icon: Icons.person,
                    onTap: () {},
                  ),
                  MyDrawerTile(
                    text: 'Einstellungen',
                    icon: Icons.settings,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                MyDrawerTile(
                  text: 'Hilfe',
                  icon: Icons.help,
                  onTap: () {},
                ),
                MyDrawerTile(
                  text: 'Abmelden',
                  icon: Icons.logout,
                  onTap: () async {
                    SP.i.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
                const SizedBox(height: 25),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
