import 'package:flutter/widgets.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class OnboardProvider with ChangeNotifier {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  PageController get controller => _pageController;
  int get currentPage => _currentPage;

  OnboardProvider() {
    // _pageController.addListener(() {
    //   _currentPage = _pageController.page?.toInt() ?? 0;
    // });
  }

  void jumpToPage() {
    _currentPage = _currentPage + 1;
    _pageController.jumpToPage(_currentPage);
  }

  void pageChanged(page) {
    _currentPage = page;
  }

  List<Map<String, String>> pageData = [
    {
      'img': Assets.images.onboard1,
      'title': 'Welcome to Mindful Minis',
      'body':
          'A world of calm, positivity, and mindfulness, specially designed for your child',
    },
    {
      'img': Assets.images.onboard2,
      'title': 'Get to Know Sidhi',
      'body':
          'Sidhi will help your child relax, explore mindfulness, and have fun along the way!',
    },
    {
      'img': Assets.images.onboard3,
      'title': 'Why Choose Mindful Minis?',
      'body':
          'Mindful Minis offers fun, interactive audio to teach kids mindfulness and emotional balance.',
    },
  ];
}
