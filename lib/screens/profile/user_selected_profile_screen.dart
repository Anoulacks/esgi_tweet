import 'package:esgi_tweet/blocs/users_bloc/users_bloc.dart';
import 'package:esgi_tweet/repositorys/users_repository.dart';
import 'package:esgi_tweet/screens/profile/users_list_screen.dart';
import 'package:esgi_tweet/screens/profile/widgets/subscribe_button.dart';
import 'package:esgi_tweet/screens/profile/widgets/user_liked_tweets_list.dart';
import 'package:esgi_tweet/screens/profile/widgets/user_tweets_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';
import '../../utils/shared_preferences.dart';

class UserSelectedProfilePage extends StatefulWidget {
  static const String routeName = '/UserSelectedProfile';

  static void navigateTo(BuildContext context, UserApp user) {
    Navigator.of(context).pushNamed(routeName, arguments: user);
  }

  final UserApp user;

  const UserSelectedProfilePage({super.key, required this.user});

  @override
  State<StatefulWidget> createState() => _UserSelectedProfilePageState();
}

class _UserSelectedProfilePageState extends State<UserSelectedProfilePage> with SingleTickerProviderStateMixin {

  TabController? _tabController;
  int counterFollowers = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    counterFollowers = widget.user.followers?.length ?? 0;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkModeEnabled = UserSharedPreferences.isDarkModeEnabled();

    final userApp = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: BlocBuilder<UsersBloc, UsersState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: isDarkModeEnabled ? Colors.black12 : Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: userApp.photoURL != null
                                  ? Image.network(
                                userApp.photoURL!,
                                fit: BoxFit.cover,
                              ).image
                                  : Image.asset(
                                'assets/images/pp_twitter.jpeg',
                                fit: BoxFit.cover,
                              ).image,
                              child: GestureDetector(
                                onTap: () {
                                  _showUserPictureDialog(userApp);
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
                              userApp.firstname ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '@${userApp.pseudo ?? ''}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SubscribeButton(callback: (value) {
                          _subscribeToUser(context, value);
                        }, userId: widget.user.id,)
                      ],
                    ),
                  ),
                  Container(
                    color: isDarkModeEnabled ? Colors.black12 : Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showUserList(userApp.followings, "Abonnement");
                          },
                          child: Text(
                            '${userApp.followings?.length.toString() ?? ''} Abonnement',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            _showUserList(userApp.followers, "Abonnés");
                          },
                          child: Text(
                            '$counterFollowers Abonnés',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          indicatorColor: Colors.blue,
                          labelColor: isDarkModeEnabled ? Colors.white : Colors.black,
                          tabs: const [
                            Tab(text: 'Tweets'),
                            Tab(text: 'Likes'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              UserTweetsList(userId: userApp.id ?? ''),
                              UserLikedTweetsList(userId: userApp.id ?? '')
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
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
        builder: (context) => UsersListScreen(screenTitle: title, userIds: userIds!),
      ),
    );
  }

  void _subscribeToUser(context, checkFollowing) {
    setState(() {
      if (checkFollowing) {
        counterFollowers += 1;
      } else {
        counterFollowers -= 1;
      }
    });

    final userState = BlocProvider.of<UsersBloc>(context).state.user?.id;
    RepositoryProvider.of<UsersRepository>(context).updateUserFollowers(widget.user.id, userState!);
    RepositoryProvider.of<UsersRepository>(context).updateUserFollowings(userState, widget.user.id!).then((value) {
      if (value == true) {
        BlocProvider.of<UsersBloc>(context).add(GetUser());
      }
    });
  }

}
