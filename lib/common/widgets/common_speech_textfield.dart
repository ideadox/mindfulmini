import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindfulminis/common/providers/speech_provider.dart';
import 'package:mindfulminis/common/widgets/listening_widget.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

class CommonSpeechTextfield extends StatelessWidget {
  final String hintText;
  final int minLines;
  final int maxLines;
  final SpeechProvider speechProvider;

  const CommonSpeechTextfield({
    super.key,
    required this.hintText,
    required this.speechProvider,
    this.minLines = 8,
    this.maxLines = 8,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: speechProvider,
      child: Consumer<SpeechProvider>(
        builder: (context, provider, _) {
          return Stack(
            children: [
              TextFormField(
                controller: provider.textController,
                minLines: minLines,
                maxLines: maxLines,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: provider.isListening ? "Listening..." : hintText,
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter something.';
                  }
                  return null;
                },
                onChanged: (value) {
                  provider.addToHistory(value);
                },
              ),

              Positioned(
                bottom: 10,
                right: 10,
                left: 10,
                child: Row(
                  children: [
                    IconButton.outlined(
                      icon: SvgPicture.asset(Assets.icons.undo),
                      onPressed: () {
                        provider.undo();
                      },
                    ),
                    Space.w12,
                    IconButton.outlined(
                      icon: SvgPicture.asset(Assets.icons.redo),
                      onPressed: () {
                        provider.redo();
                      },
                    ),
                    Spacer(),
                    provider.isListening
                        ? InkWell(
                          onTap: () => provider.toggleListening(),
                          child: ListeningWidget(),
                        )
                        : IconButton.outlined(
                          icon: SvgPicture.asset(Assets.icons.mic),
                          onPressed: () => provider.toggleListening(),
                        ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
