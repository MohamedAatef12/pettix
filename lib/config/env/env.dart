import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'lib/config/env/.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'BASE_URL')
  static String baseUrl = _Env.baseUrl;

  @EnviedField(varName: 'API_KEY')
  static String apiKey = _Env.apiKey;

  @EnviedField(varName: 'TWILIO_ACCOUNT_SID')
  static String twilioAccountSid = _Env.twilioAccountSid;

  @EnviedField(varName: 'TWILIO_AUTH_TOKEN')
  static String twilioAuthToken = _Env.twilioAuthToken;

  @EnviedField(varName: 'TWILIO_SERVICE_SID')
  static String twilioServiceSid = _Env.twilioServiceSid;
}
