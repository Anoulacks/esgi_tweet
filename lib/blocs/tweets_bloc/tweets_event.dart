part of 'tweets_bloc.dart';

@immutable
abstract class TweetsEvent {}

class GetAllTweets extends TweetsEvent {
  GetAllTweets();
}
