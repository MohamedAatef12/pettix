import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:pettix/config/env/env.dart';
@lazySingleton class TwilioService {
  final String accountSid = Env.twilioAccountSid;
  final String authToken = Env.twilioAuthToken;
  final String serviceSid = Env.twilioServiceSid;
  String get _basicAuth => 'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}';
  /// Send OTP to the given phone number
  Future<bool> sendOtp(String phoneNumber) async {
    final url = Uri.parse(
      'https://verify.twilio.com/v2/Services/$serviceSid/Verifications',
    );

    final response = await http.post(
      url,
      headers: {
        'Authorization': _basicAuth,
        'Content-Type': 'application/x-www-form-urlencoded', // important
      },
      body: {
        'To': phoneNumber,
        'Channel': 'sms', // 👈 required
      },
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('❌ Twilio sendOtp failed: ${response.body}');
      return false;
    }
  }

  Future<bool> verifyOtp(String phoneNumber, String code) async {
  final url = Uri.parse( 'https://verify.twilio.com/v2/Services/$serviceSid/VerificationCheck', );
  final response = await http.post( url, headers: { 'Authorization': _basicAuth, },
    body: { 'To': phoneNumber, 'Code': code, }, );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body); return data['status'] == 'approved';
  }
  else {
    print('❌ Twilio verifyOtp failed: ${response.body}');
    return false;
  }
}
}