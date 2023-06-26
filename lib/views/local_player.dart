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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io';
import '../controllers/local_media.dart';
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

void checkLocalMusicLoadState() async {
  while (localMedia.isEmpty) {
    await Future.delayed(Duration(seconds: 1));
  }
  print(localMedia.length);
  Future.delayed(Duration.zero,(){
    homeKey.currentContext!.read<MusicProvider>().localMusicList =  localMusic;
    homeKey.currentContext!.read<MusicProvider>().localVideoList =  localVideo;
  });

  // setState(() {});
}
class _LocalPlayerState extends State<LocalPlayer> with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
late TabController tabController;

@override
  void dispose() {
    // TODO: implement dispose
  tabController.dispose();
  scrollController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    checkLocalMusicLoadState();
    tabController =TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.read<ColorProvider>().blackAcc,
        title: Center(
          child: Stack(
            children: [
              Container(
                width: 339.w,
                height: 50.h,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 10, color: context.read<ColorProvider>().blackAcc),
                  borderRadius: BorderRadius.circular(5.w),
                ),
              ),
              Positioned.fill(
                  child: Row(
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: TextField(
                      autofocus: false,
                      onChanged: (val) {
                        print(val);
                        if (val.length == 0) {
                          context.read<MusicProvider>().localVideoList = localVideo;
                          context.read<MusicProvider>().localMusicList = localMusic;
                        }
                       else{
                          tabController.index == 0 ?
                          LocalMedia().searchMusic(val) :
                          LocalMedia().searchVideo(val);
                        }

                      },
                      readOnly: false,
                      style: CustomTextStyle(color: Colors.white),
                      controller: localMediaSearchCont,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Start searching',
                          hintStyle: CustomTextStyle(
                            color: Colors.grey,
                          )),
                    ),
                  ),
                  Consumer<MusicProvider>(builder: (context, music, child) {
                    return AvatarGlow(
                        glowColor: Colors.green,
                        endRadius: 20.r,
                        duration: Duration(milliseconds: 2000),
                        repeat: true,
                        animate: music.rec,
                        showTwoGlows: true,
                        repeatPauseDuration: Duration(milliseconds: 100),
                        child: CircleAvatar(
                          radius: 15.r,
                          backgroundColor: Colors.grey,
                          child: InkWell(
                              onTap: () async {},
                              child: Icon(
                                Icons.mic,
                                size: 20.sp,
                              )),
                        ));
                  }),
                  IconButton(
                    onPressed: () {
                      localMediaSearchCont.clear();
                      context.read<MusicProvider>().localVideoList = localVideo;
                    },
                    icon: Icon(Icons.clear, color: Colors.grey),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                ],
              ))
            ],
          ),
        ),
        centerTitle: true,
        leadingWidth: 0,
        titleSpacing: 0,
      ),
      backgroundColor: Colors.black,
      persistentFooterButtons: [
        Consumer<MusicProvider>(builder: (context, music, child) {
          if (music.isPlaying) {
            return const SongWidget();
          } else {
            return const SizedBox();
          }
        })
      ],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TabBar(
                    controller: tabController,
                    indicatorWeight: 3,
                      dividerColor:Colors.grey,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: context.read<ColorProvider>().primaryCol.withAlpha(250),
                      indicatorColor: context.read<ColorProvider>().primaryCol.withAlpha(250),
                      tabs: [
                        Tab(text: 'Music'),
                    Tab(text: 'Videos'),

                  ]),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                        children: [
                      MusicTab(),
                      VideoTab()]),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
