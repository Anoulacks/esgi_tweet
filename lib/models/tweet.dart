import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  final String? id;
  final String userId;
  final String body;
  final Timestamp date;
  final List<String>? likes;
  final List<String>? dislikes;
  final List<String>? comments;
  final String? image;

  Tweet(
      {this.id,
      required this.userId,
      required this.body,
      required this.date,
      this.likes,
      this.dislikes,
      this.comments,
      this.image});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'body': body,
      'date': date,
      'likes': likes,
      'dislikes': dislikes,
      'comments': comments,
      'image': image
    };
  }

  @override
  String toString() {
    return 'Post { id: $id, userId: $userId, body: $body, date: $date, likes: $likes, dislikes: $dislikes, comments: $comments, image: $image }';
  }
}
