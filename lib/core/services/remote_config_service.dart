import 'dart:convert';
import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import 'app_strings_config.dart';
import 'feature_flags_config.dart';

class RemoteConfigService {
  static const String _featureFlagsAuthKey = 'feature_flags_auth';
  static const String _featureFlagsHomeKey = 'feature_flags_home';
  static const String _stringsAuthKey = 'strings_auth';
  static const String _stringsHomeKey = 'strings_home';
  static const String _stringsRoutineKey = 'strings_routine';
  static const String _stringsJournalKey = 'strings_journal';
  static const String _stringsYogaKey = 'strings_yoga';
  static const String _stringsMeditationKey = 'strings_meditation';
  static const String _stringsBreathingKey = 'strings_breathing';
  static const String _stringsStoriesKey = 'strings_stories';

  final FirebaseRemoteConfig _remoteConfig;

  late Map<String, dynamic> _authStrings;
  late Map<String, dynamic> _homeStrings;
  late Map<String, dynamic> _routineStrings;
  late Map<String, dynamic> _journalStrings;
  late Map<String, dynamic> _yogaStrings;
  late Map<String, dynamic> _meditationStrings;
  late Map<String, dynamic> _breathingStrings;
  late Map<String, dynamic> _storiesStrings;
  late Map<String, dynamic> _authFlags;
  late Map<String, dynamic> _homeFlags;

