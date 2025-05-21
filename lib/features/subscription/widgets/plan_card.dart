import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/custom_gradient_text.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';

class PlanCard extends StatelessWidget {
  final bool isSelected;
  final String type;
  final String priceText;
  final String? breifText;
  final String? saveCount;
  final Function(String)? onSelect;
  const PlanCard(
      {super.key,
      required this.type,
      required this.priceText,
      this.breifText,
      this.saveCount,
      this.isSelected = false,
      this.onSelect});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: !isSelected ? null : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: !isSelected
                  ? AppColors.secondaryGradient
                  : AppColors.primaryGradient),
          child: Container(
            margin: EdgeInsets.all(isSelected ? 2 : 1),
            padding: EdgeInsets.symmetric(
                vertical: !isSelected ? 10 : 20, horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), color: Colors.white),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (isSelected) ...[
                      Text(
                        '7-Day Free Trail',
                        style: TextStyle(color: HexColor('#8E00FF')),
                      ),
                      Space.h12,
                    ],
                    Text(
                      type,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                )),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (saveCount != null) ...[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                HexColor('#D9A746'),
                                HexColor('#FFDDCD')
                              ]),
                        ),
                        child: Text(
                          saveCount ?? "",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      Space.h8,
                    ],
                    Text(
                      priceText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (breifText != null) ...[
                      Space.h8,
                      CustomGradientText(text: breifText ?? "")
                    ]
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
