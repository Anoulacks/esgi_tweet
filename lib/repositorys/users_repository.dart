import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esgi_tweet/blocs/users_bloc/users_bloc.dart';
import 'package:esgi_tweet/models/user.dart';
import 'package:esgi_tweet/screens/authentification/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:esgi_tweet/screens/area/area_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersRepository {

  final usersCollection = FirebaseFirestore.instance.collection('users');

  addUser(firstname, lastname, pseudo, birthDate, phoneNumber, address, email, password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      String userId = userCredential.user!.uid;

      Timestamp birthDateTS = Timestamp.fromDate(DateTime.parse(birthDate));

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'firstname': firstname,
        'lastname': lastname,
        'pseudo': pseudo,
        'email': email,
        'birthDate': birthDateTS,
        'phoneNumber': phoneNumber,
        'address': address,
        'photoURL': null,
        'followers': [],
        'followings': [],
        'tweets': [],
      });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Le mot de passe est trop faible.');
      } else if (e.code == 'email-already-in-use') {
        print('Ce mail est déjà utilisé.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUser(UserApp user) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserFollow(String? targetUserId, String subscribedUserId, String key) async {
    if (targetUserId != subscribedUserId) {
      DocumentReference documentReference = usersCollection.doc(targetUserId);
      return FirebaseFirestore.instance
          .runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (!snapshot.exists) {
          throw Exception("$key does not exist!");
        }

        if (subscribedUserId == '') {
          throw Exception("$key does not exist!");
        }

        final currentFollowings = List<String>.from((snapshot.get(key) ?? []));
        if (!currentFollowings.contains(subscribedUserId)) {
          currentFollowings.add(subscribedUserId);
        } else {
          currentFollowings.remove(subscribedUserId);
        }

        transaction.update(documentReference, {key: currentFollowings});
      })
          .then((value) => print("$key count updated to $value"))
          .catchError((error) => print("Failed to update $key: $error"));
    }
  }

  Future<void> updateUserFollowers(String? targetUserId, String subscribedUserId) async {
    updateUserFollow(targetUserId, subscribedUserId, 'followers');
  }

  Future<void> updateUserFollowings(String? targetUserId, String subscribedUserId) async {
    updateUserFollow(targetUserId, subscribedUserId, 'followings');
  }

  signIn(email, password, context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      BlocProvider.of<UsersBloc>(context).add(GetUser());
      AreaScreen.navigateTo(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Le mail ou le mot de passe est incorrect.');
      } else if (e.code == 'wrong-password') {
        print('Le mail ou le mot de passe est incorrect.');
      }
    }
  }

  String getCurrentUserID() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    return '';
  }

  Future<UserApp> getUserById(id) async {
    final document = await usersCollection.doc(id).get();
    return UserApp.fromSnapshot(document);
  }

  Future<List<UserApp>> getUsers() async {
    final snapshot = await usersCollection.get();
    final usersData = snapshot.docs.map((element) => UserApp.fromSnapshot(element)).toList();
    return usersData;
  }

  signOut(context) async {
    await FirebaseAuth.instance.signOut();
    LoginScreen.navigateTo(context);
  }
}
