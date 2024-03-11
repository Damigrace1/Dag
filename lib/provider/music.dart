import 'package:dag/models/music_model.dart';
import 'package:dag/models/video_model.dart';
import 'package:dag/music/data/hive_store.dart';
import 'package:dag/music/domain/song_model.dart';
import 'package:dag/utils/enums.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../views/searchHistWidget.dart';
bool notify = false;
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

  bool _isPlayerActive = false;
  bool get isPlayerActive => _isPlayerActive;
  set isPlayerActive (bool val){
    _isPlayerActive = val;
    notifyListeners();
  }

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  set isPlaying (bool val){
    _isPlaying = val;
    notifyListeners();
  }

  bool _isFav = false;
  bool get isFav => _isFav;
  set isFav (bool val){
    _isFav = val;
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

  int _songIndex = 0;
  int get songIndex => _songIndex;
  set songIndex (int val){
    _songIndex = val;
    notifyListeners();
  }

   PlayMode _loopMode = PlayMode.all;
  PlayMode get loopMode => _loopMode;
  set loopMode (PlayMode val){
    _loopMode = val;
    notifyListeners();
  }
  List<Favourite> _favSongs = [];
  List<Favourite> get favSongs => _favSongs;
  set favSongs (List<Favourite> val){
    _favSongs = val;
    notifyListeners();
  }

  List<SearchHistWidget> _searchHistWid = [];
  List<SearchHistWidget> get searchHistWid => _searchHistWid;
  set searchHistWid (List<SearchHistWidget> val){
    _searchHistWid = val;
    notifyListeners();
  }

  List<SongModel> _localMusicList = [];
  List<SongModel> get localMusicList => _localMusicList;
  set localMusicList (List<SongModel> val){
    _localMusicList = val;
    notifyListeners();
  }

  List<VideoData> _localVideoList = [];
  List<VideoData> get localVideoList => _localVideoList;
  set localVideoList (List<VideoData> val){
    _localVideoList = val;
    notifyListeners();
  }

  List<MusicModel>? _musicModelGroup;
  List<MusicModel>? get musicModelGroup => _musicModelGroup;
  set musicModelGroup (List<MusicModel>? val){
    _musicModelGroup = val;
    notifyListeners();
  }



  bool _isLocalPlay = false;
  bool get isLocalPlay  => _isLocalPlay ;
  set isLocalPlay  (bool val){
    _isLocalPlay  = val;
    notifyListeners();
  }

  CancelToken _cancelToken = CancelToken();
  CancelToken get cancelToken => _cancelToken;
  set cancelToken (CancelToken val){
    _cancelToken = val;
    notifyListeners();
  }

}
