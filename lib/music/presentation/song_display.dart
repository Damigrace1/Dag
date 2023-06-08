import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dag/provider/color.dart';
import 'package:dag/utils/custom_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
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
class _SongDisplayState extends State<SongDisplay> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    mounted && !context.read<MusicProvider>().
  inSession ? loadM(context, context.read<MusicProvider>().
    dispSong) :{};
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
              centerTitle: true,
              title:  Text('Music',style: CustomTextStyle(
                  color: color.origWhite,
                  fontSize: 18.sp
              ),),
              backgroundColor: color.scaffoldCol,
              actions: [
                IconButton(onPressed: (){}, icon:
                Icon(Icons.more_vert,color:color.origWhite,))
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
                  imageUrl: music.dispSong['image'].toString(),
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
                    child: Text(music.dispSong['title'],
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyle(
                      color: color.origWhite,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600
                    ),),
                  ),
                  Padding(
                    padding:EdgeInsets.symmetric(horizontal: 15.w),
                    child: Text(
                      formatTit(music.dispSong['more_info']['singers']),
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
                          onSeek: (duration) {
                            player.seek(duration);
                          },
                        ),
                      ),
                      // Padding(
                      //   padding:  EdgeInsets.symmetric(
                      //     horizontal: 22.w
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(music.startV,style: CustomTextStyle(
                      //         color: color.origWhite,fontSize: 14.sp
                      //       ),),
                      //       Text(music.endV,style: CustomTextStyle(
                      //           color: Colors.grey, fontSize: 14.sp
                      //       ),),
                      //     ],
                      //   ),
                      // ),

                      Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(onPressed: (){
                            player.setLoopMode(LoopMode.one);
                          }, icon:
                          Icon(Icons.repeat_one_sharp,)),
                          Row(
                            children: [
                              IconButton(onPressed: (){}, icon:
                              Icon(Icons.skip_previous,)),
                              music.loading ?
                                  const CircularProgressIndicator.
                                  adaptive() :
                              AvatarGlow(
                                glowColor: Colors.blue,
                                endRadius: 32.r,
                                duration: Duration(milliseconds: 2000),
                                repeat: true,
                                animate: !music.play,
                                showTwoGlows: true,
                                repeatPauseDuration: Duration(milliseconds: 100),
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
                                      color: color.scaffoldCol,) :
                                      Icon(Icons.play_arrow,
                                        color: color.scaffoldCol,),
                                ),)
                              ),
                              IconButton(onPressed: (){}, icon:
                              Icon(Icons.skip_next,)),
                            ],
                          ),
                          IconButton(onPressed: (){}, icon:
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
