import 'dart:ui';

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

import '../../controllers/music_operations.dart';
import '../../utils/custom_textstyles.dart';
import '../domain/song_model.dart';

class SongWidget extends StatefulWidget {
  const SongWidget({Key? key}) : super(key: key);

  @override
  State<SongWidget> createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  Color? backColor;
  bool isLoadedImageProvider = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorProvider, MusicProvider>(
        builder: (context, color, music, child) {
      return Hero(
        tag: 'hero',
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 7.w),
          color: Colors.black,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                color: color.songWidgetColor,
                // shadowColor: Colors.red,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        music.musicModelGroup?[music.songIndex].title ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        music.musicModelGroup?[music.songIndex].author ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14.sp,
                            color: Colors.white),
                      ),
                      trailing: music.loading
                          ?
                          // CachedNetworkImage(
                          //   fit: BoxFit.fill,
                          //   width: 0,
                          //   height: 0,
                          //   imageUrl: music.musicModelGroup?[music.songIndex].imgUrl ?? '',
                          //   errorWidget: (context, url, error) => Container(
                          //       decoration: BoxDecoration(
                          //         border: Border.all(color: color.blackAcc),
                          //         borderRadius: BorderRadius.circular(12),
                          //       ),
                          //       child: Image.asset('images/mus_pla.jpg')),
                          //   imageBuilder: (context, imageProvider) {
                          //     getImagePalette(imageProvider);
                          //     return   DecoratedBox(
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(12),
                          //         image: DecorationImage(
                          //           fit: BoxFit.fill,
                          //           image: imageProvider,
                          //           centerSlice: const Rect.fromLTRB(1, 1, 1, 1),
                          //         ),
                          //       ),
                          //     );},
                          // ):
                          const CircularProgressIndicator.adaptive()
                          : SizedBox(
                              width: 165.w,
                              child: Row(
                                children: [
                                  music.isLocalPlay
                                      ? player.hasPrevious
                                          ? IconButton(
                                              onPressed: () async {
                                                MusicOperations()
                                                    .previousSong();
                                              },
                                              icon: Icon(
                                                Icons.skip_previous,
                                                color: Colors.white,
                                              ))
                                          : const IconButton(
                                              onPressed: null,
                                              icon: Icon(
                                                Icons.skip_previous,
                                                color: Colors.grey,
                                              ),
                                            )
                                      : context
                                                  .read<MusicProvider>()
                                                  .songIndex >
                                              0
                                          ? IconButton(
                                              onPressed: () async {
                                                MusicOperations()
                                                    .previousSong();
                                              },
                                              icon: Icon(
                                                Icons.skip_previous,
                                                color: Colors.white,
                                              ))
                                          : const IconButton(
                                              onPressed: null,
                                              icon: Icon(
                                                Icons.skip_previous,
                                                color: Colors.grey,
                                              ),
                                            ),
                                  music.loading
                                      ? const CircularProgressIndicator
                                          .adaptive()
                                      : AvatarGlow(
                                          glowColor: color.primaryCol,
                                          endRadius: 32.r,
                                          duration:
                                              Duration(milliseconds: 2000),
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
                                                color: Colors.white,
                                              ))
                                          : const IconButton(
                                              onPressed: null,
                                              icon: Icon(
                                                Icons.skip_next,
                                                color: Colors.grey,
                                              ),
                                            )
                                      : context
                                                  .read<MusicProvider>()
                                                  .songIndex <
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
                                                color: Colors.white,
                                              ))
                                          : const IconButton(
                                              onPressed: null,
                                              icon: Icon(
                                                Icons.skip_next,
                                                color: Colors.grey,
                                              ),
                                            )
                                ],
                              ),
                            ),
                      onTap: () {
                        Get.to(() => const SongDisplay());
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: ProgressBar(
                        progress: music.sV,
                        buffered: music.bV,
                        total: music.endV,
                        progressBarColor: color.primaryCol,
                        baseBarColor: Colors.grey.withOpacity(0.24),
                        bufferedBarColor: Colors.grey,
                        thumbColor: Colors.white,
                        barHeight: 3.0.h,
                        timeLabelTextStyle: CustomTextStyle(
                            fontSize: 12.sp, color: Colors.grey),
                        thumbRadius: 5.0.r,
                        onSeek: (duration) {
                          player.seek(duration);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
