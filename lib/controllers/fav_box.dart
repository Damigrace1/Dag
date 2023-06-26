import 'package:dag/main.dart';
import 'package:dag/music/presentation/homescreen.dart';
import 'package:dag/provider/music.dart';
import 'package:dag/value_notifiers.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../music/data/hive_store.dart';
import '../music/presentation/song_display.dart';
import '../utils/functions.dart';

class FavBox {
  static Favourite createFavourite(
      Map<String, dynamic> musicMap, String musicUrl) {
    return Favourite()
      ..id = musicMap['ytid']
      ..songUrl = musicUrl
      ..title = formatTit(musicMap['title'])
      ..imgUrl = musicMap['image']
      ..authur = musicMap['authur']
      ..duration = musicMap['duration'];
  }

  static addToFavourite(String musicId, Favourite fav) {
    favBox?.put(musicId, fav);
    showToast('Music added to Favourites');
  }

  static removeFromFavourite(String musicId) async{

    BuildContext? ctx = homeKey.currentContext;
    ctx?.read<MusicProvider>().isFav = false ;
   await favBox?.delete(musicId);
    ctx?.read<MusicProvider>().
   favSongs.remove(musicId);
   ctx?.read<MusicProvider>().songGroup?.remove(
     ctx.read<MusicProvider>().songIndex
   );
    showToast('Music Removed from Favourites');

  }


}
