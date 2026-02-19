// import 'dart:async';

// import 'package:flutter/widgets.dart';

// class AudioController with ChangeNotifier {
//   Duration currentPosition = Duration.zero;
//   Timer? _timer;

//   _init() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (currentPosition < widget.totalDuration) {
//         currentPosition += const Duration(seconds: 1);
//       } else {
//         _timer?.cancel();
//       }
//       notifyListeners();
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
// }
