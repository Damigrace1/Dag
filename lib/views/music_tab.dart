import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dag/controllers/local_media.dart';
import 'package:dag/music/presentation/homescreen.dart';
import 'package:dag/provider/music.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../controllers/music_operations.dart';
import '../models/music_model.dart';
import '../music/presentation/song_display.dart';
import '../utils/functions.dart';
import '../utils/global_declarations.dart';
import '../utils/no_res.dart';
import 'local_player.dart';
import '../provider/color.dart';
import '../utils/custom_textstyles.dart';



int songsBufferSize = 10;
int loadedSongs = 0;
class MusicTab extends StatefulWidget {
  MusicTab({Key? key}) : super(key: key);

  @override
  State<MusicTab> createState() => _MusicTabState();
}

class _MusicTabState extends State<MusicTab> with SingleTickerProviderStateMixin{

  ScrollController _scrollController = ScrollController();

 late FlutterGifController controller;


 _scrollListener()
 {
   if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
   //  loadBuffer();
   }
 }

  //List<SongModel>? localMusic = [];
 loadSongs()async{
   context.read<MusicProvider>().localMusicList =
   await LocalMedia().fetchLocalSongs();

 }
@override
  void initState() {
    // TODO: implement initState
  controller = FlutterGifController(vsync: this);
  loadSongs();
  // _scrollController.addListener(
  //   _scrollListener
  // );
  super.initState();
 //   Future.delayed(Duration.zero,()=>loadBuffer());
  }


  @override
  Widget build(BuildContext context) {
    return Consumer< MusicProvider>(
        builder: (context, music,child) {
          return
            //localMusic != null  ?

              music.localMusicList.isEmpty ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [SizedBox(height: 20.h,),
                      Text('No music found',style: CustomTextStyle(color: Colors.white,),),
                      TextButton(onPressed: (){
                        setState(() {

                        });
                       // localMusic = null;
                        loadSongs();
                      }, child: Text('Reload Music Library'))
                    ],
                  )
                  :
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 30.h),
              controller: _scrollController,
              itemCount: music.localMusicList.length,
              itemBuilder: (BuildContext ctx, int index) {
                //  firstLoading = true;
                return Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: ListTile(
                        leading:  SizedBox(
                          width: 50.w,
                          child:
                          Icon(
                            CupertinoIcons.music_mic,
                            color: Colors.grey,
                          ),
                        ),
                        title: Text(
                          music.localMusicList![index]
                              .title ??'',
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyle(
                              fontSize: 15.sp, color: Colors.white),
                        ),
                        subtitle: Text(music.localMusicList![index]
                            .composer ?? music.localMusicList![index]
                            .artist?? 'Unknown ',
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13.sp,
                              color: Colors.grey),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () async {},
                                icon: Icon(
                                  Icons.more_vert,
                                  size: 25.sp,
                                  color: context
                                      .read<ColorProvider>()
                                      .origWhite,
                                )),
                          ],
                        ),
                        onTap: () async {
                          context.read<MusicProvider>().isLocalPlay = true;
                          int ind = music.localMusicList.indexOf((music.localMusicList[index]));
                          loadMusic(ind);
                        }));
              },
            );
              //:
           // Column(
           //   mainAxisAlignment: MainAxisAlignment.center,
           //   children: [
           //     SizedBox(height: 200.h,),
           //     const CircularProgressIndicator.adaptive(),
           //     SizedBox(height: 10.h,),
           //     Text('Fetching songs from your library...',style: CustomTextStyle(color:
           //     Colors.white70),)
           //   ],
           // );

  });
}}
//
// void loadBuffer(){
//   homeKey.currentContext!.read<MusicProvider>().localMusicList = localMusic;
//   if(loadedSongs  < localMusic.length){
//     BuildContext context = homeKey.currentContext!;
//     if(localMusic.length < 10){
//       context.read<MusicProvider>().localMusicList = localMusic;
//     }
//     else{
//       print('buffering');
//       context.read<MusicProvider>().localMusicList.addAll(localMusic.sublist(loadedSongs,loadedSongs+songsBufferSize));
//       loadedSongs+=songsBufferSize;
//       print(context.read<MusicProvider>().localMusicList.length);
//     }
//   }
// }
