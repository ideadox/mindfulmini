import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

class ShidiVoiceScreen extends StatelessWidget {
  const ShidiVoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(Assets.vectors.a.path),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    sl<GoRouter>().pop(false);
                  },
                  style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.black12),
                      maximumSize: Size(47, 47),
                      minimumSize: Size(47, 47)),
                  icon: Icon(Icons.close),
                ),
                IconButton(
                  onPressed: () {
                    sl<GoRouter>().pop(true);
                  },
                  style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.black12),
                      maximumSize: Size(47, 47),
                      minimumSize: Size(47, 47)),
                  icon: Icon(Icons.keyboard_alt_outlined),
                ),
              ],
            ),
            Space.h40,
            Space.h40
          ],
        ),
      ),
    );
  }
}
