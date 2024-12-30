import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:dag/controllers/audio_streams.dart';
import 'package:dag/main.dart';
import 'package:dag/music/data/hive_store.dart';
import 'package:dag/music/presentation/homescreen.dart';
import 'package:dag/provider/color.dart';
import 'package:dag/utils/custom_textstyles.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../controllers/music_operations.dart';
import '../music/domain/song_model.dart';
import '../music/presentation/song_display.dart';
import '../nav screens/search/presentation/search_music.dart';
import '../provider/music.dart';

formatDur(Duration dur) {
  int? m = dur.inMinutes; // Get the minutes part
  int s = dur.inSeconds % 60;
  String d = '${m.toString().length == 1 ? '0$m' : m} :'
      ' ${s.toString().length == 1 ? '0$s' : s}';
  return d;
}

formatTit(String tit) {
  return tit
      .toString()
      .split('(')[0]
      .replaceAll('&quot;', '"')
      .replaceAll('&amp;', '&');
}

calcTotDur(Duration dur) {
  int tot = dur.inMinutes * 60 + dur.inSeconds;
  return tot;
}

Future<List<Map<String, dynamic>>> fetchSongsList(String searchQuery) async {
  final VideoSearchList list = await yt.search.search(searchQuery);
  final searchedList = [
    for (final s in list)
      if (!s.isLive)
        returnSongLayout(
          0,
          s,
        )
  ];
  return searchedList;
}



Dio dio = Dio();
void downloadSong(BuildContext context,String name,String url) async {

 context.read<MusicProvider>().cancelToken = CancelToken();
  PermissionStatus status = PermissionStatus.denied;
  status = await Permission.audio .request();
  // if(!await Permission.storage.isGranted){
  //
  //   status = await Permission.manageExternalStorage.request();
  //   print('1');
  // }
  // else{
  //   status = PermissionStatus.granted;
  //   print('2');
  // }

  if(!status.isGranted){
    showToast("No permission to save to storage.",action: SnackBarAction(label: "Open Settings",
        onPressed: (){
          openAppSettings();
        }));
    print("No permission to read and write.");
    (fluKey.currentWidget as Flushbar).dismiss();
    return;
  }
  final Directory? appDocDir = await getExternalStorageDirectory();
 // final String hiddenDirectoryName = 'myHiddenDirectory';
  final Directory dl = Directory('/storage/emulated/0/Music');
  try {
  if (!await dl.exists()) {
    await dl.create(recursive: true).then((value){});
  }

    String savePath = "${dl.path}/$name.mp3";
      await dio.download(
         await MusicOperations().getUrl(context.read<MusicProvider>()
              .musicModelGroup![context.read<MusicProvider>().songIndex]
              .id!),
          savePath,
          deleteOnError: false,
          onReceiveProgress: (received, total) {
        if (total != -1) {
          homeKey.currentContext!.read<MusicProvider>().dlVal =
              received / total;

        }
      },
          cancelToken:  context.read<MusicProvider>().cancelToken
      );
      homeKey.currentContext!.read<MusicProvider>().dlVal = 0;
      (fluKey.currentWidget as Flushbar).dismiss();
      showToast("Song downloaded");
    } on DioException catch (e) {
     // showToast('Could not download song.',duration: 5);
      (fluKey.currentWidget as Flushbar).dismiss();
      print('ex:$e');
    } on Exception catch(e){
      showToast('An error occurred while downloading the music.',duration: 5);
      (fluKey.currentWidget as Flushbar).dismiss();
      print('exec:$e');
    }


}


void showToast(String message,{
  SnackBarAction? action,
  int? duration,
  Color? color
}) {
  BuildContext ctx = homeKey.currentContext!;

  final scaffold = ScaffoldMessenger.of(ctx);
  scaffold.showSnackBar(
    SnackBar(
      backgroundColor: color??CupertinoColors.systemGrey,
      content: Text(message),
      action: action,
      duration:  Duration(seconds: duration??3),
    ),
  );
}

