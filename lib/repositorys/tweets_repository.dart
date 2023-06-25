import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esgi_tweet/models/tweet.dart';

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
    final tweetsData =
        snapshot.docs.map((element) => Tweet.fromSnapshot(element)).toList();
    return tweetsData;
  }

  Stream<QuerySnapshot> getTweetsRealTime() {

    final Stream<QuerySnapshot> tweetsStream = tweetsCollection.snapshots(includeMetadataChanges: true);
    return tweetsStream;
  }

  Future<void> updateLikeTweet(String? tweetId, String userId) {
    DocumentReference documentReference = tweetsCollection.doc(tweetId);
    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(documentReference);

          if (!snapshot.exists) {
            throw Exception("Tweet does not exist!");
          }

          if (userId == '') {
            throw Exception("User does not exist!");
          }

          final currentLikes = List<String>.from((snapshot.get('likes') ?? []));
          if (!currentLikes.contains(userId)) {
            currentLikes.add(userId);
          }

          transaction.update(documentReference, {'likes': currentLikes});
        })
        .then((value) => print("Likes count updated to $value"))
        .catchError((error) => print("Failed to update tweet likes: $error"));
  }
}
