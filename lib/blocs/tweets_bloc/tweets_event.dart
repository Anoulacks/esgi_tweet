part of 'tweets_bloc.dart';

@immutable
abstract class TweetsEvent {}

class GetAllTweets extends TweetsEvent {
  GetAllTweets();
}

class GetTweetsDetail extends TweetsEvent {
  final Tweet tweet;

  GetTweetsDetail(this.tweet);
}
