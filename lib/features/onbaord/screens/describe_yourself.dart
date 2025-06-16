import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindfulminis/common/providers/speech_provider.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/gradient_scaffold.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/onbaord/providers/onboards_provider.dart';
import 'package:mindfulminis/common/widgets/listening_widget.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/common_close_button.dart';

class DescribeYourself extends StatefulWidget {
  static String routeName = 'describe-yourself';
  static String routePath = '/describe-yourself';
  const DescribeYourself({super.key});

  @override
  State<DescribeYourself> createState() => _DescribeYourselfState();
}

class _DescribeYourselfState extends State<DescribeYourself> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> describeFormKey = GlobalKey();
    return ChangeNotifierProvider(
      lazy: false,
      create: (context) => SpeechProvider()..initSpeech(),
      child: Consumer2<OnboardsProvider, SpeechProvider>(
        builder: (context, provider, speechProvider, _) {
          return GradientScaffold(
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [CommonCloseButton(onPressed: () {})],
                  ),
                  Text(
                    'Can you describe how your child feeling right now',
                    style: AppTextTheme.titleTextTheme(context).titleLarge,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Freely write down anything that's on your mind",
                    style: AppTextTheme.titleTextTheme(context).bodyMedium,
                  ),
                  SizedBox(height: 20),
                  Stack(
                    children: [
                      Form(
                        key: describeFormKey,
                        child: TextFormField(
                          controller: speechProvider.textController,
                          minLines: 8,

                          maxLines: 8,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText:
                                speechProvider.isListening
                                    ? "Listening..."
                                    : 'Enter here...',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                            ),
                            contentPadding: EdgeInsets.all(16),
                          ),
                          onSaved: (newValue) {
                            provider.onDescribeSave(newValue ?? "");
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child:
                            speechProvider.isListening
                                ? InkWell(
                                  onTap: () {
                                    speechProvider.toggleListening();
                                  },
                                  child: ListeningWidget(),
                                )
                                : IconButton.outlined(
                                  style: IconButton.styleFrom(
                                    side: BorderSide(color: AppColors.grey45),
                                  ),
                                  icon: SvgPicture.asset(Assets.icons.mic),
                                  onPressed: () {
                                    speechProvider.toggleListening();
                                  },
                                ),
                      ),
                    ],
                  ),

                  // if (speechProvider.error != null)
                  //   Text(
                  //     speechProvider.error!,
                  //     style: TextStyle(color: Colors.red),
                  //   ),
                  Spacer(),

                  GradientButton(
                    onPressed: () {
                      if (describeFormKey.currentState!.validate()) {
                        describeFormKey.currentState!.save();
                      }
                    },
                    child: Center(
                      child: Text(
                        'Continue',

                        style:
                            AppTextTheme.mainButtonTextStyle(
                              context,
                            ).titleLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
