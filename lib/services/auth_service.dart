import 'package:finance_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSerive with ChangeNotifier {
  //create a box
  Box<UserModel>? _userBox;
  static const String _loggedInKey = 'isLoggedIn';

  //open the box
  Future<void> openBox() async {
    _userBox = await Hive.openBox('users');
  }

  //register user
  Future<bool> registerUser(UserModel user) async {
    if (_userBox == null) {
      await openBox();
    }
    await _userBox!.add(user);
    notifyListeners();
    return true;
  }

  //login user
  //check wether the user object exist inside our hive db..
  //if the email password combination is there fetch all the data of particular data

  Future<UserModel?> loginUser(String email, String password) async {
    if (_userBox == null) {
      await openBox();
    }
    for (var user in _userBox!.values) {
      //check the passowrd email combo

      if (user.email == email && user.password == password) {
        await setLoggedInState(true, user.id);
        return user;
      }
    }
    return null;
  }

  //maintaining the state of user log in
  Future<void> setLoggedInState(bool isLoggedIn, String id) async {
    //create instance of shared preferences
    final _pref = await SharedPreferences.getInstance();
    await _pref.setBool(_loggedInKey, isLoggedIn);
    await _pref.setString('id', id);
  }

  //to check wthether the user already loggeedin
  Future<bool> isLoggedIn() async {
    final _pref = await SharedPreferences.getInstance();
    return _pref.getBool(_loggedInKey) ?? false;
  }

  //get the user data
  Future<UserModel?> getCurrentUser() async {
    final isUserLoggedIn = await isLoggedIn();

    if (isUserLoggedIn) {
      final loggedInUserId = await getLoggedInUserId();
      for (var user in _userBox!.values) {
        if (user.id == loggedInUserId) {
          return user;
        }
      }
    }
    return null;
  }

  Future<String?> getLoggedInUserId() async {
    final _pref = await SharedPreferences.getInstance();
    final id = await _pref.getString('id');
    return id;
  }
}
