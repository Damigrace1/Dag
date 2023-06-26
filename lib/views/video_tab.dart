import 'dart:io';

import 'package:dag/utils/no_res.dart';
import 'package:dag/views/video_play.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../provider/color.dart';
import '../provider/music.dart';
import '../utils/custom_textstyles.dart';
import '../utils/global_declarations.dart';
import 'local_player.dart';
class VideoTab extends StatelessWidget {
  const VideoTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20.h,
          ),
          // localMediaSearchCont.text != ''  ?
          // FutureBuilder(
          //   //future: fetchSongsList(searchCont.text),
          //   builder: (context, d) {
          //     if (d.connectionState == ConnectionState.done) {
          //       return d.data != null
          //           ? ListView.builder(
          //         shrinkWrap: true,
          //         addAutomaticKeepAlives: false,
          //         addRepaintBoundaries: false,
          //         physics: const NeverScrollableScrollPhysics(),
          //         //     itemCount: d.data?.length,
          //         itemBuilder: (BuildContext ctxt, int index) {
          //           return Padding(
          //               padding:
          //               const EdgeInsets.only(top: 5, bottom: 5),
          //               child: ListTile(
          //                 // title: Text(
          //                 //   formatTit(d.data![index]['title']),
          //                 //   overflow: TextOverflow.ellipsis,
          //                 //   style: CustomTextStyle(
          //                 //       fontSize: 15.sp, color: Colors.white),
          //                 // ),
          //                 // subtitle: Text(
          //                 //   formatTit(d.data![index]['authur']),
          //                 //   overflow: TextOverflow.ellipsis,
          //                 //   style: CustomTextStyle(
          //                 //       fontWeight: FontWeight.w300,
          //                 //       fontSize: 13.sp,
          //                 //       color: Colors.grey),
          //                 // ),
          //                 // trailing: Row(
          //                 //   mainAxisSize: MainAxisSize.min,
          //                 //   children: [
          //                 //     IconButton(
          //                 //         onPressed: () async {
          //                 //           MusicOperations()
          //                 //               .saveToFavourites(
          //                 //                   context,
          //                 //                   controller,
          //                 //                   d.data![index]['ytid'],
          //                 //                   d.data![index]);
          //                 //         },
          //                 //         icon: Icon(
          //                 //           Icons.favorite_border,
          //                 //           size: 25.sp,
          //                 //           color: context
          //                 //               .read<ColorProvider>()
          //                 //               .origWhite,
          //                 //         )),
          //                 //   ],
          //                 // ),
          //                 onTap: () async {
          //
          //                 },
          //               ));
          //         },
          //       )
          //           : Column(
          //         children: [
          //           SizedBox(
          //             height: 200.h,
          //           ),
          //           Center(
          //             child: Text(
          //               'No results found! 😔',
          //               style: CustomTextStyle(color: Colors.grey),
          //             ),
          //           ),
          //         ],
          //       );
          //     } else {
          //       return Column(
          //         children: [
          //           SizedBox(
          //             height: 200.h,
          //           ),
          //           const CircularProgressIndicator.adaptive(),
          //         ],
          //       );
          //     }
          //   },
          // ) :
          context.watch<MusicProvider>().localVideoList.isNotEmpty ?
          ListView.builder(
            shrinkWrap: true,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: context.read<MusicProvider>().localVideoList.length,
            itemBuilder: (BuildContext ctx, int index) {
              return Padding(
                  padding:
                  const EdgeInsets.only(top: 5, bottom: 5),
                  child: ListTile(
                      leading: context.read<MusicProvider>().localVideoList[index].albumArt != null ?
                      SizedBox(
                          width: 50.w,
                          child: Image.memory(context.read<MusicProvider>().localVideoList[index].albumArt!)) :
                      SizedBox(width: 50.w,
                        child: Icon(CupertinoIcons.play_rectangle,color: Colors.grey,),),
                      title: Text(
                        context.read<MusicProvider>().localVideoList[index].trackName??
                            context.read<MusicProvider>().localVideoList[index].filePath!.split('/').last,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyle(
                            fontSize: 15.sp, color: Colors.white),
                      ),
                      subtitle: Text(
                        context.read<MusicProvider>().localVideoList[index].trackArtistNames.toString() == 'null'
                            ? 'Unknown ' : context.read<MusicProvider>().localVideoList[index].trackArtistNames.toString(),
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
                              onPressed: () async {
                              },
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
                        Get.to(()=>VideoPlayerPage(file: File(context.read<MusicProvider>().localVideoList[index].filePath!)));
                      }
                  ));
            },
          ) :
          NoResFound()
        ],
      ),
    );
  }
}
