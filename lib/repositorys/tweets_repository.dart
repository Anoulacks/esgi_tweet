import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esgi_tweet/models/tweet.dart';

class TweetsRepository {
  final tweetsCollection = FirebaseFirestore.instance.collection('tweets');

  addTweets(Tweet tweet) async {
    try {
      DocumentReference tweetReference = await tweetsCollection.add(tweet.toMap());
      if (tweet.idTweetParent != null && tweet.idTweetParent != '') {
        updateCommentTweet(tweet.idTweetParent, tweetReference.id);
      }
    } catch (error) {
      print("Failed to create tweet: $error");
    }
  }

  Future<List<Tweet>> getTweets() async {
    final snapshot = await tweetsCollection.orderBy('date', descending: true).get();
    final tweetsData =
        snapshot.docs.map((element) => Tweet.fromSnapshot(element)).toList();
    return tweetsData;
  }

  Future<List<Tweet>> getTweetsByUser(String userId) async {
    final snapshot = await tweetsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();
    final tweetsData = snapshot.docs.map((element) => Tweet.fromSnapshot(element)).toList();
    return tweetsData;
  }

  Future<List<Tweet>> getLikedTweet(String userId) async {
    final snapshot = await tweetsCollection
        .where('likes', arrayContains: userId)
        .orderBy('date', descending: true)
        .get();

    final tweetsData = snapshot.docs.map((element) => Tweet.fromSnapshot(element)).toList();
    return tweetsData;
  }

  Future<List<Tweet>> getTweetsDetail(tweet) async {
    final snapshot = await tweetsCollection
        .where('idTweetParent', isEqualTo: '${tweet.id}')
        .orderBy('date', descending: true)
        .get();
    final tweetsData =
    snapshot.docs.map((element) => Tweet.fromSnapshot(element)).toList();
    return tweetsData;
  }

  Stream<List<Tweet>> getTweetsRealTime() {
    try {
      return tweetsCollection.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return Tweet.fromFirestore(doc.data(), doc.id);
        }).toList();
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteTweet(tweet) async {
    try {
      final tweetsCollection = FirebaseFirestore.instance.collection('tweets');
      await tweetsCollection.doc(tweet.id).delete();

      if (tweet.idTweetParent != null && tweet.idTweetParent != "") {
        final tweetParentSnapshot = await tweetsCollection.doc(tweet.idTweetParent).get();
        final tweetParentData = tweetParentSnapshot.data();

        if (tweetParentData != null) {
          final comments = tweetParentData['comments'];
          final updatedComments = List.from(comments);

          updatedComments.remove(tweet.id);

          await tweetsCollection.doc(tweet.idTweetParent).update({
            'comments': updatedComments,
          });
        }
      }
    } catch (error) {
      throw Exception(error);
    }
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
          } else {
            currentLikes.remove(userId);
          }

          transaction.update(documentReference, {'likes': currentLikes});
        })
        .then((value) => print("Likes count updated to $value"))
        .catchError((error) => print("Failed to update tweet likes: $error"));
  }

  Future<void> updateCommentTweet(String? tweetIdParent, String? tweetId) {
    DocumentReference documentReference = tweetsCollection.doc(tweetIdParent);
    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("Tweet does not exist!");
      }

      if (tweetIdParent == '') {
        throw Exception("Tweet Parent does not exist!");
      }

      print('affiche tweet id et parentid $tweetId $tweetIdParent');

      final currentComments = List<String>.from((snapshot.get('comments') ?? []));
      if (!currentComments.contains(tweetId)) {
        currentComments.add(tweetId!);
      }

      transaction.update(documentReference, {'comments': currentComments});
    })
        .then((value) => print("Comments count updated to $value"))
        .catchError((error) => print("Failed to update tweet comments: $error"));
  }
}
