class AppStringsConfig {
  final Map<String, dynamic> _auth;
  final Map<String, dynamic> _home;
  final Map<String, dynamic> _routine;
  final Map<String, dynamic> _journal;
  final Map<String, dynamic> _yoga;
  final Map<String, dynamic> _meditation;
  final Map<String, dynamic> _breathing;
  final Map<String, dynamic> _stories;

  const AppStringsConfig({
    required Map<String, dynamic> auth,
    required Map<String, dynamic> home,
    required Map<String, dynamic> routine,
    required Map<String, dynamic> journal,
    required Map<String, dynamic> yoga,
    required Map<String, dynamic> meditation,
    required Map<String, dynamic> breathing,
    required Map<String, dynamic> stories,
  }) : _auth = auth,
       _home = home,
       _routine = routine,
       _journal = journal,
       _yoga = yoga,
       _meditation = meditation,
       _breathing = breathing,
       _stories = stories;

  String auth(String key, {String fallback = ''}) {
    final value = _readByPath(_auth, key);
    if (value is String && value.trim().isNotEmpty) return value;
    return fallback;
  }

  String home(String key, {String fallback = ''}) {
    final value = _readByPath(_home, key);
    if (value is String && value.trim().isNotEmpty) return value;
    return fallback;
  }

  String routine(String key, {String fallback = ''}) {
    final value = _readByPath(_routine, key);
    if (value is String && value.trim().isNotEmpty) return value;
    return fallback;
  }

  String journal(String key, {String fallback = ''}) {
    final value = _readByPath(_journal, key);
    if (value is String && value.trim().isNotEmpty) return value;
    return fallback;
  }

  String yoga(String key, {String fallback = ''}) {
    final value = _readByPath(_yoga, key);
    if (value is String && value.trim().isNotEmpty) return value;
    return fallback;
  }

  String meditation(String key, {String fallback = ''}) {
    final value = _readByPath(_meditation, key);
    if (value is String && value.trim().isNotEmpty) return value;
    return fallback;
  }

  String breathing(String key, {String fallback = ''}) {
    final value = _readByPath(_breathing, key);
    if (value is String && value.trim().isNotEmpty) return value;
    return fallback;
  }

  String stories(String key, {String fallback = ''}) {
    final value = _readByPath(_stories, key);
    if (value is String && value.trim().isNotEmpty) return value;
    return fallback;
  }

  dynamic _readByPath(Map<String, dynamic> source, String path) {
    if (!path.contains('.')) return source[path];

    dynamic current = source;
    for (final segment in path.split('.')) {
      if (current is Map<String, dynamic>) {
        current = current[segment];
      } else if (current is Map) {
        current = current[segment];
      } else {
        return null;
      }
    }
    return current;
  }
}
