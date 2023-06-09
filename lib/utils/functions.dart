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

void loadM(BuildContext context, Map<String, dynamic> val)async{
  BuildContext ctx = homeKey.currentContext!;
  // ctx.read<MusicProvider>().song = SongModel(
  //     artistes: formatSongTitle(val['more_info']['singers']),
  //     title: val['title'],
  //     imgUrl: val['image'],
  //   id: val['ytid']
  // );
  ctx.read<MusicProvider>().isPlaying = true;
  final manifest = await yt.
  videos.streamsClient.
  getManifest(val["ytid"]);
  final duration = await player.setAudioSource(
     // manifest.audioOnly.withHighestBitrate().url.toString()
    AudioSource.uri(
      Uri.parse(manifest.audioOnly.withHighestBitrate().url.toString()),
      tag: const MediaItem(
        // Specify a unique ID for each media item:
        id: '1',
        // Metadata to display in the notification:
        album: "Album name",
        title: "Song name",
        //artUri: Uri.parse(),
      ),
    ),
  );
  ctx.read<MusicProvider>().songUrl = manifest.audioOnly.withHighestBitrate().
  url.toString();
  ctx.read<MusicProvider>().endV = duration!;
  ctx.read<MusicProvider>().play = true;
  context.read<MusicProvider>().loading = false;
  player.play();
  ctx.read<MusicProvider>().inSession = true;

  positStream = player.positionStream.listen((v) {
    //context.read<MusicProvider>().startV = v;
    homeKey.currentContext!.read<MusicProvider>().sV = v;
  });
  bufStream = player.bufferedPositionStream.listen((v) {
    homeKey.currentContext!.read<MusicProvider>().bV = v;
  });
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
    String saveName = "${homeKey.currentContext?.read<MusicProvider>().dispSong['title']}.mp3";
    String savePath = "${dl!.path}/$saveName";

    try {
      await Dio().download(
          homeKey.currentContext!.read<MusicProvider>().songUrl,
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

loadSongs(){
  AudioPlayer aud = AudioPlayer();
  //int? curQueIndex = 0;
  ConcatenatingAudioSource audioSource = ConcatenatingAudioSource(children:[
    AudioSource.asset('sounds/dark-engine-logo-141942.mp3'),
    AudioSource.asset('sounds/simple-clean-logo-13775.mp3')
  ]);
  aud.setAudioSource(audioSource);
  aud.play();

  // aud.currentIndexStream.listen((index) {
  //   curQueIndex = index;
  // });
  aud.playerStateStream.listen((state) {
    if (state.processingState == ProcessingState.completed) {
      aud.seekToNext();
    }
  });
}

getSongDetails(String id)async{
  final song = await yt.videos.streamsClient.
  getManifest(id);
}
List<Favourite> getFavSongs(){
  List? allKeys = favBox?.keys.toList();
  List<Favourite>? allFavs = [];
  allKeys?.forEach((key) {
   allFavs.add(favBox?.get(key));
  });
  return allFavs;
}
// Future<List> fetchFavList() async {
//   List<Favourite> favs = getFavSongs();
//   final favList = [];
//   favs.forEach((fav) {
//     Map<String,dynamic> f = {
//       'title':fav.title,
//       'authur':fav.artiste,
//       ''
//     }
//   })
//
//   return searchedList;
// }