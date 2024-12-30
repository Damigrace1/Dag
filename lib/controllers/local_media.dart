import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dag/music/presentation/homescreen.dart';
import 'package:dag/utils/global_declarations.dart';
import 'package:dag/views/local_player.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/api.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../configs/permission.dart';
import '../provider/music.dart';
import '../views/music_tab.dart';

class LocalMedia {
  List<File> playerFiles = [];

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

   final Directory appDocDir = await getApplicationDocumentsDirectory();

   final Directory hiddenDir = Directory('${appDocDir.path}/myHiddenDirectory');
  final l1  = await _audioQuery.querySongs();

 // final l2  = await _audioQuery.querySongs(path: '/data/user/0/com.white.boomfree/app_flutter/.myHiddenDirectory');

   // SongModel(
   //     {
   //       'id': -1,
   //       'isMusic': false,
   //       title: 'Unknown Title',
   //       artist: 'Unknown Artist',
   //       album: 'Unknown Album',
   //       filePath: entity.path,}
   // );
   // dir.list().toList().then((value) {
  //   MetadataRetriever.fromFile(File(value[1].absolute.path)).then((data){
  //     print(data.trackDuration);
  //   });
  // });
   List<SongModel> l2 = [];

 // List<FileSystemEntity> fileEntities = await hiddenDir.list(
 //  ).toList();
  // Metadata data = await MetadataGod.readMetadata(file:  fileEntities.first.path);
  //
  //     getExternalStorageDirectory().then((value) =>
  //         _audioQuery.querySongs(path: '/storage/emulated/0/Android/media/com.dag/dag/music').then((value) => print('llll:${value}'))
  //     )
  //     ;
   void decryptFile(Uint8List key, File encryptedFile, File decryptedFile) {
     final cipher = BlockCipher('AES')..init(false, KeyParameter(key));
     final encryptedBytes = encryptedFile.readAsBytesSync();
     final decryptedBytes = cipher.process(Uint8List.fromList(encryptedBytes));
     decryptedFile.writeAsBytesSync(decryptedBytes);
   }
  // Directory dir = Directory('/storage/emulated/0/Download/.dag');
  // print(dir.listSync());
   //_audioQuery.queryAllPath().then((value) => print('llll:${value}'));
      ///jj
//  await Future.forEach(fileEntities, (fileEntity)async {
//    try{
//      print('j');
//      //Metadata data = await MetadataRetriever.fromFile(f);
//      Metadata data = await MetadataGod.readMetadata(file:fileEntity.path);
//      print('hh:$data');
//      print('jk');
//      l2.add(SongModel({
//        "_data":fileEntity.path,
//        "composer": data.artist??data.albumArtist??"Unknown",
//        "title":data.title??data.album??fileEntity.path.split('/').last,
//        "_id":-1,
//        "duration":  data.duration??0
//      }));
//    }
//    catch (e){
//      print(e);
//    }
//  });

 // fileEntities.forEach((fileEntity)
 // async {
 //   Future.delayed(Duration(seconds: 2));
 //   Metadata data = await MetadataRetriever.fromFile(File(fileEntity.absolute.path));
 //    l2.add(SongModel({
 //      "_data":data.filePath,
 //      "_composer": data.authorName??data.writerName??data.trackArtistNames,
 //      "_title":data.trackName??data.albumName??data.filePath?.split('/').last,
 //      "_id":data.filePath,
 //      "_duration": Duration(milliseconds: data.trackDuration??0)
 //    }));
 // });
localMusic = l1+  l2;
  return localMusic;
  // Future.delayed(Duration.zero,()=> loadBuffer());
    }
    catch (e){
      throw e;
    }
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
  //     } else if (file is Directory && !file.path.contains('a)) {
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

   void searchMusic(String query) async{

    BuildContext context = homeKey.currentContext!;
    context.read<MusicProvider>().localMusicList  =
        localMusic.where((music){
             String storedMusic = music.title.toLowerCase();
             return storedMusic.contains(query.toLowerCase());
           }).toList();
    //localMusic = result;
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