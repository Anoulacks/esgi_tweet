import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esgi_tweet/models/tweet.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TweetsRepository {
  final CollectionReference tweetsCollection = FirebaseFirestore.instance.collection('tweets');

  addTweets(Tweet tweet) async {
    try {
      await tweetsCollection.add(tweet.toMap());
    } catch (error) {
      print("Failed to create tweet: $error");
    }
  }
}
