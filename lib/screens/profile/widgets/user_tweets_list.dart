import 'package:esgi_tweet/blocs/users_bloc/users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../blocs/tweets_bloc/tweets_bloc.dart';
import '../../../models/user.dart';
import '../../../repositorys/users_repository.dart';
import '../../tweet/widgets/tweet_card.dart';

class UserTweetsList extends StatelessWidget {
  final String userId;
  final RefreshController _refreshController = RefreshController();

  UserTweetsList({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tweetsBloc = BlocProvider.of<TweetsBloc>(context);
    tweetsBloc.add(GetTweetsByUser(userId));

    return BlocBuilder<TweetsBloc, TweetsState>(
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
            late final tweets;
            if (userId == BlocProvider.of<UsersBloc>(context).state.user?.id) {
              tweets = state.tweetsProfile;
              _refreshController.refreshCompleted();
            } else {
              tweets = state.tweetsProfileSelected;
              _refreshController.refreshCompleted();
            }

            if (tweets.isEmpty) {
              return const Center(
                child: Text('Aucun tweet'),
              );
            }

            return SmartRefresher(
              controller: _refreshController,
              onRefresh: () => _onRefresh(context),
              child: ListView.builder(
                itemCount: tweets.length,
                itemBuilder: (context, index) {
                  final tweet = tweets[index];
                  return FutureBuilder<UserApp>(
                    future: RepositoryProvider.of<UsersRepository>(context)
                        .getUserById(tweet.userId),
                    builder: (BuildContext context,
                        AsyncSnapshot<UserApp> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                      return const Text('Pas de données');
                    },
                  );
                },
              ),
            );
        }
      },
    );
  }

  void _onRefresh(BuildContext context) {
    final tweetsBloc = BlocProvider.of<TweetsBloc>(context);
    tweetsBloc.add(GetTweetsByUser(userId));
    _refreshController.refreshCompleted();
  }
}
