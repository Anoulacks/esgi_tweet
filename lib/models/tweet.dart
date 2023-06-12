import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  final String? id;
  final String userId;
  final String body;
  final Timestamp date;
  final List<String> likes;
  final List<String> dislikes;
  final List<String> comments;
  final String? image;

  Tweet(this.id, this.userId, this.body, this.date, this.likes, this.dislikes, this.comments, this.image);
}