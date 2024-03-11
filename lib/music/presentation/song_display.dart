import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dag/controllers/fav_box.dart';
import 'package:dag/controllers/music_operations.dart';
import 'package:dag/controllers/rebuilders.dart';
import 'package:dag/main.dart';
import 'package:dag/music/data/hive_store.dart';
import 'package:dag/music/domain/song_model.dart';
import 'package:dag/provider/color.dart';
import 'package:dag/utils/custom_textstyles.dart';
import 'package:dag/value_notifiers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palette_generator/palette_generator.dart' as pa;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../nav screens/search/presentation/search_music.dart';
import '../../provider/music.dart';
import '../../utils/enums.dart';
import '../../utils/functions.dart';

class SongDisplay extends StatefulWidget {
  const SongDisplay({Key? key}) : super(key: key);
  @override
  State<SongDisplay> createState() => _SongDisplayState();
}

late AudioPlayer player;
StreamSubscription? positStream;
StreamSubscription? bufStream;
Color? backColor;

class _SongDisplayState extends State<SongDisplay>
    with SingleTickerProviderStateMixin {
  late FlutterGifController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = FlutterGifController(vsync: this);
    // if (mounted & !context.read<MusicProvider>().inSession) {
    //   Future.delayed(Duration.zero, () {
    //     MusicOperations()
    //         .playSong(index: context.read<MusicProvider>().songIndex);
    //     // if (context.read<MusicProvider>().musicModelGroup!.length == 1)
    //     //   MusicOperations().loadPlayGroup();
    //   });
    // }
    // MusicOperations.favMusicChecker(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
    //positStream?.cancel();
  }

  colManip(Color col) {
    print(col.alpha);
    print(col.red);
    print(col.blue);
    print(col.green);
  }

  colorChecker() async{
    print(await Permission.storage.isGranted);
  }

  @override
  Widget build(BuildContext context) {
    colorChecker();
    return Consumer2<ColorProvider, MusicProvider>(
        builder: (context, color, music, child) {
      return Scaffold(
        backgroundColor: color.songWidgetColor,
        appBar: AppBar(
          backgroundColor: color.songWidgetColor,

          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: color.origWhite,
              size: 30.sp,
            ),
          ),
          title: Text(
            'Music',
            style: CustomTextStyle(color: color.origWhite, fontSize: 18.sp),
          ),
          actions: [
            if(!music.isLocalPlay)
              IconButton(
                  onPressed: () {
                    if (music.isLocalPlay){
                      showToast('You cannot add a Local music to favourites');
                    }
                    else{
                      if (music.isFav) {
                        FavBox.removeFromFavourite(context
                            .read<MusicProvider>()
                            .favSongs[music.songIndex]
                            .id!);
                        music.isFav = false;
                        rebuildLibraryPage();
                        setState(() {});
                      }
                      else {
                        music.isFav = true;
                        MusicOperations().saveToFavourites(
                            context,
                            music
                                .musicModelGroup![music.songIndex]);
                      }
                    }
                  },
                  icon: music.isFav
                      ? Icon(
                    Icons.favorite_outlined,
                    color: color.primaryCol,
                  )
                      : Icon(
                    Icons.favorite_outline,
                    color:
                    !music.isLocalPlay ?
                    color.primaryCol : Colors.grey,
                  )),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    music.musicModelGroup![music.songIndex].title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: CustomTextStyle(
                        color: color.origWhite,
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    music.musicModelGroup![music.songIndex].author ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),

              Expanded(
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                  imageUrl:
                      music.musicModelGroup?[music.songIndex].imgUrl ?? '',
                  errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: color.blackAcc),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset('images/mus_pla.jpg')),
                  imageBuilder: (context, imageProvider) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: imageProvider,
                          centerSlice: const Rect.fromLTRB(1, 1, 1, 1),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProgressBar(
                    progress: music.sV,
                    buffered: music.bV,
                    total: music.endV,
                    progressBarColor: color.primaryCol,
                    baseBarColor: Colors.grey.withOpacity(0.24),
                    bufferedBarColor: Colors.grey,
                    thumbColor: Colors.white,
                    barHeight: 6.0.h,
                    timeLabelTextStyle:
                        CustomTextStyle(fontSize: 14.sp, color: Colors.grey),
                    thumbRadius: 11.0.r,
                    onSeek: (duration) async {
                      music.loading = true;
                      await player.seek(duration);
                      music.loading = false;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            if (music.loopMode == PlayMode.all) {
                              player.setLoopMode(LoopMode.one);
                              music.loopMode = PlayMode.one;
                              setState(() {});
                            } else {
                              music.loopMode = PlayMode.all;
                              player.setLoopMode(LoopMode.all);
                              setState(() {});
                            }
                          },
                          icon: music.loopMode == PlayMode.all
                              ? const Icon(
                                  Icons.repeat_one_sharp,
                                )
                              : const Icon(
                                  Icons.repeat,
                                )),
                      Row(
                        children: [
                          music.isLocalPlay
                              ? player.hasPrevious
                                  ? IconButton(
                                      onPressed: () async {
                                        MusicOperations().previousSong();
                                      },
                                      icon: Icon(
                                        Icons.skip_previous,
                                      ))
                                  : const IconButton(
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.skip_previous,
                                        color: Colors.grey,
                                      ),
                                    )
                              : context.read<MusicProvider>().songIndex > 0
                                  ? IconButton(
                                      onPressed: () async {
                                        MusicOperations().previousSong();
                                      },
                                      icon: Icon(
                                        Icons.skip_previous,
                                      ))
                                  : const IconButton(
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.skip_previous,
                                        color: Colors.grey,
                                      ),
                                    ),
                          music.loading
                              ? const CircularProgressIndicator.adaptive()
                              : AvatarGlow(
                                  glowColor: color.primaryCol,
                                  endRadius: 32.r,
                                  duration: Duration(milliseconds: 2000),
                                  repeat: true,
                                  animate: !music.play,
                                  showTwoGlows: true,
                                  repeatPauseDuration:
                                      Duration(milliseconds: 200),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 18.r,
                                    child: InkWell(
                                      onTap: () async {
                                        music.play = !music.play;
                                        if (!music.play) {
                                          player.pause();
                                        } else {
                                          player.play();
                                        }
                                      },
                                      child: music.play
                                          ? Icon(
                                              Icons.pause,
                                              color: Colors.black,
                                            )
                                          : Icon(
                                              Icons.play_arrow,
                                              color: Colors.black,
                                            ),
                                    ),
                                  )),
                          music.isLocalPlay
                              ? player.hasNext
                                  ? IconButton(
                                      onPressed: () async {
                                        MusicOperations().nextSong();
                                      },
                                      icon: Icon(
                                        Icons.skip_next,
                                      ))
                                  : const IconButton(
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.skip_next,
                                        color: Colors.grey,
                                      ),
                                    )
                              : context.read<MusicProvider>().songIndex <
                                      context
                                              .read<MusicProvider>()
                                              .musicModelGroup!
                                              .length -
                                          1
                                  ? IconButton(
                                      onPressed: () {
                                        MusicOperations().nextSong();
                                      },
                                      icon: Icon(
                                        Icons.skip_next,
                                      ))
                                  : const IconButton(
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.skip_next,
                                        color: Colors.grey,
                                      ),
                                    ),

                        ],
                      ),
