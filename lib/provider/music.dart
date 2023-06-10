import 'package:dag/music/data/hive_store.dart';
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

  // SongModel? _song;
  // SongModel? get song => _song;
  // set song (SongModel? v){
  //   _song = v;
  //   notifyListeners();
  // }

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

  bool _singleT = true;
  bool get singleT => _singleT;
  set singleT (bool val){
    _singleT = val;
    notifyListeners();
  }
  bool _rec = false;
  bool get rec => _rec;
  set rec (bool val){
    _rec = val;
    notifyListeners();
  }
  List<Favourite>? _songGroup;
  List<Favourite>? get songGroup => _songGroup;
  set songGroup (List<Favourite>? val){
    _songGroup = val;
    notifyListeners();
  }

  bool _inSession = false;
  bool get inSession => _inSession;
  set inSession (bool val){
    _inSession = val;
    notifyListeners();
  }
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  set isPlaying (bool val){
    _isPlaying = val;
    notifyListeners();
  }
  Duration _bV = const Duration();
  Duration get bV => _bV;
  set bV (Duration v){
    _bV = v;
    notifyListeners();
  }
  String _songUrl = '';
  String get songUrl => _songUrl;
  set songUrl (String v){
    _songUrl = v;
    notifyListeners();
  }

  double _dlVal = 0;
  double get dlVal => _dlVal;
  set dlVal (double val){
    _dlVal = val;
    notifyListeners();
  }
}
