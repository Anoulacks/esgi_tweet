part of 'users_bloc.dart';

enum UsersStatus {
  initial,
  loading,
  success,
  error,
}

@immutable
class UsersState {
  final UsersStatus status;
  final UserApp? user;
  final List<UserApp> users;
  final String error;

  const UsersState({
    this.status = UsersStatus.initial,
    this.user,
    this.error = '',
    this.users = const [],
  });

  UsersState copyWith({
    UsersStatus? status,
    UserApp? user,
    List<UserApp>? users,
    String? error,
  }) {
    return UsersState(
      status: status ?? this.status,
      user: user ?? this.user,
      users: users ?? this.users,
      error: error ?? this.error,
    );
  }
}

