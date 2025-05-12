import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';

class ChangeImage extends StatelessWidget {
  const ChangeImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12, left: 12, right: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Edit picture',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          Space.h32,
          ListTile(
            leading: Icon(Icons.image_outlined),
            title: Text('Choose form library'),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(thickness: 1, color: Colors.blueGrey.shade50),

          ListTile(
            leading: Icon(Icons.photo_camera_outlined),
            title: Text('Take photo'),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(thickness: 1, color: Colors.blueGrey.shade50),

          ListTile(
            leading: Icon(Icons.delete_outline_outlined, color: Colors.red),
            title: Text(
              'Remove current picture',
              style: TextStyle(color: Colors.red),
            ),
          ),

          GradientButton(
            onPressed: () {},
            child: Center(
              child: Text(
                'Save',
                style: AppTextTheme.mainButtonTextStyle(context).titleLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
