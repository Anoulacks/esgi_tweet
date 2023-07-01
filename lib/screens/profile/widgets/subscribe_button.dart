import 'package:esgi_tweet/blocs/users_bloc/users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscribeButton extends StatefulWidget {
  final Function() callback;

  const SubscribeButton({Key? key, required this.callback}) : super(key: key);

  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic>? followingsArray = BlocProvider
        .of<UsersBloc>(context)
        .state
        .user
        ?.followings;
    bool? checkFollowing = followingsArray?.contains(BlocProvider
        .of<UsersBloc>(context)
        .state
        .user
        ?.id ?? false);
    return ElevatedButton(
      onPressed: () {
        setState(() {
          checkFollowing = checkFollowing != null ? true : false;
        });
        widget.callback();
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child:
      checkFollowing != null && checkFollowing == true ?
      const Text('Se desabonner')
      : const Text("Suivre"),
    );
  }
}
