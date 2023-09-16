import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'package:dag/music/presentation/homescreen.dart';
import 'package:dag/utils/global_declarations.dart';
import 'package:dag/views/local_player.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../configs/permission.dart';
import '../provider/music.dart';
import '../views/music_tab.dart';

class LocalMedia {
  List<File> playerFiles = [];
  List<Metadata> metaDataList = [];

 //  Future<List<Metadata>> getAudioFiles() async {
 //    await PermissionHandler().requestFileAccessPermission();
 //    Directory storageDirectory = Directory('/storage/emulated/0');
 // try{
 //   List<FileSystemEntity> entities = storageDirectory.listSync(followLinks: false);
 //   for (FileSystemEntity entity in entities) {
 //     if (entity is File) {
 //       loadMusic(entity);
 //     } else if (entity is Directory && !entity.path.contains('Android/data/')) {
 //       readFilesInDirectory(entity.path);
 //     }
 //   }
 //   for (File audioFile in playerFiles) {
 //     metaDataList.add(await getMetaData(audioFile));
 //   }
 // }
 // catch (e){throw e;}
 //    return metaDataList;
 //  }
  Future fetchLocalSongs() async {
    print('fetching');
    OnAudioQuery _audioQuery = OnAudioQuery();
    try{
   await _audioQuery.checkAndRequest(retryRequest: true);
  localMusic  = await _audioQuery.querySongs();
   Future.delayed(Duration.zero,()=> loadBuffer());
    }
    catch (e){throw e;}
  }
  // void loadMusic(FileSystemEntity file) {
  //   if (file is File &&
  //       (file.path.toLowerCase().endsWith('.m4a') ||
  //           file.path.toLowerCase().endsWith('.mp3') ||
  //           file.path.toLowerCase().endsWith('.mp4') ||
  //           file.path.toLowerCase().endsWith('.wav') ||
  //           file.path.toLowerCase().endsWith('.wma') ||
  //           file.path.toLowerCase().endsWith('.aac') ||
  //           file.path.toLowerCase().endsWith('.opus'))) {
  //     playerFiles.add(file);
  //   }
  // }
  //
  // void readFilesInDirectory(String path) {
  //   Directory directory = Directory(path);
  //   List<FileSystemEntity> files = directory.listSync();
  //   for (FileSystemEntity file in files) {
  //     if (file is File) {
  //       loadMusic(file);
  //     } else if (file is Directory && !file.path.contains('/storage/emulated/0/Android/')) {
  //       readFilesInDirectory(file.path);
  //     }
  //   }
  // }

  // Future<Metadata> getMetaData(File file) async {
  //   try {
  //     return await MetadataRetriever.fromFile(file);
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  // Future<Uint8List?> getThumbnail(String file) async {
  //   try {
  //     return await VideoThumbnail.thumbnailData(
  //       video: file,
  //       imageFormat: ImageFormat.PNG,
  //       quality: 100,
  //     );
  //   } catch (e) {
  //     throw e;
  //   }
  // }

   Future<List<SongModel>> searchMusic(String query) async{
    BuildContext context = homeKey.currentContext!;
   final result =  localMusic.where((music){
             String storedMusic = music.title.toLowerCase();
             return storedMusic.contains(query.toLowerCase());
           }).toList();
    context.read<MusicProvider>().localMusicList = result;
   return result;
  }

  // Future<List<Metadata>> searchVideo(String query) async{
  //   BuildContext context = homeKey.currentContext!;
  //   final result =  localVideo.where((video){
  //     String storedVideo = video.trackName?.toLowerCase()??video.filePath!.split('/').last.toLowerCase();
  //     return storedVideo.contains(query.toLowerCase());
  //   }).toList();
  //   context.read<MusicProvider>().localVideoList = result;
  //   return result;
  // }
}