import 'package:esgi_tweet/blocs/users_bloc/users_bloc.dart';
import 'package:esgi_tweet/screens/profile/user_selected_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user.dart';
import '../../repositorys/users_repository.dart';

class UsersListScreen extends StatelessWidget {
  final String screen_title;
  final List<dynamic> userIds;

  const UsersListScreen({required this.userIds, required this.screen_title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screen_title),
      ),
      body: BlocBuilder<UsersBloc, UsersState>(
    builder: (context, state) {
      switch (state.status) {
        case UsersStatus.initial:
          return const SizedBox();
        case UsersStatus.loading:
          return const Center(
            child: CircularProgressIndicator(),
          );
        case UsersStatus.error:
          return Center(
            child: Text(state.error),
          );
        case UsersStatus.success:
          final userList = userIds;

          if (userList.isEmpty) {
            return const Center(
              child: Text('Aucun utilisateur'),
            );
          }

          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              return FutureBuilder<UserApp>(
                future: RepositoryProvider.of<UsersRepository>(context)
                    .getUserById(user),
                builder: (BuildContext context,
                    AsyncSnapshot<UserApp> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Error: ${snapshot.error}');
                  }
                  UserApp userApp = snapshot.data!;
                  if (snapshot.hasData) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserSelectedProfilePage(user: userApp),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(userApp.pseudo),
                      ),
                    );
                  }
                  return Text('Error: pas de données');
                },
              );
            },
          );
      }
    },
      ),
    );
  }
}
