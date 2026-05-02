class GoogleAuthConfig {
  static const String _serverClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '',
  );

  static String? get serverClientId {
    final trimmed = _serverClientId.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
