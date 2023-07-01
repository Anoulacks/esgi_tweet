import 'dart:io';
import 'package:esgi_tweet/blocs/users_bloc/users_bloc.dart';
import 'package:esgi_tweet/screens/profile/users_list_screen.dart';
import 'package:esgi_tweet/screens/profile/widgets/user_liked_tweets_list.dart';
import 'package:esgi_tweet/screens/profile/widgets/user_tweets_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/shared_preferences.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  File? avatarImage;
  String? user_pp;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkModeEnabled = UserSharedPreferences.isDarkModeEnabled();

    return Scaffold(
        body: SafeArea(
          child: BlocBuilder<UsersBloc, UsersState>(
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
                              backgroundImage: state.user?.photoURL != null
                                  ? Image.network(
                                      state.user!.photoURL!,
                                      fit: BoxFit.cover,
                                    ).image
                                  : avatarImage == null
                                      ? Image.asset(
                                          'assets/images/pp_twitter.jpeg',
                                          fit: BoxFit.cover,
                                        ).image
                                      : Image.file(
                                          avatarImage!,
                                          fit: BoxFit.cover,
                                        ).image,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    user_pp = state.user?.photoURL;
                                  });
                                  _showUserPictureDialog();
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
                              state.user?.firstname ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '@${state.user?.pseudo ?? ''}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfileScreen()),
                            );
                          },
                          child: const Text('Modifier mon profil'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
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
                              _showUserList(state.user?.followings, "Following");
                            },
                            child: Text(
                              '${state.user?.followings?.length.toString() ?? ''} Following',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              _showUserList(state.user?.followers, "Followers");
                            },
                            child: Text(
                              '${state.user?.followers?.length.toString() ?? ''} Followers',
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
                              UserTweetsList(userId: state.user?.id ?? ''),
                              UserLikedTweetsList(userId: state.user?.id ?? '')
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
        ),
      );
  }

  void _showUserPictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: 300,
            height: 300,
            child: user_pp != null
                ? Image.network(
              user_pp ?? '',
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

}
