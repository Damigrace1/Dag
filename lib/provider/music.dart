import 'package:dag/music/domain/song_model.dart';
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

  Duration _startV =  const Duration();
  Duration get startV => _startV;
  set startV (Duration v){
    _startV= v;
    notifyListeners();
  }
  Duration _endV = const Duration();
  Duration get endV => _endV;
  set endV (Duration v){
    _endV = v;
    notifyListeners();
  }

  SongModel? _song;
  SongModel? get song => _song;
  set song (SongModel? v){
    _song = v;
    notifyListeners();
  }

  Duration _sV = const Duration();
  Duration get sV => _sV;
  set sV (Duration v){
    _sV = v;
    notifyListeners();
  }

  Map<String, dynamic> _dispSong = {};
  Map<String, dynamic> get dispSong => _dispSong;
  set dispSong(Map<String, dynamic> v){
    _dispSong = v;
    notifyListeners();
  }

  bool _inSession = false;
  bool get inSession => _inSession;
  set inSession (bool val){
    _inSession = val;
    notifyListeners();
  }
  Duration _bV = const Duration();
  Duration get bV => _bV;
  set bV (Duration v){
    _bV = v;
    notifyListeners();
  }
}
