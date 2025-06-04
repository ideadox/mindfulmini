import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class ReferalInfo extends StatelessWidget {
  const ReferalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> _items = [
      'Download Mindful Minis using your unique referral link',
      'Sign in and purchase a subscription',
    ];
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade100,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'What invited friends need to do',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          ListView.builder(
            itemCount: _items.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: ValueBuild(value: (index + 1).toString()),
                title: Text(
                  _items[index],
                  style: GoogleFonts.nunito(color: Colors.black87),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ValueBuild extends StatelessWidget {
  final String value;
  const ValueBuild({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: HexColor('#9D88DF'), width: 3),
      ),
      child: Text(
        value,
        style: GoogleFonts.nunito(
          color: HexColor('#9D88DF'),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
