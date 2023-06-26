part of 'tweets_bloc.dart';

enum TweetsStatus {
  initial,
  loading,
  success,
  error,
}

@immutable
class TweetsState {
  final TweetsStatus status;
  final List<Tweet> tweets;
  final List<Tweet> tweetsDetail;
  final String error;

  const TweetsState({
    this.status = TweetsStatus.initial,
    this.tweets = const [],
    this.tweetsDetail = const [],
    this.error = '',
  });

  TweetsState copyWith({
    TweetsStatus? status,
    List<Tweet>? tweets,
    List<Tweet>? tweetsDetail,
    String? error,
  }) {
    return TweetsState(
      status: status ?? this.status,
      tweets: tweets ?? this.tweets,
      tweetsDetail: tweetsDetail ?? this.tweetsDetail,
      error: error ?? this.error,
    );
  }


}

