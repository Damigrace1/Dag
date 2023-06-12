import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:dag/main.dart';
import 'package:dag/music/data/hive_store.dart';
import 'package:dag/music/presentation/homescreen.dart';
import 'package:dag/provider/color.dart';
import 'package:dag/utils/custom_textstyles.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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


Future<List> fetchSongsList(String searchQuery) async {
  final VideoSearchList list = await yt.search.search(searchQuery);
  final searchedList = [
    for (final s in list)
      returnSongLayout(
        0,
        s,
      )
  ];
  return searchedList;
}

void downloadSong()async{
  Directory? dl = Directory('/storage/emulated/0/Download');
  if (!await dl.exists()) dl = await getExternalStorageDirectory();
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
  ].request();

  if(statuses[Permission.storage]!.isGranted){
    String saveName = "${homeKey.currentContext?.read<MusicProvider>().songGroup![
    homeKey.currentContext!.read<MusicProvider>().songIndex].title!}.mp3";
    String savePath = "${dl!.path}/$saveName";

    try {
      await Dio().download(
          homeKey.currentContext!.read<MusicProvider>().songGroup![
          homeKey.currentContext!.read<MusicProvider>().songIndex].songUrl!,
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              homeKey.currentContext!.read<MusicProvider>().dlVal =
                  received / total;
                 // (received / total * 100).toStringAsFixed(0)
              //you can build progressbar feature too
            }
          });
      homeKey.currentContext!.read<MusicProvider>().dlVal = 0;
      (fluKey.currentWidget as Flushbar).dismiss();
      showToast(homeKey.currentContext!, "Song downloaded");
    } on DioException catch (e) {
      print(e.message);
    }
  }else{
    print("No permission to read and write.");
  }
}

void showToast(BuildContext context, String message) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      backgroundColor: context.read<ColorProvider>().primaryCol,
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}
final fluKey =  GlobalKey();
void showPersistentSnackbar(BuildContext context, String message) {

   Flushbar(
     key: fluKey,
    title: "Downloading...",
    margin: EdgeInsets.only(top: 15.h,left: 12.w,right: 12.w),
    borderRadius: BorderRadius.circular(8),
    titleColor: Colors.white,
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.elasticOut,
    backgroundColor: context.read<ColorProvider>().blackAcc,
    isDismissible: true,
    duration: const Duration(minutes:60),
    icon:  Icon(
      Icons.download,
      color: context.read<ColorProvider>().primaryCol,
    ),
    mainButton: TextButton(
      onPressed: () {
        (fluKey.currentWidget as Flushbar).dismiss();
      },
      child: Text(
        "Dismiss",
        style: CustomTextStyle(color: Colors.white),
      ),
    ),
    showProgressIndicator: false,
    titleText: Text(
      "Downloading",
      style: TextStyle(
          fontSize: 18.sp,
          color: Colors.white),
    ),
    messageText:
    Consumer2<ColorProvider,MusicProvider>(
       builder: (context,color,music,child){
         return  LinearProgressIndicator(
           value: music.dlVal,
           backgroundColor: Colors.white10,
           color: color.primaryCol,
         );
       })
  ).show(context);
}

List<Favourite> getFavSongs(){
  List? allKeys = favBox?.keys.toList();
  List<Favourite>? allFavs = [];
  allKeys?.forEach((key) {
   allFavs.add(favBox?.get(key));
  });
  return allFavs;
}
List<Favourite> favs = [];

void loadM()async{

  BuildContext ctx = homeKey.currentContext!;
  ctx.read<MusicProvider>().isPlaying = true;
//
// if(!ctx.read<MusicProvider>().singleT )
//  { favs  = context.read<MusicProvider>().songGroup!;}
 Duration? duration =
     await loadSongs(ctx);

  ctx.read<MusicProvider>().endV = duration!;
  ctx.read<MusicProvider>().play = true;
  ctx.read<MusicProvider>().loading = false;
  player.play();
  player.setLoopMode(LoopMode.off);
  ctx.read<MusicProvider>().inSession = true;

  player.positionStream.listen((v) {
   ctx.read<MusicProvider>().sV = v;
  });
  bufStream = player.bufferedPositionStream.listen((v) {
    ctx.read<MusicProvider>().bV = v;
  });
  player.playingStream.listen((isPlay) {
    print('dfghjkl:$isPlay');
    isPlay? ctx.read<MusicProvider>().loading
    = false : true;
  });
  player.playerStateStream.listen((state) {
    print('dfghjkl:$state');
    state.processingState == ProcessingState.
    buffering? ctx.read<MusicProvider>().loading
    = true : false;
  });
  player.durationStream.listen((dur) {
    ctx.read<MusicProvider>().endV = dur??const Duration();
  });
  positStream = player.currentIndexStream.listen((index) async {
      // ctx.read<MusicProvider>().dispSong = {
      //   'ytid': favs[index!].id,
      //   'title': favs[index].title,
      //   'image': favs[index].imgUrl,
      //   'lowResImage': favs[index].imgUrl,
      //   'authur': favs[index].artiste,
      // };
      ctx.read<MusicProvider>().songIndex = index!;
    });
}



 loadSongs( BuildContext ctx)async{

   List<AudioSource> aS = [];
  for (var song in  ctx.read<MusicProvider>().
  songGroup!) {
    AudioSource a = AudioSource.uri(
      Uri.parse(song.songUrl!),
      tag:  MediaItem(
        // Specify a unique ID for each media item:
        id: song.id!,
        // Metadata to display in the notification:
        album: 'Unknown',
        title: song.title!,
        artUri: Uri.parse(song.imgUrl!),
      ),
    );
    aS.add(a);
  }
   AudioSource audioSource = ConcatenatingAudioSource(children:
   <AudioSource>[...aS]);
   return  await player.setAudioSource(audioSource);
 }


// playSingleItemT( Favourite f)async{
//
//   AudioSource a = AudioSource.uri(
//     Uri.parse(f.songUrl!),
//     tag:  MediaItem(
//       // Specify a unique ID for each media item:
//       id: '',
//       // Metadata to display in the notification:
//       album: '',
//       title: 'test',
//      // artUri: Uri.parse(val['image']),
//     ),
//   );
//   Duration? dur = await player.setAudioSource(a);
//   return dur;
// }
