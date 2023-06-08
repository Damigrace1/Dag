import 'package:dag/music/presentation/homescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../music/domain/song_model.dart';
import '../music/presentation/song_display.dart';
import '../nav screens/search/presentation/search_music.dart';
import '../provider/music.dart';

formatDur(Duration dur){
  int? m = dur.inMinutes; // Get the minutes part
  int s = dur.inSeconds % 60;
  String d = '${m.toString().length == 1 ? '0$m' : m} :'
      ' ${s.toString().length == 1 ? '0$s' : s}';
  return d;
}

formatTit(String tit){
  return tit.toString()
      .split('(')[0]
      .replaceAll('&quot;', '"')
      .replaceAll('&amp;', '&');
}
calcTotDur( Duration dur){
  int tot = dur.inMinutes * 60 + dur.inSeconds;
  return tot;
}

void loadM(BuildContext context, Map<String, dynamic> val)async{
  final manifest = await yt.
  videos.streamsClient.
  getManifest(val["ytid"]);
  final duration = await player.setUrl(
      manifest.audioOnly.withHighestBitrate().url.toString());
  context.read<MusicProvider>().endV = duration!;
  context.read<MusicProvider>().play = true;
  context.read<MusicProvider>().loading = false;
  player.play();
  context.read<MusicProvider>().inSession = true;
  context.read<MusicProvider>().song = SongModel(
    artistes: formatSongTitle(val['more_info']['singers']),
    title: val['title'],
    imgUrl: val['image']
  );
  positStream = player.positionStream.listen((v) {
    //context.read<MusicProvider>().startV = v;
    homeKey.currentContext!.read<MusicProvider>().sV = v;
  });
  player.bufferedPositionStream.listen((v) {
    homeKey.currentContext!.read<MusicProvider>().bV = v;
  });
}