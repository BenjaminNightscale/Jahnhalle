import 'package:jahnhalle/pages/mohsim/utils/social_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SP {
  static final i = SP();
  SharedPreferences? _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> setString({required String key, required String value}) async {
    await _sharedPreferences?.setString(key, value);
  }

  String? getString({required String key}) {
    return _sharedPreferences?.getString(key);
  }

  void signOut() async {
    _sharedPreferences?.clear();

    SocialLogin.shared.googleSignOut();
    // AppNavigator.pushNamedAndRemove(routeName: Routes.login);
  }
}
