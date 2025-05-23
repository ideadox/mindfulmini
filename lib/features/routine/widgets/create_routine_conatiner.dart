import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/gradient_radio_button.dart';

class CreateRoutineConatiner extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String radioValue;
  final String groupValue;
  final void Function(String) onChanged;

  const CreateRoutineConatiner({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onChanged,
    required this.radioValue,
    required this.groupValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),

        gradient: LinearGradient(
          colors: [
            HexColor('#6E40F9').withOpacity(0.3),
            HexColor('#A569FB').withOpacity(0.2),
            HexColor('#CE89FF').withOpacity(0.1),
          ],
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        margin: radioValue == groupValue ? EdgeInsets.all(1) : null,
        decoration: BoxDecoration(
          color: radioValue == groupValue ? HexColor('#E8F0FE') : Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: Opacity(
            opacity: radioValue == groupValue ? 1 : 0.5,
            child: SvgPicture.asset(icon),
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(subtitle, style: TextStyle(color: Colors.black45)),
          trailing: GradientRadioButton(
            value: radioValue,
            groupValue: groupValue,
            onChanged: (val) {
              onChanged(val);
            },
          ),
        ),
      ),
    );
  }
}
