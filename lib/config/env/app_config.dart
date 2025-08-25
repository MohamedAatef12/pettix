class AppConfig {
  final String envName;
  final String apiBaseUrl;

  const AppConfig({required this.envName, required this.apiBaseUrl});

  static const dev = AppConfig(
    envName: 'Development',
    apiBaseUrl: 'https://dev.api.example.com/',
  );

  static const prod = AppConfig(
    envName: 'Production',
    apiBaseUrl: 'https://api.example.com/',
  );
}
