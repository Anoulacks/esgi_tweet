import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:esgi_tweet/models/tweet.dart';
import 'package:esgi_tweet/repositorys/tweets_repository.dart';
import 'package:esgi_tweet/repositorys/users_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'tweets_event.dart';
part 'tweets_state.dart';

class TweetsBloc extends Bloc<TweetsEvent, TweetsState> {
  final TweetsRepository repository;
  final UsersRepository repositoryUsers;

  TweetsBloc({required this.repository, required this.repositoryUsers}) : super(const TweetsState()) {
    on<GetAllTweets>((event, emit) async {
      emit(state.copyWith(status: TweetsStatus.loading));
      try {
        final tweetsData = await repository.getTweets();
        emit(state.copyWith(status: TweetsStatus.success, tweets: tweetsData));
      } catch (error) {
        emit(state.copyWith(
            status: TweetsStatus.error, error: error.toString()));
        throw Exception(error);
      }
    });

    on<GetTweetsDetail>((event, emit) async {
      emit(state.copyWith(status: TweetsStatus.loading));
      try {
        final tweetsData = await repository.getTweetsDetail(event.tweet);
        tweetsData.insert(0, event.tweet);
        emit(state.copyWith(status: TweetsStatus.success, tweetsDetail: tweetsData));
      } catch (error) {
        emit(state.copyWith(
            status: TweetsStatus.error, error: error.toString()));
        throw Exception(error);
      }
    });

    on<GetTweetsByUser>((event, emit) async {
      emit(state.copyWith(status: TweetsStatus.loading));
      try {
        final tweetsData = await repository.getTweetsByUser(event.userId);
        if (repositoryUsers.getCurrentUserID() == event.userId) {
          emit(state.copyWith(status: TweetsStatus.success, tweetsProfile: tweetsData));
        } else {
          emit(state.copyWith(status: TweetsStatus.success, tweetsProfileSelected: tweetsData));
        }
      } catch (error) {
        emit(state.copyWith(
            status: TweetsStatus.error, error: error.toString()));
        throw Exception(error);
      }
    });

    on<GetLikedTweets>((event, emit) async {
      emit(state.copyWith(status: TweetsStatus.loading));
      try {
        final tweetsData = await repository.getLikedTweet(event.userId);
        emit(state.copyWith(status: TweetsStatus.success, tweetsProfile: tweetsData));
      } catch (error) {
        emit(state.copyWith(
            status: TweetsStatus.error, error: error.toString()));
        throw Exception(error);
      }
    });
  }
}
