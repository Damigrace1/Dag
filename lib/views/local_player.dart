import 'dart:typed_data';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dag/configs/permission.dart';
import 'package:dag/music/presentation/homescreen.dart';
import 'package:dag/music/presentation/song_display.dart';
import 'package:dag/views/video_play.dart';
import 'package:dag/views/video_tab.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io';
import '../controllers/local_media.dart';
import '../main.dart';
import '../music/presentation/song_widget.dart';
import '../provider/color.dart';
import '../provider/music.dart';
import '../utils/custom_textstyles.dart';
import '../utils/functions.dart';
import '../utils/global_declarations.dart';
import 'errorWidget.dart';
import 'music_tab.dart';

class LocalPlayer extends StatefulWidget {
  const LocalPlayer({Key? key}) : super(key: key);

  @override
  State<LocalPlayer> createState() => _LocalPlayerState();
}

TextEditingController localMediaSearchCont = TextEditingController();

// void checkLocalMusicLoadState() async {
//   while (localMedia.isEmpty) {
//     await Future.delayed(Duration(seconds: 1));
//   }
//   Future.delayed(Duration.zero,(){
//     homeKey.currentContext!.read<MusicProvider>().localMusicList =  localMusic;
//    // homeKey.currentContext!.read<MusicProvider>().localVideoList =  localVideo;
//   });
//
//   // setState(() {});
// }
class _LocalPlayerState extends State<LocalPlayer> with SingleTickerProviderStateMixin {

@override
  void dispose() {
    // TODO: implement dispose
  localMediaSearchCont.clear();
    super.dispose();
  }

void listenTo(TextEditingController controller) {
  showToast('Speak to search now');
  context.read<MusicProvider>().rec = true;
  stt.listen(
      onResult: (res) => {
        if (res.finalResult)
          {
            print(res.recognizedWords),
            controller.text = res.recognizedWords,
            setState(() {})
          }
      },
      listenMode: ListenMode.dictation);
  context.read<MusicProvider>().rec = false;
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();}
ScrollController _scrollController2 = ScrollController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: NestedScrollView(
          controller: _scrollController2,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled)
          {
            return [
              SliverAppBar(
                backgroundColor: Colors.black,
                title: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      SizedBox(
                        height: 45.h,
                        width: 340.w,
                        child: TextFormField(
                          autofocus: false,
                          onChanged: (val) {
                            if (val.length == 0) {
                              //  context.read<MusicProvider>().localVideoList = localVideo;
                              context.read<MusicProvider>().localMusicList;
                            }
                            else{
                              //tabController.index == 0 ?
                              LocalMedia().searchMusic(val) ;
                              //  LocalMedia().searchVideo(val);
                            }

                          },
                          readOnly: false,
                          style: CustomTextStyle(color: Colors.white),
                          controller: localMediaSearchCont,
                          decoration: InputDecoration(
                              hintText: 'Start searching',
                              hintStyle: CustomTextStyle(
                                color: Colors.grey,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.white54,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: context.read<ColorProvider>().primaryCol,
                                ),
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Consumer<MusicProvider>(
                                      builder: (context, music, child) {
                                        return AvatarGlow(
                                            glowColor: Colors.green,
                                            endRadius: 20.r,
                                            duration: Duration(milliseconds: 2000),
                                            repeat: true,
                                            animate: music.rec,
                                            showTwoGlows: true,
                                            repeatPauseDuration: Duration(milliseconds: 100),
                                            child: InkWell(
                                                onTap: () async {
                                                  listenTo(localMediaSearchCont);
                                                },
                                                child: Icon(
                                                  Icons.mic,
                                                  color: Colors.green,
                                                  size: 20.sp,
                                                )));
                                      }),
                                ],
                              )
                          ),

                        ),
                      ),

                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                  ),
                ),
                floating: true,
                centerTitle: true,
                leadingWidth: 0,
                titleSpacing: 0,
                snap: true,
              )
            ];

          },
          body: SingleChildScrollView(

            child: MusicTab(),
          ),
        )
      ),
    );
  }
}
