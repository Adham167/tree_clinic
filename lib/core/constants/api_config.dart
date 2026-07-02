class ApiConfig {
  ApiConfig._();

  static const modelApiBaseUrl = String.fromEnvironment(
    'TREE_CLINIC_API_BASE_URL',
    defaultValue: 'https://ahmed25cs-treeclinic.hf.space',
  );
}
