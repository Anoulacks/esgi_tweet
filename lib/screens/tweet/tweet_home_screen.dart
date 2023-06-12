import 'package:flutter/material.dart';

class TweetHomeScreen extends StatelessWidget {

  static const String routeName = '/TweetHome';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  const TweetHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('liste des tweets'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: const Icon(Icons.add),
      ),);
  }
}
