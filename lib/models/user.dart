import 'package:cloud_firestore/cloud_firestore.dart';

class UserApp {
  final String? id;
  final String firstname;
  final String lastname;
  final String pseudo;
  final String email;
  final String? photoURL;
  final Timestamp birthDate;
  final String phoneNumber;
  final String address;
  final List<dynamic>? followers;
  final List<dynamic>? followings;

  UserApp(
      {this.id,
      required this.firstname,
      required this.lastname,
      required this.pseudo,
      required this.email,
      this.photoURL,
      required this.birthDate,
      required this.phoneNumber,
      required this.address,
      this.followers,
      this.followings,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'pseudo': pseudo,
      'email': email,
      'photoURL': photoURL,
      'birthDate': birthDate,
      'phoneNumber': phoneNumber,
      'address': address,
      'followers': followers,
      'followings': followings,
    };
  }

  factory UserApp.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserApp(
      id: document.id,
      firstname: data["firstname"],
      lastname: data["lastname"],
      pseudo: data["pseudo"],
      email: data["email"],
      photoURL: data["photoURL"],
      birthDate: data["birthDate"],
      phoneNumber: data["phoneNumber"],
      address: data["address"],
      followers: data["followers"],
      followings: data["followings"],
    );
  }
}
