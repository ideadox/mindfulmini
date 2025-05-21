import 'package:flutter/material.dart';

class CommonCloseButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? borderColor;
  const CommonCloseButton(
      {super.key, this.onPressed, this.borderColor = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      style: IconButton.styleFrom(
        minimumSize: Size(50, 50),
        maximumSize: Size(50, 50),
        backgroundColor: Colors.white,
        shape: CircleBorder(),
        side: BorderSide(color: borderColor!),
      ),
      // color: Colors.grey,
      onPressed: onPressed,
      icon: Icon(Icons.close),
    );
  }
}
