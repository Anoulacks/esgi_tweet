import 'package:flutter/material.dart';

class SubscribeButton extends StatefulWidget {
  final Function() callback;

  const SubscribeButton({Key? key, required this.callback}) : super(key: key);

  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {

  bool checkFollowing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        checkFollowing = !checkFollowing;
        widget.callback();
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text('Modifier mon profil'),
    );
  }
}
