class FeatureFlagsConfig {
  final Map<String, dynamic> _auth;
  final Map<String, dynamic> _home;

  const FeatureFlagsConfig({
    required Map<String, dynamic> auth,
    required Map<String, dynamic> home,
  }) : _auth = auth,
       _home = home;

  bool auth(String key, {bool fallback = false}) {
    final value = _auth[key];
    if (value is bool) return value;
    return fallback;
  }

  bool home(String key, {bool fallback = false}) {
    final value = _home[key];
    if (value is bool) return value;
    return fallback;
  }
}
