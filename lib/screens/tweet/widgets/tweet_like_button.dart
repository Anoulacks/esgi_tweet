import 'package:esgi_tweet/repositorys/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TweetLikeButton extends StatefulWidget {
  final List<dynamic>? likes;
  final Function callback;

  const TweetLikeButton({Key? key, required this.likes, required this.callback}) : super(key: key);

  @override
  State<TweetLikeButton> createState() => _TweetLikeButtonState();
}

class _TweetLikeButtonState extends State<TweetLikeButton> {

  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    bool? initLiked = widget.likes?.contains(RepositoryProvider.of<UsersRepository>(context).getCurrentUserID());
    if (initLiked == true) {
      isLiked = true;
    }
  }

  void _UpdateLike() async {
    setState(() {
      isLiked = !isLiked;

      if(isLiked) {
        widget.likes?.length += 1;
      } else {
        widget.likes?.length -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            widget.callback(context);
            _UpdateLike();
          },
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : null,),
          iconSize: 18,
        ),
        Text(
          '${widget.likes?.length ?? '0'}',
          style: const TextStyle(
            color: Colors.black38,
            fontSize: 12.0,
          ),)
      ],
    );
  }
}
