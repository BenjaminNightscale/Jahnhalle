import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialLogin {
  static final shared = SocialLogin();
  GoogleSignIn? _googleSignIn;

  Future<GoogleSignInAccount?> googleSignIn() async {
    try {
      _googleSignIn = GoogleSignIn.standard(scopes: ['email']);
      final account = await _googleSignIn?.signIn();
      return account;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> googleSignOut() async {
    final isSignIn = await _googleSignIn?.isSignedIn() ?? false;
    if (isSignIn) {
      await _googleSignIn?.signOut();
    }
  }

  Future<AuthorizationCredentialAppleID?> appleLogin() async {
    try {
      final appleSignIn = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ]);

      return appleSignIn;
    } catch (e) {
      // final error = e as SignInWithAppleAuthorizationException;
      rethrow;
    }
  }
}
