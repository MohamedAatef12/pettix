import 'dart:math';
import 'package:injectable/injectable.dart';

@lazySingleton
class EmailAuthService {
  // Local in-memory store for OTPs
  final Map<String, String> _otpStore = {};

  /// Sends a random OTP (4 digits by default)
  Future<bool> sendOtp(String email, {int otpLength = 4}) async {
    try {
      final otp = List.generate(otpLength, (_) => Random().nextInt(10)).join();
      _otpStore[email] = otp;

      print("📩 Temporary OTP for $email: $otp");

      // Simulate success as if the OTP was emailed
      return true;
    } catch (e) {
      print("❌ Error generating OTP: $e");
      return false;
    }
  }

  /// Verifies the OTP locally
  Future<bool> verifyOtp(String email, String otp) async {
    try {
      final stored = _otpStore[email];
      if (stored == null) return false;

      final isValid = stored == otp;
      if (isValid) _otpStore.remove(email); // invalidate after success

      print("✅ OTP check for $email: $isValid");
      return isValid;
    } catch (e) {
      print("❌ Error verifying OTP: $e");
      return false;
    }
  }
}
