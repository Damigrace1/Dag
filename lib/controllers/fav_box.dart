import 'package:dag/main.dart';
import 'package:dag/models/music_model.dart';
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
      MusicModel musicModel) {
    return Favourite()
      ..id = musicModel.id
      ..title =musicModel.title
      ..imgUrl = musicModel.imgUrl
      ..authur = musicModel.author
      ..duration = musicModel.duration;
  }

  static addToFavourite( Favourite fav) {
    favBox?.put(fav.id, fav);
    showToast('Music added to Favourites');
  }

  static removeFromFavourite(String musicId) async{

    BuildContext? ctx = homeKey.currentContext;
   await favBox?.delete(musicId);
    ctx?.read<MusicProvider>().
   favSongs.remove(musicId);
   ctx?.read<MusicProvider>().musicModelGroup?.removeAt(
     ctx.read<MusicProvider>().songIndex
   );
    showToast('Music Removed from Favourites');

  }


}
