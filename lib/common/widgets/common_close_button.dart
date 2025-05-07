import 'package:flutter/material.dart';

class CommonCloseButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const CommonCloseButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      style: IconButton.styleFrom(
        minimumSize: Size(50, 50),
        maximumSize: Size(50, 50),

        backgroundColor: Colors.white,
        shape: CircleBorder(),
        side: BorderSide(color: Colors.grey),
      ),
      // color: Colors.grey,
      onPressed: onPressed,
      icon: Icon(Icons.close),
    );
  }
}
