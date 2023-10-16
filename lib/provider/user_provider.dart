import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/mock_services.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = MockServices().user;

  UserModel? get user => _user;

  void setUser(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }

  Future<bool> getLogingStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return Future.value(pref.getBool('user_status'));
  }

  Future<void> updateLogging(bool logIn) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _user.isLoggedIn = logIn;

    await pref.setBool('user_status', logIn);

    notifyListeners();
  }

  Future<List<String>> getGymName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return Future.value(pref.getStringList('user_gym_names'));
  }

  Future<void> updateGymName(String gymName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (_user.gymName.contains(gymName)) {
      _user.gymName.remove(gymName);
    } else {
      _user.gymName.add(gymName);
    }
    await pref.setStringList('user_gym_names', _user.gymName);

    notifyListeners();
  }
}