  RemoteConfigService({FirebaseRemoteConfig? remoteConfig})
    : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    log('RemoteConfig: initialization started');
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval:
            kDebugMode ? Duration.zero : const Duration(minutes: 1),
      ),
    );

    await _remoteConfig.setDefaults({
      _featureFlagsAuthKey: jsonEncode(_defaultAuthFlags),
      _featureFlagsHomeKey: jsonEncode(_defaultHomeFlags),
      _stringsAuthKey: jsonEncode(_defaultAuthStrings),
      _stringsHomeKey: jsonEncode(_defaultHomeStrings),
      _stringsRoutineKey: jsonEncode(_defaultRoutineStrings),
      _stringsJournalKey: jsonEncode(_defaultJournalStrings),
      _stringsYogaKey: jsonEncode(_defaultYogaStrings),
      _stringsMeditationKey: jsonEncode(_defaultMeditationStrings),
      _stringsBreathingKey: jsonEncode(_defaultBreathingStrings),
      _stringsStoriesKey: jsonEncode(_defaultStoriesStrings),
    });
    log('RemoteConfig: defaults set for auth/home flags and strings');

    try {
      final updated = await _remoteConfig.fetchAndActivate();
      log(
        'RemoteConfig: fetchAndActivate completed (updated=$updated, lastFetchStatus=${_remoteConfig.lastFetchStatus.name}, lastFetchTime=${_remoteConfig.lastFetchTime})',
      );
    } catch (e) {
      log('RemoteConfig fetchAndActivate failed. Using defaults. Error: $e');
    }

    _refreshParsedConfigs();
    log(
      'RemoteConfig: loaded authStrings=${_authStrings.length}, homeStrings=${_homeStrings.length}, authFlags=${_authFlags.length}, homeFlags=${_homeFlags.length}',
    );
    _logValueSources();
  }

  AppStringsConfig get strings =>
      AppStringsConfig(
        auth: _authStrings,
        home: _homeStrings,
        routine: _routineStrings,
        journal: _journalStrings,
        yoga: _yogaStrings,
        meditation: _meditationStrings,
        breathing: _breathingStrings,
        stories: _storiesStrings,
      );

  FeatureFlagsConfig get flags =>
      FeatureFlagsConfig(auth: _authFlags, home: _homeFlags);

  void _refreshParsedConfigs() {
    _authStrings = _readJsonMap(_stringsAuthKey, _defaultAuthStrings);
    _homeStrings = _readJsonMap(_stringsHomeKey, _defaultHomeStrings);
    _routineStrings = _readJsonMap(_stringsRoutineKey, _defaultRoutineStrings);
    _journalStrings = _readJsonMap(_stringsJournalKey, _defaultJournalStrings);
    _yogaStrings = _readJsonMap(_stringsYogaKey, _defaultYogaStrings);
    _meditationStrings = _readJsonMap(
      _stringsMeditationKey,
      _defaultMeditationStrings,
    );
    _breathingStrings = _readJsonMap(
      _stringsBreathingKey,
      _defaultBreathingStrings,
    );
    _storiesStrings = _readJsonMap(_stringsStoriesKey, _defaultStoriesStrings);
    _authFlags = _readJsonMap(_featureFlagsAuthKey, _defaultAuthFlags);
    _homeFlags = _readJsonMap(_featureFlagsHomeKey, _defaultHomeFlags);
  }

  Map<String, dynamic> _readJsonMap(
    String key,
    Map<String, dynamic> fallback,
  ) {
    final raw = _remoteConfig.getString(key);
    if (raw.trim().isEmpty) return fallback;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return decoded.cast<String, dynamic>();
      return fallback;
    } catch (e) {
      log('RemoteConfig key "$key" has invalid JSON. Using defaults. Error: $e');
      return fallback;
    }
  }

  void _logValueSources() {
    _logKeySource(_stringsAuthKey);
    _logKeySource(_stringsHomeKey);
    _logKeySource(_stringsRoutineKey);
    _logKeySource(_stringsJournalKey);
    _logKeySource(_stringsYogaKey);
    _logKeySource(_stringsMeditationKey);
    _logKeySource(_stringsBreathingKey);
    _logKeySource(_stringsStoriesKey);
    _logKeySource(_featureFlagsAuthKey);
    _logKeySource(_featureFlagsHomeKey);
  }

  void _logKeySource(String key) {
    final source = _remoteConfig.getValue(key).source;
    final isRemote = source == ValueSource.valueRemote;
    final marker = isRemote ? '✅' : '☑️';
    log('RemoteConfig: $marker $key source=${source.name}');
  }

  static const Map<String, dynamic> _defaultAuthFlags = {
    'enable_social_login': true,
    'enable_google_login': true,
    'enable_apple_login': true,
    'enable_forgot_password': true,
    'enable_phone_login': true,
    'enable_email_login': true,
  };

  static const Map<String, dynamic> _defaultHomeFlags = {
    'show_create_routine_cta': true,
    'show_daily_activity': true,
    'show_yoga_flow': true,
    'show_meditation': true,
    'show_breathing': true,
    'show_body_scan': true,
    'show_stories': true,
  };

  static const Map<String, dynamic> _defaultAuthStrings = {
    'auth_main_title': "Let's get Started!",
    'auth_main_subtitle': 'Enter Mobile Number',
    'auth_main_phone_hint': 'Mobile Number',
    'auth_main_primary_cta': 'Go',
    'auth_main_or_continue_with': 'Or continue with',
    'auth_main_existing_account': 'Already have an account?',
    'auth_main_login_cta': 'Log In',
    'auth_main_terms_prefix': 'By signing up, you agree to our',
    'auth_main_terms_text': 'Terms & Conditions',
    'auth_main_and_text': ' and ',
    'auth_main_privacy_text': 'Privacy Policy.',
    'login_title': "Let's Log In",
    'login_subtitle': 'Welcome Back,You have been missed.',
    'login_email_hint': 'Email Address',
    'login_password_hint': 'Enter Password',
    'login_forgot_password': 'Forgot Password',
    'login_primary_cta': 'Go',
    'login_register_prefix': "Don't have any account?",
    'login_register_cta': 'Register Now',
    'create_account_title': 'Create an account',
    'create_account_name_hint': 'Enter Full Name',
    'create_account_email_hint': 'Email Address',
    'create_account_password_hint': 'Create Password',
    'create_account_primary_cta': 'Create',
    'create_account_login_prefix': 'Already have any account?',
    'create_account_login_cta': 'Log In',
  };

  static const Map<String, dynamic> _defaultHomeStrings = {
    'create_routine': {'cta': 'Create Routine'},
    'daily_activity': {
      'title': 'Daily Activities',
      'subtitle': 'Pick a card to begin your mindfulness adventure!',
    },
    'yoga_flow': {
      'title': 'Yoga Flow',
      'subtitle': 'Quick Yoga sequence for kids to slow down',
      'empty_title': 'No items found',
      'empty_subtitle': 'The list is currently empty.',
    },
    'breathing': {
      'title': 'Breathing',
      'subtitle': 'Simple breathing meditations to relax young minds.',
      'empty_title': 'No items found',
      'empty_subtitle': 'The list is currently empty.',
    },
    'meditation': {
      'title': 'Meditation',
      'subtitle': 'Gentle meditations to help kids relax and feel at ease',
      'empty_title': 'No items found',
      'empty_subtitle': 'The list is currently empty.',
    },
    'stories': {
      'title': 'Short Stories',
      'subtitle': 'Calming stories to help kids unwind and relax.',
      'empty_title': 'No items found',
      'empty_subtitle': 'The list is currently empty.',
    },
    'body_scan': {
      'title': 'Mini Body Scan',
      'subtitle': 'Guided body scans to help kids relax and feel calm.',
    },
    'my_routine': {'start_cta': 'Start', 'get_started_cta': 'Get Started'},
    'add_feeling': {
      'title': 'How is Your Child\nFeeling Now?',
      'cta': 'Add Feeling',
    },
    'feedback': {
      'title': 'Rate your experience!',
      'prefix': 'Give us ',
      'five_stars': '5 stars ',
      'suffix': 'if you like',
      'improve_prompt': 'What can we improve?',
      'input_hint': 'Tell us in words..',
      'playstore_prompt': 'Would you like to rate us on Playstore?',
      'rate_playstore_cta': 'Rate on Playstore',
      'submit_cta': 'Submit',
      'rating_1_label': 'Very Bad!',
      'rating_2_label': 'Very Bad!',
      'rating_3_label': 'Average!',
      'rating_4_label': 'Good!',
      'rating_5_label': 'Love It!',
    },
    'common': {'default_duration': '30 sec'},
  };

  static const Map<String, dynamic> _defaultRoutineStrings = {
    'decider': {'load_error_title': 'Failed to load routines', 'retry_cta': 'Retry'},
    'my_routine_brief': {
      'fallback_title': 'Routine',
      'days_suffix': '-Days',
      'tasks_label': 'Tasks',
      'minutes_label': 'Min',
      'day_prefix': 'Day',
      'cta_get_started': 'Get Started',
    },
  };

  static const Map<String, dynamic> _defaultJournalStrings = {
    'create': {
      'date_label': 'Thu, Feb 6',
      'feeling_prompt': 'How are you feeling today?',
      'feeling_amazing': 'Amazing',
      'feeling_happy': 'Happy',
      'feeling_confused': 'Confused',
      'feeling_sad': 'Sad',
      'feeling_upset': 'Upset',
      'grateful_prompt': 'Today I am grateful for?',
      'grateful_hint': 'Playing with my best friend...',
      'accomplish_prompt': "Things I'll accomplish today",
      'accomplish_hint': 'I will finish my coloring or drawing.',
      'done_cta': 'Done',
    },
    'detail': {
      'title': 'Journal Details',
      'words_suffix': 'Words',
      'feeling_today_prefix': 'Feeling',
      'feeling_today_suffix': 'Today! 😊',
    },
  };

  static const Map<String, dynamic> _defaultYogaStrings = {
    'list': {'fallback_title': 'Spring Yoga', 'cta_lets_go': "Let's Go"},
    'featured_collection': {'title': 'Featured Flow', 'poses_suffix': '6 Poses'},
    'picks': {'title': 'Yoga Picks Just for You', 'poses_suffix': '6 Poses'},
    'recent': {
      'title': 'Recently Watched',
      'time_left_label': '5 min left',
      'resume_cta': 'Resume',
      'poses_suffix': '6 Poses',
    },
  };

  static const Map<String, dynamic> _defaultMeditationStrings = {
    'screen': {
      'title': 'Meditation',
      'subtitle': 'A gentle pause for peace, smiles, and self-love.',
    },
    'suggestion': {
      'title': 'Suggested For You',
      'subtitle': 'Short meditations to help kids slow down and feel calm',
    },
    'category': {
      'title': 'Category',
      'subtitle': 'Mindful moments throughout the day for kids to reset and recharge',
      'tab_morning': 'Morning',
      'tab_afternoon': 'Afternoon',
      'tab_evening': 'Evening',
    },
  };

  static const Map<String, dynamic> _defaultBreathingStrings = {
    'screen': {
      'title': 'Breathing Exercise',
      'subtitle': 'Blow away worries with each mindful breath.',
    },
    'suggestion': {
      'title': 'Suggested For You',
      'subtitle': 'Short breathing exercises to help kids slow down and feel peaceful',
      'empty_label': 'No breathing exercises available',
    },
    'category': {
      'title': 'Category',
      'subtitle': 'Breathing routines to support kids throughout the day',
      'tab_morning': 'Morning',
      'tab_afternoon': 'Afternoon',
      'tab_evening': 'Evening',
      'empty_label': 'No breathing exercises available',
    },
  };

  static const Map<String, dynamic> _defaultStoriesStrings = {
    'screen': {
      'title': 'Stories',
      'subtitle': 'Spark imagination, curiosity, and emotional learning through tales.',
    },
    'suggestion': {
      'title': 'Suggested For You',
      'subtitle': 'Short mindful stories to calm and inspire kids',
    },
    'category': {
      'title': 'Story Collections',
      'subtitle': 'A handpicked set of calming, thoughtful tales',
    },
  };
}
