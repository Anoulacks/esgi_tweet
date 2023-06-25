import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  final String? id;
  final String userId;
  final String body;
  final Timestamp date;
  final List<dynamic>? likes;
  final List<dynamic>? comments;
  final String? image;
  final String? idTweetParent;

  Tweet(
      {this.id,
      required this.userId,
      required this.body,
      required this.date,
      this.likes,
      this.comments,
      this.image,
      this.idTweetParent});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'body': body,
      'date': date,
      'likes': likes,
      'comments': comments,
      'image': image,
      'idTweetParent': idTweetParent,
    };
  }

  factory Tweet.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Tweet(
      id: document.id,
      userId: data["userId"],
      body: data["body"],
      date: data["date"],
      likes: data["likes"],
      comments: data["comments"],
      image: data["image"],
      idTweetParent: data["idTweetParent"],
    );
  }

  @override
  String toString() {
    return 'Tweet { id: $id, userId: $userId, body: $body, date: $date, likes: $likes, comments: $comments, image: $image, idTweetParent: $idTweetParent }';
  }
}
