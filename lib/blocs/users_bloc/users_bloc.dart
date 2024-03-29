import 'package:bloc/bloc.dart';
import 'package:esgi_tweet/models/user.dart';
import 'package:esgi_tweet/repositorys/users_repository.dart';
import 'package:meta/meta.dart';

part 'users_event.dart';

part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersRepository repository;

  UsersBloc({required this.repository}) : super(const UsersState()) {
    on<GetUser>((event, emit) async {
      emit(state.copyWith(status: UsersStatus.loading));
      try {
        final userId = repository.getCurrentUserID();
        final userData = await repository.getUserById(userId);
        emit(state.copyWith(status: UsersStatus.success, user: userData));
      } catch (error) {
        emit(
            state.copyWith(status: UsersStatus.error, error: error.toString()));
        throw Exception(error);
      }
    });

    on<GetUsers>((event, emit) async {
      emit(state.copyWith(status: UsersStatus.loading));
      try {
        final usersData = await repository.getUsers();
        emit(state.copyWith(status: UsersStatus.success, users: usersData));
      } catch (error) {
        emit(
            state.copyWith(status: UsersStatus.error, error: error.toString()));
        throw Exception(error);
      }
    });

    on<UpdateUser>((event, emit) async {
      emit(state.copyWith(status: UsersStatus.loading));
      try {
        repository.updateUser(event.userEvent);
        emit(
            state.copyWith(status: UsersStatus.success, user: event.userEvent));
      } catch (error) {
        emit(
            state.copyWith(status: UsersStatus.error, error: error.toString()));
        throw Exception(error);
      }
    });
  }
}
