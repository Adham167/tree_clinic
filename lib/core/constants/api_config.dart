class ApiConfig {
  ApiConfig._();

  static const modelApiBaseUrl = String.fromEnvironment(
    'TREE_CLINIC_API_BASE_URL',
    defaultValue: 'http://192.168.1.8:5000',
  );
}
