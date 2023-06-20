import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esgi_tweet/models/tweet.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TweetsRepository {
  final tweetsCollection = FirebaseFirestore.instance.collection('tweets');

  addTweets(Tweet tweet) async {
    try {
      await tweetsCollection.add(tweet.toMap());
    } catch (error) {
      print("Failed to create tweet: $error");
    }
  }

  Future<List<Tweet>> getTweets() async {
    final snapshot = await tweetsCollection.get();
    final tweetsData = snapshot.docs.map((element) => Tweet.fromSnapshot(element)).toList();
    return tweetsData;
  }

  Stream<QuerySnapshot> getTweetsRealTime() {
    final CollectionReference postsCollection = FirebaseFirestore.instance.collection('tweets');

    final Stream<QuerySnapshot> postStream = postsCollection.snapshots(includeMetadataChanges: true);
    return postStream;
  }
}