SizedBox()
                      // Container(
                      //   // padding: EdgeInsets.symmetric(
                      //   //   horizontal: 15.w,
                      //   //   vertical: 3.h
                      //   // ),
                      //   margin: EdgeInsets.symmetric(
                      //     horizontal: 15.w,
                      //   ),
                      //   // decoration: BoxDecoration(
                      //   //   borderRadius: BorderRadius.circular(5.r),
                      //   //   color: color.primaryCol.withOpacity(0.2)
                      //   // ),
                      //   child: InkWell(onTap: ()async{
                      //     showPersistentSnackbar(context, 'message');
                      //     String url = await MusicOperations().getUrl(music.musicModelGroup![music.songIndex].id??'');
                      //     if(music.dlVal == 0){
                      //       downloadSong(context,music.musicModelGroup![music.songIndex].title!,url);
                      //
                      //     } else {
                      //       showToast( 'Download already in progress');
                      //     };
                      //   }, child:
                      //   Icon(Icons.download,color: color.primaryCol,)),
                      // ),




                      ///
                      // else
                      //   IconButton(
                      //       onPressed: () {
                      //         //    showToast('This feature is coming soon.');
                      //       },
                      //       icon: Icon(
                      //         Icons.playlist_add,
                      //         color: Colors.grey,
                      //       )

                      //TODO: downoad disabled due to youtube video sharing terms
                      // IconButton(onPressed: (){
                      //   music.dlVal == 0 ?{
                      //   downloadSong(),
                      //     showPersistentSnackbar(context, 'message'),
                      //   }
                      //       :
                      //   {
                      //
                      //     showToast(context,
                      //     'Download already in progress')
                      //   };
                      // }, icon:
                      // Icon(Icons.download)),
                      //    )
                    ],
                  ),
                ],
              ),

              // Flexible(
              //     child: SizedBox(
              //   height: 5.h,
              // )),
            ],
          ),
        ),
      );
    });
  }
}
