import 'package:flutter/material.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

import 'library_empty_data.dart';

class RecentWatched extends StatelessWidget {
  const RecentWatched({super.key});

  @override
  Widget build(BuildContext context) {
    return RecentWatchedEmpty();
  }
}

class RecentWatchedData extends StatelessWidget {
  const RecentWatchedData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: []);
  }
}

class RecentWatchedEmpty extends StatelessWidget {
  const RecentWatchedEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return LibraryEmptyData(
      icon: Assets.images.recentlyWatched.path,
      title: "You haven't viewed any tracks\nrecently",
      subtitle: 'Explore and play tracks to see them here',
    );
  }
}
