import 'dart:async';

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
  final Map<String,dynamic> song;
   const SongDisplay({Key? key, required
   this.song}) : super(key: key);
  @override
  State<SongDisplay> createState() => _SongDisplayState();
}
final player = AudioPlayer();
class _SongDisplayState extends State<SongDisplay> {

StreamSubscription? positStream;
void loadM()async{
  final manifest = await yt.
  videos.streamsClient.
  getManifest(widget.song["ytid"]);
  final duration = await player.setUrl(
      manifest.audioOnly.withHighestBitrate().url.toString());
  context.read<MusicProvider>().endV =
      formatDur(duration!);
  int tot = calcTotDur(duration);
  context.read<MusicProvider>().play = true;
  context.read<MusicProvider>().loading = false;
  player.play();
  positStream = player.positionStream.listen((v) {
    context.read<MusicProvider>().startV = formatDur(v);
    int cur = calcTotDur(v);
    context.read<MusicProvider>().sV = cur/tot;
  });
}
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadM();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    positStream?.cancel();
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
                Text('Now playing',style: CustomTextStyle(
                  color: color.origWhite,
                  fontSize: 18.sp
                ),),
                Flexible(child: SizedBox(height: 20.h,)),
                CachedNetworkImage(
                  width: 250.w,
                  height: 300.h,
                  imageUrl: widget.song['image'].toString(),
                  errorWidget: (context, url, error)=>Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: color.origLightAsh),
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
                 // Flexible(child: SizedBox(height: 50.h)),
                  Padding(
                    padding:EdgeInsets.symmetric(horizontal: 15.w),
                    child: Text(widget.song['title'],
                      style: CustomTextStyle(
                      color: color.origWhite,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600
                    ),),
                  ),
                  Text(
                    
                    widget.song['more_info']['singers']
                        .toString()
                        .split('(')[0]
                        .replaceAll('&quot;', '"')
                        .replaceAll('&amp;', '&'),
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w300
                  ),),
                  Flexible(child: SizedBox(height: 20.h,)),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Slider(
                        activeColor: color.origOrange,
                          inactiveColor: Colors.grey,
                          secondaryActiveColor: Colors.yellow,
                          value: music.sV,
                          onChanged: (v){

                            music.sV = v;

                      }),
                      Padding(
                        padding:  EdgeInsets.symmetric(
                          horizontal: 22.w
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(music.startV,style: CustomTextStyle(
                              color: color.origWhite
                            ),),
                            Text(music.endV,style: CustomTextStyle(
                                color: Colors.grey
                            ),),
                          ],
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(onPressed: (){}, icon:
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
                                  backgroundColor: Colors.grey[100],
                                  radius: 14.r,
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
                              IconButton(onPressed: (){}, icon:
                              Icon(Icons.skip_previous,)),
                            ],
                          ),
                          IconButton(onPressed: (){}, icon:
                          Icon(Icons.download)),
                        ],
                      ),
                    ],
                  )
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
