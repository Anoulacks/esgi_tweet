import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/tweets_bloc/tweets_bloc.dart';
import '../../../models/user.dart';
import '../../../repositorys/users_repository.dart';
import '../../tweet/widgets/tweet_card.dart';

class UserTweetsList extends StatelessWidget {
  final String userId;

  const UserTweetsList({Key? key, required this.userId}) : super(key: key);

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
            final tweets = state.tweets;

            if (tweets.isEmpty) {
              return const Center(
                child: Text('Aucun tweet'),
              );
            }

            return ListView.builder(
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
                    return Text('Error: pas de données');
                  },
                );
              },
            );
        }
      },
    );
  }
}
