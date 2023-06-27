import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esgi_tweet/blocs/users_bloc/users_bloc.dart';
import 'package:esgi_tweet/models/tweet.dart';
import 'package:esgi_tweet/repositorys/image_repository.dart';
import 'package:esgi_tweet/repositorys/tweets_repository.dart';
import 'package:esgi_tweet/widgets/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/shared_preferences.dart';

class TweetAddScreen extends StatefulWidget {
  static const String routeName = '/TweetAdd';

  static void navigateTo(BuildContext context, String? tweetId) {
    Navigator.of(context).pushNamed(routeName, arguments: tweetId);
  }

  final String? tweetId;

  const TweetAddScreen({Key? key, this.tweetId}) : super(key: key);

  @override
  State<TweetAddScreen> createState() => _TweetAddScreenState();
}

class _TweetAddScreenState extends State<TweetAddScreen> {
  final _tweetForm = GlobalKey<FormState>();
  final _bodyController = TextEditingController();
  File? image;

  @override
  Widget build(BuildContext context) {
    final isDarkModeEnabled = UserSharedPreferences.isDarkModeEnabled();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: isDarkModeEnabled ? Colors.black12 : Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), child: const Text("Retour"),
          ),
          Spacer(),
          TextButton(
            onPressed: () async {
              if (_tweetForm.currentState!.validate()) {
                String? userUid =
                    RepositoryProvider.of<UsersRepository>(context)
                        .getCurrentUserID();
                if (userUid != null) {
                  if (image != null) {
                    final urlImage =
                        await RepositoryProvider.of<ImageRepository>(context)
                            .uploadImage(image);
                    Tweet tweet = Tweet(
                        userId: userUid,
                        body: _bodyController.text,
                        image: urlImage,
                        date: Timestamp.now(),
                        idTweetParent: widget.tweetId);
                    RepositoryProvider.of<TweetsRepository>(context)
                        .addTweets(tweet);
                  } else {
                    Tweet tweet = Tweet(
                        userId: userUid,
                        body: _bodyController.text,
                        date: Timestamp.now(),
                        idTweetParent: widget.tweetId);
                    RepositoryProvider.of<TweetsRepository>(context)
                        .addTweets(tweet);
                  }
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue, // Replace with your desired background color
                borderRadius: BorderRadius.circular(10), // Replace with your desired border radius
              ),
              padding: EdgeInsets.all(10), // Optional: Add padding if needed
              child: Text(
                'Tweeter',
                style: TextStyle(
                  color: Colors.white, // Replace with your desired text color
                ),
              ),
            ),
          )
        ],
      ),
      body: Form(
        key: _tweetForm,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 3,
                child: TextFormField(
                  maxLines: null,
                  controller: _bodyController,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: InputBorder.none,
                      labelText: 'Quoi de neuf ?'),
                ),
              ),
              ImagePickerWidget(callback: getImageEvent),
            ],
          ),
        ),
      ),
    );
  }

  void getImageEvent(File? file) {
    image = file;
  }
}
