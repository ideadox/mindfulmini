import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:mindfulminis/common/widgets/custom_back_button.dart';

import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/profile/providers/profile_provider.dart';
import 'package:mindfulminis/features/profile/widgets/change_image.dart';
import 'package:mindfulminis/features/profile/widgets/change_your_name.dart';
import 'package:mindfulminis/features/profile/widgets/delete_account.dart';
import 'package:mindfulminis/features/profile/widgets/profile_info_row_widget.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  static String routeName = 'edit-profile';
  static String routePath = '/edit-profile';

  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        centerTitle: true,
        title: Text('Profile'),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          height: 72,
                          width: 72,
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                Assets.profileIcons.gardintCircularPng.path,
                              ),
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: const Color.fromARGB(
                              255,
                              250,
                              248,
                              254,
                            ),
                            backgroundImage:
                                provider.userProfile.profileImage != null
                                    ? NetworkImage(
                                      provider.userProfile.profileImage!,
                                    )
                                    : AssetImage(
                                      Assets.profileIcons.noProfilePng.path,
                                    ),
                          ),
                        ),
                        Positioned(
                          bottom: 6,
                          right: 6,
                          child: InkWell(
                            onTap: () async {
                              final res = await showModalBottomSheet(
                                showDragHandle: true,
                                context: context,
                                builder: (context) {
                                  return ChangeImage(
                                    userId: provider.userProfile.id,
                                    hasAlreadyProfile:
                                        provider.userProfile.profileImage !=
                                        null,
                                  );
                                },
                              );
                              if (res == true) {
                                provider.getUser();
                              }
                            },
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              Assets.profileIcons.editButton.path,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Space.h40,

                  ProfileInfoRowWidget(
                    title: 'Name',
                    value: provider.userProfile.fullname,
                    trailing: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          showDragHandle: true,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return ChangeYourName(
                              name: provider.userProfile.fullname,
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.edit_outlined),
                    ),
                  ),

                  Space.h12,
                  Divider(thickness: 1, color: Colors.blueGrey.shade50),

                  Space.h20,

                  ProfileInfoRowWidget(
                    title: 'Email',
                    value: provider.currentUser?.email ?? "",
                  ),

                  Space.h20,

                  Divider(thickness: 1, color: Colors.blueGrey.shade50),
                  Space.h20,

                  ProfileInfoRowWidget(title: 'Phone Number', value: ''),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              // showDragHandle: true,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                return DeleteAccount();
              },
            );
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: HexColor('#FEE5E6'),
            foregroundColor: HexColor('#FD6050'),
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          child: Text('Delete Account'),
        ),
      ),
    );
  }
}
