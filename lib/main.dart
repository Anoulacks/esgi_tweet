import 'dart:async';
import 'dart:isolate';

import 'package:esgi_tweet/blocs/tweets_bloc/tweets_bloc.dart';
import 'package:esgi_tweet/blocs/users_bloc/users_bloc.dart';
import 'package:esgi_tweet/models/tweet.dart';
import 'package:esgi_tweet/repositorys/image_repository.dart';
import 'package:esgi_tweet/repositorys/tweets_repository.dart';
import 'package:esgi_tweet/repositorys/users_repository.dart';
import 'package:esgi_tweet/screens/area/area_screen.dart';
import 'package:esgi_tweet/screens/authentification/login_screen.dart';
import 'package:esgi_tweet/screens/authentification/register_screen.dart';
import 'package:esgi_tweet/screens/tweet/tweet_add_screen.dart';
import 'package:esgi_tweet/screens/tweet/tweet_detail_screen.dart';
import 'package:esgi_tweet/screens/tweet/tweet_home_screen.dart';
import 'package:esgi_tweet/utils/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserSharedPreferences.initPref();
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
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                TweetsBloc(
                  repository: RepositoryProvider.of<TweetsRepository>(context),
                ),
          ),
          BlocProvider(
            create: (context) =>
                UsersBloc(
                    repository: RepositoryProvider.of<UsersRepository>(context)
                ),
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
            AreaScreen.routeName: (context) => const AreaScreen(),
            TweetHomeScreen.routeName: (context) => const TweetHomeScreen(),
          },
          onGenerateRoute: (settings) {
            Widget content = const SizedBox.shrink();
            switch (settings.name) {
              case TweetAddScreen.routeName:
                final arguments = settings.arguments;
                if (arguments is String?) {
                  content = TweetAddScreen(tweetId: arguments);
                }
                break;
              case TweetDetailScreen.routeName:
                final arguments = settings.arguments;
                if (arguments is Tweet) {
                  content = TweetDetailScreen(tweet: arguments);
                }
            }

            return MaterialPageRoute(
              builder: (context) {
                return content;
              },
            );
          },
        ),
      ),
    );
  }
}


