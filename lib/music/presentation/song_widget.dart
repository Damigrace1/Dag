import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dag/music/presentation/song_display.dart';
import 'package:dag/provider/color.dart';
import 'package:dag/provider/music.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../utils/custom_textstyles.dart';
import '../domain/song_model.dart';
class SongWidget extends StatelessWidget {
  const SongWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorProvider, MusicProvider>(
        builder: (context, color, music,child) {
          return Card(
            color: color.scaffoldCol,
            child: Column(
              mainAxisSize:MainAxisSize.min ,
              children: [
                ListTile(
                leading: CachedNetworkImage(
                  width: 50.w,
                  height: 50.h,
                  imageUrl:  music.songGroup!
                  [music.songIndex].songUrl!,
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
                title: Text(
                  music.songGroup![music.
                  songIndex].title!,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyle(
                      color: Colors.white
                  ),),
                subtitle: Text(
                  music.songGroup![music.
                  songIndex].artiste!,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14.sp,
                      color: Colors.grey
                  ),),
                trailing: AvatarGlow(
                    glowColor: color.primaryCol,
                    endRadius: 35.r,
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
                        child: music.play ? Icon(Icons.pause,
                          color: color.scaffoldCol,) :
                        Icon(Icons.play_arrow,
                          color: color.scaffoldCol,),
                      ),)
                ),
                onTap: (){
                  Get.to(()=>const SongDisplay());
                },
              ),
                ProgressBar(
                  progress: music.sV,
                  buffered: music.bV,
                  total: music.endV,
                  progressBarColor: color.primaryCol,
                  baseBarColor: Colors.grey.withOpacity(0.24),
                  bufferedBarColor: Colors.grey,
                  thumbColor: Colors.white,
                  barHeight: 3.0.h,
                  timeLabelTextStyle: CustomTextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey
                  ),
                  thumbRadius: 5.0.r,
                  onSeek: (duration) {
                    player.seek(duration);
                  },
                )
            ],),
          );
        }
    );
  }
}
