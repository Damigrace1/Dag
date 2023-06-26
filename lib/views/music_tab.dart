import 'dart:typed_data';

import 'package:dag/controllers/local_media.dart';
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
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../models/music_model.dart';
import '../music/presentation/song_display.dart';
import '../utils/functions.dart';
import '../utils/global_declarations.dart';
import '../utils/no_res.dart';
import 'local_player.dart';
import '../provider/color.dart';
import '../utils/custom_textstyles.dart';

class MusicTab extends StatefulWidget {
  MusicTab({Key? key}) : super(key: key);

  @override
  State<MusicTab> createState() => _MusicTabState();
}

class _MusicTabState extends State<MusicTab> with SingleTickerProviderStateMixin{
  bool firstLoading = true;

 late FlutterGifController controller;
@override
  void initState() {
    // TODO: implement initState
  controller = FlutterGifController(vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20.h,
          ),
          context.watch<MusicProvider>().localMusicList.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      context.read<MusicProvider>().localMusicList.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    firstLoading = true;
                    return Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: ListTile(
                            leading: context
                                        .read<MusicProvider>()
                                        .localMusicList[index]
                                        .albumArt !=
                                    null
                                ? SizedBox(
                                    width: 50.w,
                                    child: Image.memory(context
                                        .read<MusicProvider>()
                                        .localMusicList[index]
                                        .albumArt!))
                                : SizedBox(
                                    width: 50.w,
                                    child: Icon(
                                      CupertinoIcons.music_mic,
                                      color: Colors.grey,
                                    ),
                                  ),
                            title: Text(
                              context
                                      .read<MusicProvider>()
                                      .localMusicList[index]
                                      .trackName ??
                                  context
                                      .read<MusicProvider>()
                                      .localMusicList[index]
                                      .filePath!
                                      .split('/')
                                      .last,
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyle(
                                  fontSize: 15.sp, color: Colors.white),
                            ),
                            subtitle: Text(context
                                          .read<MusicProvider>()
                                          .localMusicList[index]
                                          .trackArtistNames
                                          .toString() ==
                                      'null'
                                  ? 'Unknown '
                                  : context
                                      .read<MusicProvider>()
                                      .localMusicList[index]
                                      .trackArtistNames
                                      .toString(),
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
                              showLoader(controller, context);
                              List<MusicModel> musicModels = [];
                              localMusic.forEach((mus) {
                                musicModels.add(
                                  MusicModel(
                                      author: mus.authorName??'Unknown',
                                      title: context
                                          .read<MusicProvider>()
                                          .localMusicList[index]
                                          .trackName ??
                                          context
                                              .read<MusicProvider>()
                                              .localMusicList[index]
                                              .filePath!
                                              .split('/')
                                              .last,
                                      id: '',
                                     // imgUrl:'',
                                      duration: Duration(
                                        seconds: mus.trackDuration!
                                      )
                                  )
                                );
                              });
                              List<MusicModel> l1 = musicModels;
                              List<MusicModel> l3 = l1.sublist(index, l1.length);
                              List<MusicModel> l2 = l1.sublist(0, index);
                              context.read<MusicProvider>().musicModelGroup =
                              l3 + l2;
                              context.read<MusicProvider>().songIndex = index;
                              //  await MusicOperations().playSong();
                              context.read<MusicProvider>().isLocalPlay = true;


                              Get.to(()=>SongDisplay());
                            }));
                  },
                )
              : firstLoading ?
              Center(child: const CircularProgressIndicator.adaptive()) :
          NoResFound()
        ],
      ),
    );
  }
}