final fluKey = GlobalKey();
void showPersistentSnackbar(BuildContext context, String message) {
  Flushbar(
      key: fluKey,
      title: "Downloading...",
      margin: EdgeInsets.only(top: 15.h, left: 12.w, right: 12.w),
      borderRadius: BorderRadius.circular(8),
      titleColor: Colors.white,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: context.read<ColorProvider>().blackAcc,
      isDismissible: true,
      duration: const Duration(minutes: 60),
      icon: Icon(
        Icons.download,
        color: context.read<ColorProvider>().primaryCol,
      ),
      mainButton: TextButton(
        onPressed: () {
          print('cancel called');
          homeKey.currentContext!.read<MusicProvider>().dlVal = 0;
          homeKey.currentContext!.read<MusicProvider>().cancelToken.cancel();
          (fluKey.currentWidget as Flushbar).dismiss();
          showToast('Download has been cancelled.');
        },
        child: Icon(Icons.cancel),
      ),
      showProgressIndicator: false,
      titleText: Text(
        "Downloading",
        style: TextStyle(fontSize: 18.sp, color: Colors.white),
      ),
      messageText: Consumer2<ColorProvider, MusicProvider>(
          builder: (context, color, music, child) {
        return LinearProgressIndicator(
          value: music.dlVal,
          backgroundColor: Colors.white10,
          color: color.primaryCol,
        );
      })).show(context);
}

List<Favourite> getFavSongs() {
  List? allKeys = favBox?.keys.toList();
  List<Favourite>? allFavs = [];
  allKeys?.forEach((key) {
    allFavs.add(favBox?.get(key));
  });
  return allFavs;
}

void loadMusic (int ind){
  BuildContext context = homeKey.currentContext!;
  if(context.read<MusicProvider>().isPlayerActive)
    player.dispose();
  // context.read<MusicProvider>().songIndex = ind;
  context.read<MusicProvider>().inSession = false;
  context.read<MusicProvider>().isPlayerActive = true;
  player = AudioPlayer();

  if (!context.read<MusicProvider>().inSession) {
    Future.delayed(Duration.zero, () {
      MusicOperations()
          .playSong(index: ind);
      // if (context.read<MusicProvider>().musicModelGroup!.length == 1)
      //   MusicOperations().loadPlayGroup();
    });
    context.read<MusicProvider>().inSession = true;
  }
  MusicOperations.favMusicChecker(context);
}


void loadM() async {
  BuildContext ctx = homeKey.currentContext!;
  ctx.read<MusicProvider>().isPlaying = true;

  Duration? duration = await loadSongs(ctx);

  ctx.read<MusicProvider>().endV = duration!;
  ctx.read<MusicProvider>().play = true;
  ctx.read<MusicProvider>().loading = false;
  player.play();
  player.setLoopMode(LoopMode.one);
  ctx.read<MusicProvider>().inSession = true;
AudioStreams().initStreams();
}

loadSongs(BuildContext ctx) async {
  List<AudioSource> aS = [];
  for (var song in ctx.read<MusicProvider>().songGroup!) {
    AudioSource a = AudioSource.uri(
      Uri.parse(song.songUrl!),
      tag: MediaItem(
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
  AudioSource audioSource =
      ConcatenatingAudioSource(children: <AudioSource>[...aS]);
  return await player.setAudioSource(audioSource);
}

Future<void> showLoader(
    FlutterGifController controller, BuildContext context) async {
  controller.repeat(min: 0, max: 68, period: const Duration(seconds: 2));
  await showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          child: GifImage(
            controller: controller,
            image: AssetImage("images/lo.gif"),
          ),
        );
      });
}

