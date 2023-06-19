import 'package:esgi_tweet/screens/tweet/tweet_add_screen.dart';
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
      body: const Text('liste des tweets'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {TweetAddScreen.navigateTo(context)},
        child: const Icon(Icons.add),
      ),
    );
  }
}
