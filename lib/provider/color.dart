
import 'package:flutter/material.dart';

class ColorProvider extends ChangeNotifier{
  Color _origOrange = Colors.deepOrange;
  Color get origOrange => _origOrange;
  set origOrange (Color val){
    _origOrange = val;
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

  Color _origLightAsh = Color(0x38a29cff);
  Color get origLightAsh => _origLightAsh;
  set origLightAsh (Color val){
    _origLightAsh = val;
    notifyListeners();
  }
  bool _modeStat = true;
  bool get modeStat => _modeStat;
  set modeStat (bool val){
    _modeStat = val;
    notifyListeners();
  }
}