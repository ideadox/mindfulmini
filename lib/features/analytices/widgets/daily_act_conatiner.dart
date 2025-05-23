import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class DailyActConatiner extends StatelessWidget {
  const DailyActConatiner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,

          colors: [
            HexColor('#CFC0FF').withValues(alpha: 0.5),
            HexColor('#E8F0FE').withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),

        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(Assets.vectors.dailyAct2.path),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(Assets.vectors.dailyAct1.path),
            ),

            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Activities',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '1 of 3 Activities Completed',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        width: 69,
                        height: 69,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 65,
                              height: 65,
                              child: CircularProgressIndicator(
                                strokeWidth: 6,
                                backgroundColor: Colors.white60,
                                value: 0.15,
                              ),
                            ),
                            Text(
                              '10%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Space.w12,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
