import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/profile/providers/edit_image_provider.dart';
import 'package:provider/provider.dart';

class ChangeImage extends StatelessWidget {
  final String userId;
  final bool hasAlreadyProfile;
  const ChangeImage({
    super.key,
    required this.userId,
    required this.hasAlreadyProfile,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EditImageProvider(userId),
      child: Consumer<EditImageProvider>(
        builder: (context, provider, _) {
          if (provider.imageFile != null) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12, left: 12, right: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Edit picture',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  Space.h20,
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(provider.imageFile!),
                  ),
                  Space.h12,
                  InkWell(
                    onTap: () {
                      provider.changeImage();
                    },
                    child: Text(
                      'Change',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                  Space.h20,

                  GradientButton(
                    onPressed: () {
                      provider.uploadImage();
                    },
                    child: Center(
                      child: Text(
                        'Save',
                        style:
                            AppTextTheme.mainButtonTextStyle(
                              context,
                            ).titleLarge,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
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
                  onTap: () {
                    provider.pickImage();
                  },
                  leading: Icon(Icons.image_outlined),
                  title: Text('Choose form library'),
                  trailing: Icon(Icons.chevron_right),
                ),
                Divider(thickness: 1, color: Colors.blueGrey.shade50),

                ListTile(
                  onTap: () {
                    provider.pickImage(type: 'cam');
                  },
                  leading: Icon(Icons.photo_camera_outlined),
                  title: Text('Take photo'),
                  trailing: Icon(Icons.chevron_right),
                ),
                Divider(thickness: 1, color: Colors.blueGrey.shade50),
                if (hasAlreadyProfile)
                  ListTile(
                    onTap: () {
                      provider.removeImage();
                    },
                    leading: Icon(
                      Icons.delete_outline_outlined,
                      color: Colors.red,
                    ),
                    title: Text(
                      'Remove current picture',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
