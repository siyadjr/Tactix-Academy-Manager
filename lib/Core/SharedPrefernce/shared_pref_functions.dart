import 'package:shared_preferences/shared_preferences.dart';
import 'package:tactix_academy_manager/Core/important_data.dart';

class SharedPrefFunctions {
  sharedPrefSignup() async {
    final sharedpref = await SharedPreferences.getInstance();
    final value = await sharedpref.setBool(userRegisterd, true);
  }

  sharePrefTeamCreated() async {
    final sharedpref = await SharedPreferences.getInstance();
    final value = await sharedpref.setBool(userRegisterd, true);
    await sharedpref.setBool(userAuthCompleated, true);
    await sharedpref.setBool(userLoggedIn, true);
  }

  sharePrefLogged() async {
    final sharedpref = await SharedPreferences.getInstance();
    await sharedpref.setBool(userLoggedIn, true);
  }

  logout() async {
    final sharedpref = await SharedPreferences.getInstance();
    await sharedpref.setBool(userLoggedIn, false);
  }

  deleteAccount() async {
    final sharedpref = await SharedPreferences.getInstance();
    await sharedpref.setBool(userLoggedIn, false);
    await sharedpref.setBool(userRegisterd, false);
    await sharedpref.setBool(userAuthCompleated, false);
  }
}
