import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_formate.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/sidhi/models/chat_message.dart';
import 'package:mindfulminis/features/sidhi/providers/shidi_chat_provider.dart';
import 'package:mindfulminis/features/sidhi/screens/shidi_voice_screen.dart';
import 'package:mindfulminis/features/sidhi/widgets/shidi_chat_tile.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:provider/provider.dart';

class ShidiChatScreen extends StatelessWidget {
  static String routeName = 'shidi-chat-screen';
  static String routePath = '/shidi-chat-screen';

  const ShidiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    voiceNavigation(provider) async {
      return await Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder:
              (context, animation, secondaryAnimation) =>
                  ShidiVoiceScreen(shidiChatProvider: provider),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            return FadeTransition(opacity: curvedAnimation, child: child);
          },
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (context) => ShidiChatProvider(),
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 10,
          leading: IconButton(
            onPressed: () {
              sl<GoRouter>().pop();
            },
            icon: SvgPicture.asset(Assets.icons.arrowBack),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.images.partten.path),
            ),
          ),
          child: Consumer<ShidiChatProvider>(
            builder: (context, provider, _) {
              final Map<DateTime, List<ChatMessage>> groupedMessages = {};

              for (var message in provider.sampleChatMessages) {
                final messageDate = message.timestamp;
                DateTime roundedDate = DateTime(
                  messageDate.year,
                  messageDate.month,
                  messageDate.day,
                );
                // final formattedDate =
                //     "${messageDate.year}-${messageDate.month}-${messageDate.day}";

                if (!groupedMessages.containsKey(roundedDate)) {
                  groupedMessages[roundedDate] = [];
                }
                groupedMessages[roundedDate]?.add(message);
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: groupedMessages.length,
                      itemBuilder: (context, index) {
                        DateTime date = groupedMessages.keys.elementAt(index);
                        List<ChatMessage> messages = groupedMessages[date]!;
                        // messages = messages.reversed.toList();

                        Widget dateWidget = Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Text(
                                AppFormate.formatChatDate(date),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Space.w12,
                              Expanded(
                                child: Divider(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        List<Widget> messageWidgets =
                            messages.map((message) {
                              return ShidiChatTile(message: message);
                            }).toList();

                        return Column(
                          children: [dateWidget, ...messageWidgets],
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: Offset(0, 10),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(37),
                    ),
                    child: TextFormField(
                      focusNode: provider.focusNode,
                      controller: provider.messageController,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: HexColor('#F2F2FC'),
                        hintText: 'Ask Sidhi...',
                        hintStyle: TextStyle(fontStyle: FontStyle.italic),
                        suffixIcon: AnimatedSwitcher(
                          duration: Duration(milliseconds: 100),
                          child:
                              !provider.isEmptyTextField
                                  ? IconButton(
                                    key: UniqueKey(),
                                    onPressed: () {},
                                    icon: Container(
                                      height: 49,
                                      width: 49,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        gradient: AppColors.primaryGradient,
                                      ),
                                      child: Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                  : IconButton(
                                    key: UniqueKey(),
                                    onPressed: () async {
                                      final focus = await voiceNavigation(
                                        provider,
                                      );

                                      if (focus != null) {
                                        if (focus) {
                                          provider.focus();
                                        } else {
                                          provider.unfocus();
                                        }
                                      }
                                    },
                                    icon: SvgPicture.asset(
                                      Assets.icons.shidiVoice,
                                    ),
                                  ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(37),
                          borderSide: BorderSide(color: AppColors.purple),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(37),
                          borderSide: BorderSide(color: AppColors.purple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(37),
                          borderSide: BorderSide(color: AppColors.purple),
                        ),
                      ),
                    ),
                  ),
                  Space.h32,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
