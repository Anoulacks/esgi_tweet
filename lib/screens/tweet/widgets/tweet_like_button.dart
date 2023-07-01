import 'package:esgi_tweet/repositorys/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/shared_preferences.dart';

class TweetLikeButton extends StatefulWidget {
  final List<dynamic>? likes;
  final Function callback;

  const TweetLikeButton({Key? key, required this.likes, required this.callback}) : super(key: key);

  @override
  State<TweetLikeButton> createState() => _TweetLikeButtonState();
}

class _TweetLikeButtonState extends State<TweetLikeButton> {

  bool isLiked = false;
  int counterLikes = 0;

  @override
  void initState() {
    super.initState();
    bool? initLiked = widget.likes?.contains(RepositoryProvider.of<UsersRepository>(context).getCurrentUserID());
    if (initLiked == true) {
      isLiked = true;
    }
    counterLikes = widget.likes?.length ?? 0;
  }

  void _updateLike() async {
    setState(() {
      isLiked = !isLiked;
      if(isLiked) {
        counterLikes += 1;
      } else {
        counterLikes -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkModeEnabled = UserSharedPreferences.isDarkModeEnabled();

    return Row(
      children: [
        IconButton(
          onPressed: () {
            widget.callback(context);
            _updateLike();
          },
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : null,),
          iconSize: 18,
        ),
        Text(
          '$counterLikes',
          style: TextStyle(
            color: isDarkModeEnabled ? Colors.white : Colors.black,
            fontSize: 12.0,
          ),)
      ],
    );
  }
}
