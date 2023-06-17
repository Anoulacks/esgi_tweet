import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esgi_tweet/models/tweet.dart';
import 'package:esgi_tweet/repositorys/image_repository.dart';
import 'package:esgi_tweet/repositorys/tweets_repository.dart';
import 'package:esgi_tweet/repositorys/users_repository.dart';
import 'package:esgi_tweet/widgets/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TweetAddScreen extends StatefulWidget {
  static const String routeName = '/TweetAdd';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  const TweetAddScreen({Key? key}) : super(key: key);

  @override
  State<TweetAddScreen> createState() => _TweetAddScreenState();
}

class _TweetAddScreenState extends State<TweetAddScreen> {
  final _tweetForm = GlobalKey<FormState>();
  final _bodyController = TextEditingController();
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Ajouter un Tweet'),
      ),
      body: Form(
        key: _tweetForm,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            ImagePickerWidget(callback: getImageEvent),
            ElevatedButton(
              onPressed: () async {
                if (_tweetForm.currentState!.validate()) {
                  String? userUid = RepositoryProvider.of<UsersRepository>(context).getCurrentUserID();
                  if(userUid != null) {
                    final urlImage = await RepositoryProvider.of<ImageRepository>(context).uploadImage(image);
                    Tweet tweet = Tweet(
                        userId: userUid,
                        body: _bodyController.text,
                        image: urlImage,
                        date: Timestamp.now());
                    RepositoryProvider.of<TweetsRepository>(context).addTweets(tweet);
                  }
                }
              },
              child: const Text('Publier'),
            ),
          ],
        ),
      ),
    );
  }
  void getImageEvent(File? file) {
    image = file;
  }
}
