import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esgi_tweet/blocs/users_bloc/users_bloc.dart';
import 'package:esgi_tweet/models/user.dart';
import 'package:esgi_tweet/repositorys/tweets_repository.dart';
import 'package:esgi_tweet/screens/profile/widgets/user_liked_tweets_list.dart';
import 'package:esgi_tweet/screens/profile/widgets/user_tweets_list.dart';
import 'package:esgi_tweet/utils/date_utils.dart';
import 'package:esgi_tweet/utils/snackbar_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../blocs/tweets_bloc/tweets_bloc.dart';
import '../../models/tweet.dart';
import '../../repositorys/image_repository.dart';
import '../../repositorys/users_repository.dart';
import '../../widgets/image_picker.dart';
import '../tweet/widgets/tweet_card.dart';
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
    return Scaffold(
        body: SafeArea(
          child: BlocBuilder<UsersBloc, UsersState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.blue,
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
                    color: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${state.user?.followings?.length.toString() ?? ''} Following',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '${state.user?.followings?.length.toString() ?? ''} Followers',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
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
                          labelColor: Colors.black,
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
            child: Image.network(
              user_pp ?? '',
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
