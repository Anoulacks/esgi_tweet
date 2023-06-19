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
  final String error;

  const TweetsState({
    this.status = TweetsStatus.initial,
    this.tweets = const [],
    this.error = '',
  });

  TweetsState copyWith({
    TweetsStatus? status,
    List<Tweet>? tweets,
    String? error,
  }) {
    return TweetsState(
      status: status ?? this.status,
      tweets: tweets ?? this.tweets,
      error: error ?? this.error,
    );
  }


}

