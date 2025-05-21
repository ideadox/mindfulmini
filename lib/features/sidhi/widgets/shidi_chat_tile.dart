import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/features/sidhi/models/chat_message.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class ShidiChatTile extends StatelessWidget {
  final ChatMessage message;
  const ShidiChatTile({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    bool sendByMe = message.sender != 'bot';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!sendByMe)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage(Assets.icons.shidiIcon.path),
                radius: 16,
              ),
            ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: sendByMe ? HexColor('#F0E6FF') : HexColor('#F8F8F8'),
                borderRadius: sendByMe
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
              ),
              child: Text(
                message.message,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
