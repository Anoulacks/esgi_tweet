part of 'users_bloc.dart';

@immutable
abstract class UsersEvent {}

class GetUser extends UsersEvent {
  GetUser();
}

class GetUsers extends UsersEvent {
  GetUsers();
}

class UpdateUser extends UsersEvent {
  final UserApp userEvent;

  UpdateUser(this.userEvent);
}
