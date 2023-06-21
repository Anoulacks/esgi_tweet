import 'package:esgi_tweet/screens/profile/profile_screen.dart';
import 'package:esgi_tweet/screens/search/search_screen.dart';
import 'package:esgi_tweet/screens/tweet/tweet_home_screen.dart';
import 'package:flutter/material.dart';

class AreaScreen extends StatefulWidget {
  static const String routeName = '/Area';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  const AreaScreen({super.key});

  @override
  _AreaScreenState createState() => _AreaScreenState();
}

class _AreaScreenState extends State<AreaScreen> {
  int currentIndex = 0;

  List pages = const [
    TweetHomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  void onTap(int index){
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF0B004D),
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Rechercher'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profil')
        ],
      ),
    );
  }
}