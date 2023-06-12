
import 'package:flutter/material.dart';

class ColorProvider extends ChangeNotifier{
  Color _primaryCol = Color(0xffF9CE80);
  Color get primaryCol => _primaryCol;
  set primaryCol (Color val){
    _primaryCol = val;
    notifyListeners();
  }

  Color _scaffoldCol = Colors.black;
  Color get scaffoldCol => _scaffoldCol;
  set scaffoldCol (Color val){
    _scaffoldCol = val;
    notifyListeners();
  }
  Color _origWhite = Colors.white;
  Color get origWhite => _origWhite;
  set origWhite (Color val){
    _origWhite = val;
    notifyListeners();
  }
  Color _origBlackAsh = Colors.white;
  Color get origDeepAsh => _origBlackAsh;
  set origDeepAsh (Color val){
    _origBlackAsh = val;
    notifyListeners();
  }

  Color _blackAcc = Color(0xFC2D2D2D);
  Color get blackAcc => _blackAcc;
  set blackAcc (Color val){
    _blackAcc = val;
    notifyListeners();
  }
  bool _modeStat = true;
  bool get modeStat => _modeStat;
  set modeStat (bool val){
    _modeStat = val;
    notifyListeners();
  }
}