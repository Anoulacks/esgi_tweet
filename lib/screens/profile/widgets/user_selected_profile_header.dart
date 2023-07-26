import 'package:esgi_tweet/blocs/users_bloc/users_bloc.dart';
import 'package:esgi_tweet/models/user.dart';
import 'package:esgi_tweet/repositorys/users_repository.dart';
import 'package:esgi_tweet/screens/profile/users_list_screen.dart';
import 'package:esgi_tweet/screens/profile/widgets/subscribe_button.dart';
import 'package:esgi_tweet/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserSelectedProfilePageHeader extends StatefulWidget {
  final UserApp userApp;

  const UserSelectedProfilePageHeader({Key? key, required this.userApp})
      : super(key: key);

  @override
  State<UserSelectedProfilePageHeader> createState() =>
      _UserSelectedProfilePageHeaderState();
}

class _UserSelectedProfilePageHeaderState
    extends State<UserSelectedProfilePageHeader> {
  int counterFollowers = 0;

  @override
  void initState() {
    super.initState();
    counterFollowers = widget.userApp.followers?.length ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkModeEnabled = UserSharedPreferences.isDarkModeEnabled();

    return Column(
      children: [
        Container(
          color: isDarkModeEnabled ? Colors.black12 : Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: widget.userApp.photoURL != null
                        ? Image.network(
                            widget.userApp.photoURL!,
                            fit: BoxFit.cover,
                          ).image
                        : Image.asset(
                            'assets/images/pp_twitter.jpeg',
                            fit: BoxFit.cover,
                          ).image,
                    child: GestureDetector(
                      onTap: () {
                        _showUserPictureDialog(widget.userApp);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userApp.firstname ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '@${widget.userApp.pseudo ?? ''}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SubscribeButton(
                callback: (value) {
                  _subscribeToUser(context, value);
                },
                userId: widget.userApp.id,
              )
            ],
          ),
        ),
        Container(
          color: isDarkModeEnabled ? Colors.black12 : Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  _showUserList(widget.userApp.followings, "Abonnement(s)");
                },
                child: Text(
                  '${widget.userApp.followings?.length.toString() ?? ''} Abonnement(s)',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  _showUserList(widget.userApp.followers, "Abonné(s)");
                },
                child: Text(
                  '$counterFollowers Abonné(s)',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showUserPictureDialog(UserApp userApp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: 300,
            height: 300,
            child: userApp.photoURL != null
                ? Image.network(
                    userApp.photoURL!,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/pp_twitter.jpeg',
                    fit: BoxFit.cover,
                  ),
          ),
        );
      },
    );
  }

  void _showUserList(List<dynamic>? userIds, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UsersListScreen(screenTitle: title, userIds: userIds!),
      ),
    );
  }

  void _subscribeToUser(context, checkFollowing) async {
    setState(() {
      if (checkFollowing) {
        counterFollowers += 1;
      } else {
        counterFollowers -= 1;
      }
    });

    final userState = BlocProvider.of<UsersBloc>(context).state.user?.id;
    await RepositoryProvider.of<UsersRepository>(context)
        .updateUserFollowers(widget.userApp.id, userState!);
    await RepositoryProvider.of<UsersRepository>(context)
        .updateUserFollowings(userState, widget.userApp.id!)
        .then((value) {
      if (value == true) {
        BlocProvider.of<UsersBloc>(context).add(GetUser());
      }
    });
  }
}
