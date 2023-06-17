import 'dart:async';
import 'dart:isolate';

import 'package:esgi_tweet/repositorys/image_repository.dart';
import 'package:esgi_tweet/repositorys/tweets_repository.dart';
import 'package:esgi_tweet/repositorys/users_repository.dart';
import 'package:esgi_tweet/screens/authentification/login_screen.dart';
import 'package:esgi_tweet/screens/authentification/register_screen.dart';
import 'package:esgi_tweet/screens/tweet/tweet_add_screen.dart';
import 'package:esgi_tweet/screens/tweet/tweet_home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runZonedGuarded<Future<void>>(() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);

    runApp(const MyApp());
  }, FirebaseCrashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => UsersRepository(),
        ),
        RepositoryProvider(
          create: (context) => TweetsRepository(),
        ),
        RepositoryProvider(
          create: (context) => ImageRepository(),
        ),
      ],
      child: MaterialApp(
        title: 'Esgi Tweet',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => const LoginScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          RegisterScreen.routeName: (context) => const RegisterScreen(),
          TweetHomeScreen.routeName: (context) => const TweetHomeScreen(),
          TweetAddScreen.routeName: (context) => const TweetAddScreen(),
        },
      ),
    );
  }
}


