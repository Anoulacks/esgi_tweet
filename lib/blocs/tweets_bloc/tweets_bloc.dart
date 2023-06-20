import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:esgi_tweet/models/tweet.dart';
import 'package:esgi_tweet/repositorys/tweets_repository.dart';
import 'package:meta/meta.dart';

part 'tweets_event.dart';
part 'tweets_state.dart';

class TweetsBloc extends Bloc<TweetsEvent, TweetsState> {
  final TweetsRepository repository;

  TweetsBloc({required this.repository}) : super(const TweetsState()) {
    on<GetAllTweets>((event, emit) async {
      emit(state.copyWith(status: TweetsStatus.loading));
      await Future.delayed(const Duration(seconds: 1));
      try {
        final tweetsData = await repository.getTweets();

        emit(state.copyWith(status: TweetsStatus.success, tweets: tweetsData));
      } catch (error) {
        emit(
            state.copyWith(status: TweetsStatus.error, error: error.toString()));
        throw Exception(error);
      }
    });
  }
}
