import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esgi_tweet/models/tweet.dart';

class User {
  final String? id;
  final String firstname;
  final String lastname;
  final String pseudo;
  final String email;
  final String? photoURL;
  final Timestamp birthDate;
  final String phoneNumber;
  final String address;
  final List<String>? followers;
  final List<String>? followings;
  final List<Tweet>? tweets;

  User(this.id, this.firstname, this.lastname, this.pseudo, this.email, this.photoURL, this.birthDate, this.phoneNumber, this.address, this.followers, this.followings, this.tweets);
}