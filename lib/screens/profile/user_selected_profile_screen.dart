import 'package:esgi_tweet/screens/profile/widgets/user_liked_tweets_list.dart';
import 'package:esgi_tweet/screens/profile/widgets/user_selected_profile_header.dart';
import 'package:esgi_tweet/screens/profile/widgets/user_tweets_list.dart';
import 'package:flutter/material.dart';

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

class _UserSelectedProfilePageState extends State<UserSelectedProfilePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

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

    final userApp = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserSelectedProfilePageHeader(userApp: userApp),
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
      ),
    );
  }
}
