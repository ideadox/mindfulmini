// import 'dart:async';

// import 'package:flutter/material.dart';

// import '../../../common/models/story_segment.dart';

// class PlayText extends StatelessWidget {
//   static String routeName = 'play-text';
//   static String routePath = '/play-text';
//   PlayText({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final storySegments = parseLexicalJson(cmsJson);
//     return Scaffold(
//       appBar: AppBar(),
//       body: AnimatedStoryText(segments: storySegments),
//     );
//   }

//   final cmsJson = {
//     "root": {
//       "children": [
//         {
//           "children": [],
//           "direction": null,
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text": "Once upon a time... <break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "in the grand and bustling kingdom of Vijayanagara... <break time=\"1.8s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "there lived a witty and clever man named Tenali Raman. <break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "His mind was quick, his humor sharp, and his heart full of kindness. <break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text": "<break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text": "On a certain occasion... <break time=\"1.5s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "Queen Lakshmi Devi had a peculiar dream that left her thoughtful. <break time=\"1.8s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "In her dream, she saw a majestic elephant, adorned with golden ornaments, <break time=\"1.8s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text": "and led by a wise, gentle sage. <break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text": "<break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "The queen shared her dream with her trusted advisors, <break time=\"1.5s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "but no one could understand its meaning. <break time=\"1.8s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "So the king, wise and thoughtful, called upon Tenali Raman to help. <break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text": "<break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "“Wise Raman,” said King Krishnadevaraya, <break time=\"1.5s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "“can you unravel the mystery of the queen’s dream?” <break time=\"1.8s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "Tenali Raman listened carefully, his eyes twinkling with quiet mischief. <break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text": "<break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "With a gentle smile, Tenali Raman said, <break time=\"1.5s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "“I have a solution, Your Majesty. <break time=\"1.5s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "But I shall present it to the queen in the form of a riddle.” <break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text": "<break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "Soon after, Tenali Raman approached the queen. <break time=\"1.5s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "He spoke softly, his words like a gentle breeze. <break time=\"1.8s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text": "“O noble queen,” he said, <break time=\"1.5s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "“in your dream, the elephant was adorned with gold and led by a sage. <break time=\"1.8s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "Tell me, who truly guided this majestic creature?” <break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text": "<break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "The queen pondered the riddle, her brow furrowed in thought. <break time=\"1.5s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "And then, slowly, a smile spread across her face. <break time=\"1.8s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "“The true leader of the elephant,” she said softly, <break time=\"1.5s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "“was the mahout, the one who guided every step.” <break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text": "<break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "Tenali Raman bowed with satisfaction. <break time=\"1.5s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "“Just as the mahout guides the elephant, <break time=\"1.8s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "so too do you guide the kingdom with wisdom and grace, <break time=\"1.5s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "Your Majesty. Your dream reflects your gentle leadership.” <break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text": "<break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "The queen’s eyes shone with gratitude, <break time=\"1.5s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "and she thanked Tenali Raman for bringing her clarity and understanding. <break time=\"1.8s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "From that moment on, Tenali Raman’s cleverness and wisdom were celebrated throughout Vijayanagara. <break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text": "<break time=\"2.5s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text": "And so... <break time=\"1.5s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "Tenali Raman continued to share his cleverness, laughter, and wisdom, <break time=\"1.8s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//             {"type": "linebreak", "version": 1},
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "reminding all that insight and creativity can illuminate even the most puzzling mysteries. <break time=\"2s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [
//             {
//               "detail": 0,
//               "format": 0,
//               "mode": "normal",
//               "style": "",
//               "text":
//                   "May your thoughts be filled with clever riddles, gentle guidance, and the quiet wisdom that brings peace. <break time=\"3s\"/>",
//               "type": "text",
//               "version": 1,
//             },
//           ],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//         {
//           "children": [],
//           "direction": "ltr",
//           "format": "",
//           "indent": 0,
//           "type": "paragraph",
//           "version": 1,
//           "textFormat": 0,
//           "textStyle": "",
//         },
//       ],
//       "direction": "ltr",
//       "format": "",
//       "indent": 0,
//       "type": "root",
//       "version": 1,
//       "textFormat": 1,
//     },
//   };
// }

// class AnimatedStoryText extends StatefulWidget {
//   final List<StorySegment> segments;

//   const AnimatedStoryText({super.key, required this.segments});

//   @override
//   State<AnimatedStoryText> createState() => _AnimatedStoryTextState();
// }

// class _AnimatedStoryTextState extends State<AnimatedStoryText>
//     with TickerProviderStateMixin {
//   final List<String> shownLines = [];
//   int currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     playNext();
//   }

//   void playNext() async {
//     if (currentIndex >= widget.segments.length) return;

//     final seg = widget.segments[currentIndex];

//     if (seg.text.isNotEmpty) {
//       setState(() => shownLines.add(seg.text));
//     }

//     await Future.delayed(seg.delay + const Duration(milliseconds: 800));
//     currentIndex++;
//     playNext();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentLyric = shownLines.last;
//     final currentLyricIndex = shownLines.length - 1;

//     return SizedBox(
//       height: 60,
//       child: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 400),
//         transitionBuilder: (child, animation) {
//           return SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(0, 0.5),
//               end: Offset.zero,
//             ).animate(animation),
//             child: FadeTransition(opacity: animation, child: child),
//           );
//         },
//         child: Text(
//           currentLyric,
//           key: ValueKey(currentLyricIndex),
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//       ),
//     );
//   }
// }
