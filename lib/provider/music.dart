import 'package:flutter/cupertino.dart';

class MusicProvider  extends ChangeNotifier{
  bool _loading = false;
  bool get loading => _loading;
  set loading (bool val){
    _loading = val;
    notifyListeners();
  }

  bool _play = false;
  bool get play => _play;
  set play (bool val){
    _play = val;
    notifyListeners();
  }

  String _startV = '0 : 0';
  String get startV => _startV;
  set startV (String v){
    _startV= v;
    notifyListeners();
  }
  String _endV = '0 : 0';
  String get endV => _endV;
  set endV (String v){
    _endV = v;
    notifyListeners();
  }

  double _sV = 0.00;
  double get sV => _sV;
  set sV (double v){
    _sV = v;
    notifyListeners();
  }
}
