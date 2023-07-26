import 'package:esgi_tweet/blocs/users_bloc/users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscribeButton extends StatefulWidget {
  final Function(bool) callback;
  final String? userId;

  const SubscribeButton(
      {Key? key, required this.callback, required this.userId})
      : super(key: key);

  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {
  bool? checkFollowing;

  @override
  void initState() {
    super.initState();
    checkFollowing = _checkFollowingStatus();
  }

  bool _checkFollowingStatus() {
    final List<dynamic>? followingsArray =
        BlocProvider.of<UsersBloc>(context).state.user?.followings;
    return followingsArray?.contains(widget.userId) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          checkFollowing =
              checkFollowing != null && checkFollowing != false ? false : true;
        });
        widget.callback(checkFollowing!);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        checkFollowing == true ? 'Se désabonner' : 'Suivre',
      ),
    );
  }
}
