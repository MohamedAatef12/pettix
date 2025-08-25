import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInHelper {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
      serverClientId: "774297250092-fn7ffva50ev5onfcbvhprkcgn3of01ct.apps.googleusercontent.com"
  );

  Future<String?> signInAndGetToken() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    return googleAuth.idToken; // <-- send this to your backend
  }
}