// loadPlaylist0(
//     String authur,
//     BuildContext context
//     )async{
//   // context.read<MusicProvider>().
//   // songGroup?.clear();
//   bool? isContainSong;
//   List<Map<String, dynamic>> playListInMap
//   = await fetchSongsList(authur);
//   playListInMap.take(10).forEach((song) async {
//  isContainSong = context.read<MusicProvider>().songGroup
//     ?.any((songFromGroup) => songFromGroup
//     .id == song['ytid']
// );
// if(!isContainSong!) {
//  final manifest = await yt.
//  videos.streamsClient.
//  getManifest(song["ytid"]);
// context.read<MusicProvider>
//   ().songGroup
//     ?.add( Favourite()
//   ..id = song['ytid']
//   ..songUrl =  manifest.audioOnly.withHighestBitrate().
//   url.toString()
//   ..title = song['title']
//   ..imgUrl = song['image']
//   ..artiste = song['authur']
//   ..duration = song['duration']??
//       const Duration(seconds: 25));
// List<AudioSource> audSource = [
//   player.audioSource!
// ];
// audSource.add(
//     AudioSource.uri(
//       Uri.parse(manifest.audioOnly.withHighestBitrate().
//       url.toString()),
//       tag:  MediaItem(
//         // Specify a unique ID for each media item:
//         id:  song['ytid']!,
//         // Metadata to display in the notification:
//         album: 'Unknown',
//         title: song['title'],
//         artUri: Uri.parse( song['image']!),
//       ),
//     )
// );
//   player.setAudioSource(
//     ConcatenatingAudioSource(children: audSource)
//  );
// } ;
//     // print(song'ytid']);
//     // if(!context.read<MusicProvider>().
//     // songGroup!.contains(song['ytid'])){
//     // final manifest = await yt.
//     // videos.streamsClient.
//     // getManifest(song["ytid"]);
//  print(context.read<MusicProvider>().
//  songGroup?.length);
//  // List<AudioSource> aS = [];
//  // for (var song in  ctx.read<MusicProvider>().
//  // songGroup!) {
//  //   AudioSource a =
//  //   AudioSource.uri(
//  //     Uri.parse(song.songUrl!),
//  //     tag:  MediaItem(
//  //       // Specify a unique ID for each media item:
//  //       id: song.id!,
//  //       // Metadata to display in the notification:
//  //       album: 'Unknown',
//  //       title: song.title!,
//  //       artUri: Uri.parse(song.imgUrl!),
//  //     ),
//  //   );
//  //   aS.add(a);
//  // }
//  // AudioSource audioSource = ConcatenatingAudioSource(children:
//  // <AudioSource>[...aS]);
//
//   });
//
// }
//
// loadPlaylist(
//     String authur,
//     BuildContext context
//     )async{
//
//   bool? isContainSong;
//   List<AudioSource> audSource = [];
//   List<Map<String, dynamic>> playListInMap
//   = await fetchSongsList(authur);
//    playListInMap.take(3).forEach((song) async {
//     isContainSong = context.read<MusicProvider>().songGroup
//         ?.any((songFromGroup) => songFromGroup
//         .id == song['ytid']
//     );
//     if(!isContainSong!) {
//       final manifest = await yt.
//       videos.streamsClient.
//       getManifest(song["ytid"]);
//       context.read<MusicProvider>
//         ().songGroup
//           ?.add( Favourite()
//         ..id = song['ytid']
//         ..songUrl =  manifest.audioOnly.withHighestBitrate().
//         url.toString()
//         ..title = song['title']
//         ..imgUrl = song['image']
//         ..artiste = song['authur']
//         ..duration = song['duration']??
//             const Duration(seconds: 25));
//       audSource  = [
//         player.audioSource!
//       ];
//       audSource.add(AudioSource.uri(
//             Uri.parse(manifest.audioOnly.withHighestBitrate().
//             url.toString()),
//             tag:  MediaItem(
//               // Specify a unique ID for each media item:
//               id:  song['ytid']!,
//               // Metadata to display in the notification:
//               album: 'Unknown',
//               title: song['title'],
//               artUri: Uri.parse( song['image']!),
//             ),
//           ));
//     } ;
//     print(context.read<MusicProvider>().
//     songGroup?.length);
//   });
//   player.setAudioSource(
//       ConcatenatingAudioSource(children: audSource)
//   );
// }
