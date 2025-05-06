import 'package:flutter/material.dart';

class CommonCloseButton extends StatelessWidget {
  const CommonCloseButton({super.key});

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
      onPressed: () {},
      icon: Icon(Icons.close),
    );
  }
}
