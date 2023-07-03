part of 'tweets_bloc.dart';

@immutable
abstract class TweetsEvent {}

class GetAllTweets extends TweetsEvent {
  GetAllTweets();
}

class GetTweetsByUser extends TweetsEvent {
  final String userId;
  GetTweetsByUser(this.userId);
}

class GetLikedTweets extends TweetsEvent {
  final String userId;
  GetLikedTweets(this.userId);
}

class GetTweetsDetail extends TweetsEvent {
  final Tweet tweet;

  GetTweetsDetail(this.tweet);
}

class DeleteTweet extends TweetsEvent {
  final Tweet tweet;

  DeleteTweet(this.tweet);
}