import 'package:flutter/material.dart';

class CloseButtonDailog extends StatelessWidget {
  const CloseButtonDailog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white,

              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  spreadRadius: 6,
                  blurRadius: 5,
                  offset: const Offset(1, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
