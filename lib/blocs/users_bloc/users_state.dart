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
  final String error;

  const UsersState({
    this.status = UsersStatus.initial,
    this.user,
    this.error = '',
  });

  UsersState copyWith({
    UsersStatus? status,
    UserApp? user,
    String? error,
  }) {
    return UsersState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }


}

