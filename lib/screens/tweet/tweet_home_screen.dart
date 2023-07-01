import 'package:esgi_tweet/blocs/tweets_bloc/tweets_bloc.dart';
import 'package:esgi_tweet/repositorys/users_repository.dart';
import 'package:esgi_tweet/screens/tweet/tweet_add_screen.dart';
import 'package:esgi_tweet/screens/tweet/widgets/tweet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../main.dart';
import '../../models/user.dart';
import '../../utils/shared_preferences.dart';

class TweetHomeScreen extends StatefulWidget {
  static const String routeName = '/TweetHome';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  const TweetHomeScreen({Key? key}) : super(key: key);

  @override
  State<TweetHomeScreen> createState() => _TweetHomeScreenState();
}

class _TweetHomeScreenState extends State<TweetHomeScreen> {
  final _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() {
    context.read<TweetsBloc>().add(GetAllTweets());
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ESGI Tweet'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              UserSharedPreferences.isDarkModeEnabled()
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              bool isDarkModeEnabled = UserSharedPreferences.isDarkModeEnabled();
              UserSharedPreferences.setDarkMode(!isDarkModeEnabled);
              setState(() {
                runApp(MyApp());
              });
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _logout(context);
              },
            ),
          ],
        ),
        body: BlocBuilder<TweetsBloc, TweetsState>(
          builder: (context, state) {
            switch (state.status) {
              case TweetsStatus.initial:
                return const SizedBox();
              case TweetsStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case TweetsStatus.error:
                return Center(
                  child: Text(state.error),
                );
              case TweetsStatus.success:
                final tweets = state.tweets;

                if (tweets.isEmpty) {
                  return const Center(
                    child: Text('Aucun tweet'),
                  );
                }

                return SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  onRefresh: () async {
                    _onRefreshList(context);
                  },
                  child: ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (context, index) {
                      final tweet = tweets[index];
                      return FutureBuilder<UserApp>(
                        future: RepositoryProvider.of<UsersRepository>(context)
                            .getUserById(tweet.userId),
                        builder: (BuildContext context,
                            AsyncSnapshot<UserApp> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return Text('Error: ${snapshot.error}');
                          }
                          UserApp userApp = snapshot.data!;
                          if (snapshot.hasData) {
                            return TweetCard(
                              tweet: tweet,
                              user: userApp,
                            );
                          }
                          return Text('Error: pas de données');
                        },
                      );
                    },
                  ),
                );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {TweetAddScreen.navigateTo(context, '')},
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      );
    });
  }

  void _onRefreshList(BuildContext context) {
    final postBloc = BlocProvider.of<TweetsBloc>(context);
    postBloc.add(GetAllTweets());
    _refreshController.refreshCompleted();
  }

  void _logout(BuildContext context) {
    RepositoryProvider.of<UsersRepository>(context).signOut(context);
  }
}
