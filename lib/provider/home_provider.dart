import 'package:flutter/cupertino.dart';

class HomeProvider extends ChangeNotifier{
  int _tabIndex= 0;
  int get tabIndex => _tabIndex;
  set tabIndex (int val){
    _tabIndex = val;
    notifyListeners();
  }
}