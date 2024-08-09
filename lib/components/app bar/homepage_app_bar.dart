import 'package:flutter/material.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const HomePageAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Same color as background
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge, // Use defined text style
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 138.0, // Set the desired width
            height: 21.0, // Set the desired height
            child: Image.asset(
                'assets/logo.png'), // Replace with your logo asset path
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
