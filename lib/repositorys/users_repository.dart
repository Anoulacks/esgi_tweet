import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esgi_tweet/models/user.dart';
import 'package:esgi_tweet/screens/authentification/login_screen.dart';
import 'package:esgi_tweet/screens/tweet/tweet_home_screen.dart';
import 'package:esgi_tweet/screens/tweet/tweet_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        'photoURL': '',
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

  signIn(email, password, context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      TweetHomeScreen.navigateTo(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Le mail ou le mot de passe est incorrect.');
      } else if (e.code == 'wrong-password') {
        print('Le mail ou le mot de passe est incorrect.');
      }
    }
  }

  String? getCurrentUserID() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    return null;
  }

  Future<UserApp> getUserById(id) async {
    final document = await usersCollection.doc(id).get();
    return UserApp.fromSnapshot(document);
  }

  signOut(context) async {
    await FirebaseAuth.instance.signOut();
    LoginScreen.navigateTo(context);
  }
}
