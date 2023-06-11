import 'dart:async';
import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dag/main.dart';
import 'package:dag/music/data/hive_store.dart';
import 'package:dag/music/domain/song_model.dart';
import 'package:dag/provider/color.dart';
import 'package:dag/utils/custom_textstyles.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../nav screens/search/presentation/search_music.dart';
import '../../provider/music.dart';
import '../../utils/functions.dart';
class SongDisplay extends StatefulWidget {
   const SongDisplay({Key? key}) : super(key: key);
  @override
  State<SongDisplay> createState() => _SongDisplayState();
}
final player = AudioPlayer();
StreamSubscription? positStream;
StreamSubscription? bufStream;
class _SongDisplayState extends State<SongDisplay> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    mounted && !context.read<MusicProvider>().
  inSession ? Future.delayed(Duration.zero,(){
    loadM();}) :{};
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //positStream?.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorProvider,MusicProvider>(
        builder: (context,color,music,child){
          return Scaffold(
            backgroundColor: color.scaffoldCol,
            appBar: AppBar(
              leading: IconButton(
                onPressed: (){
                  Get.back();
                },
                icon: Icon(Icons.keyboard_arrow_left,
                color: color.origWhite,),
              ),
              title:  Text('Music',style: CustomTextStyle(
                  color: color.origWhite,
                  fontSize: 18.sp
              ),),
              backgroundColor: color.scaffoldCol,
              actions: [

                IconButton(onPressed: (){
                 // favBox!.add('id' , music.song?.id);
                  var fav = Favourite()
                      ..id = music.songGroup
                      ![music.songIndex].id!
                      ..songUrl =music.songGroup!
                      [music.songIndex].songUrl!
                      ..title = music.songGroup!
                      [music.songIndex].title!
                      ..imgUrl =music.songGroup![
                        music.songIndex].imgUrl!
                      ..artiste = music.songGroup!
                      [music.songIndex].artiste!;
                  favBox?.put(music.songGroup![
                    music.songIndex].id!,fav);
                  showToast(context, 'Music added to Favourites');

                }, icon:
                Icon(Icons.favorite_border,color:color.origWhite,))
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                SizedBox(height: 20.h,),
                CachedNetworkImage(
                  width: 250.w,
                  height: 300.h,
                  imageUrl: music.songGroup![music
                      .songIndex].imgUrl!??'',
                  errorWidget: (context, url, error)=>Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: color.blackAcc),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset('images/mus_pla.jpg')),
                  imageBuilder: (context, imageProvider) => DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: imageProvider,
                        centerSlice: const Rect.fromLTRB(1, 1, 1, 1),
                      ),
                    ),
                  ),
                ),
                  Padding(
                    padding:EdgeInsets.symmetric(horizontal: 15.w),
                    child: Text(music.songGroup![
                      music.songIndex].title!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyle(
                      color: color.origWhite,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600
                    ),),
                  ),
                  Padding(
                    padding:EdgeInsets.symmetric(horizontal: 15.w),
                    child: Text(
                      music.songGroup![music.
                      songIndex].artiste!,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300
                    ),),
                  ),
                  Flexible(child: SizedBox(height: 20.h,)),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Slider(
                      //   activeColor: color.primaryCol,
                      //     inactiveColor: Colors.grey,
                      //     secondaryActiveColor: Colors.yellow,
                      //     value: music.sV,
                      //     onChanged: (v){
                      //       music.sV = v;
                      // }),
                      Padding(
                        padding:EdgeInsets.symmetric(horizontal: 15.w),
                        child: ProgressBar(
                          progress: music.sV,
                          buffered: music.bV,
                          total: music.endV,
                          progressBarColor: color.primaryCol,
                          baseBarColor: Colors.grey.withOpacity(0.24),
                          bufferedBarColor: Colors.grey,
                          thumbColor: Colors.white,
                          barHeight: 6.0.h,
                          timeLabelTextStyle: CustomTextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey
                          ),
                          thumbRadius: 11.0.r,
                          onSeek: (duration)async {
                            music.loading = true;
                       await  player.seek(duration);
                       music.loading = false;
                          },
                        ),
                      ),

                      Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(onPressed: (){
                            if(music.loopMode == 0) {
                              player.setLoopMode(LoopMode.one);
                              music.loopMode = 1;
                              setState(() {});
                            }

                            else{
                              music.loopMode = 0;
                              player.setLoopMode(LoopMode.all);
                              setState(() {});
                            }
                          }, icon:
                          music.loopMode == 0 ?
                          const Icon(Icons.repeat_one_sharp,) :
                              const Icon(Icons.repeat,)
                          ),
                          Row(
                            children: [
                              player.hasPrevious?
                              IconButton(

                                  onPressed: ()async{
                                music.loading = true;
                                await  player.seekToPrevious();
                                music.loading = false;
                              }, icon:
                              Icon(Icons.skip_previous,)) :
                              const IconButton(
                                onPressed: null,
                                icon: Icon(Icons.skip_previous,
                                  color:  Colors.grey,),
                              ),
                              music.loading ?
                                  const CircularProgressIndicator.
                                  adaptive() :
                              AvatarGlow(
                                glowColor: color.primaryCol,
                                endRadius: 32.r,
                                duration: Duration(milliseconds: 2000),
                                repeat: true,
                                animate: !music.play,
                                showTwoGlows: true,
                                repeatPauseDuration: Duration(milliseconds: 200),
                                child: CircleAvatar(
                                  backgroundColor: color.primaryCol,
                                  radius: 18.r,
                                  child: InkWell(
                                      onTap:()async{

                                          music.play = !music.play;
                                          if(!music.play){
                                            player.pause();
                                          }
                                          else{
                                            player.play();}
                                        },
                                      child: music.play  ? Icon(Icons.pause,
                                      color: Colors.white,) :
                                      Icon(Icons.play_arrow,
                                        color: Colors.white,),
                                ),)
                              ),
                              player.hasNext ? IconButton(onPressed: ()async{
                                music.loading = true;
                                await  player.seekToNext();
                                music.loading = false;
                              }, icon:
                              Icon(Icons.skip_next,)) :
                              const IconButton(
                                onPressed: null,
                                icon: Icon(Icons.skip_next,color:
                                  Colors.grey,),
                              )
                            ],
                          ),
                          IconButton(onPressed: (){
                            music.dlVal == 0 ?{
                            downloadSong(),
                              showPersistentSnackbar(context, 'message'),
                            }
                                :
                            {

                              showToast(context,
                              'Download already in progress')
                            };
                          }, icon:
                          Icon(Icons.download)),
                        ],
                      ),
                    ],
                  ),
                  Flexible(child: SizedBox(height: 5.h,)),
              ],),
            ),
            // bottomSheet: Container(
            //  decoration: BoxDecoration(
            //    color: Colors.black87,
            //    borderRadius: BorderRadius.only(
            //      topRight: Radius.circular(20.w),
            //        topLeft: Radius.circular(20.w)
            //    )
            //  ),
            //   height: 150.h,
            //   child: Center(child:
            //     Column(children: [
            //
            //     ],),),
            // ),
          );
        }
    );
  }
}
