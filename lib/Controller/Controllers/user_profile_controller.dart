import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Controller/Api/cloudinery_class.dart';
import 'package:tactix_academy_manager/Core/SharedPrefernce/shared_pref_functions.dart';
import 'package:tactix_academy_manager/Model/Firebase/Authentication%20funcations/user.db.dart';
import 'package:tactix_academy_manager/Model/Models/manager_model.dart';


class UserProfileController extends ChangeNotifier {
  ManagerModel? _manager;
  ManagerModel  ? get player => _manager;
  bool _imageLoading = false;
  bool get imageLoading => _imageLoading;
  bool _nameLoading = false;
  bool get nameLoading => _nameLoading;
  String? _imagePath;
  String? _name;
  String? get name => _name;
  String? get imagepath => _imagePath;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getUserData() async {
    _isLoading = true;
    notifyListeners();
    _manager = await UserDatbase().getUser();
    _imagePath = _manager!.userProfile;
    _name = _manager!.name;
    _isLoading = false;

    notifyListeners();
  }

  Future<void> logout(context) async {
    await SharedPrefFunctions().logout();
  
  }

  Future<void> deleteAccount(context) async {
    _isLoading = true;
    notifyListeners();
    await UserDatbase().deleteAccount();
    await SharedPrefFunctions().deleteAccount();
  
  }

  Future<void> updateImageUi(String image) async {
    _imageLoading = true;
    notifyListeners();
    final cloudineryImage = await CloudineryClass().uploadPhoto(image);
    if (cloudineryImage != null) {
      _imagePath = cloudineryImage;

      await UserDatbase().uplaodUserProfile(cloudineryImage);
    }
    _imageLoading = false;
    notifyListeners();
  }

  Future<void> updateUserName(String newName) async {
    _nameLoading = true;
    notifyListeners();
    await UserDatbase().updateUserName(newName);
    _name = newName;
    _nameLoading = false;
    notifyListeners();
  }
}
