import 'package:flutter/cupertino.dart';

class HomeProvider extends ChangeNotifier{
  int _tabIndex= 0;
  int get tabIndex => _tabIndex;
  set tabIndex (int val){
    _tabIndex = val;
    notifyListeners();
  }

  double _navHeight = 50;
  double get navHeight => _navHeight;
  set navHeight (double val){
    _navHeight = val;
    notifyListeners();
  }

  bool _showNavBar = true;
  bool get showNavBar => _showNavBar;
  set showNavBar (bool val){
    _showNavBar = val;
    notifyListeners();
  }

  // bool _isLoadingMusic = false;
  // bool get isLoadingMusic  => _isLoadingMusic ;
  // set isLoadingMusic (bool val){
  //   _isLoadingMusic  = val;
  //   notifyListeners();
  // }
}