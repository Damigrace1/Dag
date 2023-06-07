import 'package:cached_network_image/cached_network_image.dart';
import 'package:dag/music/domain/song_model.dart';
import 'package:dag/music/presentation/song_display.dart';
import 'package:dag/utils/custom_textstyles.dart';
import 'package:dag/utils/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../provider/music.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
final yt = YoutubeExplode();
class _SearchScreenState extends State<SearchScreen> {
  // List<Map<String, dynamic>>? songs;
  String? sT = '';
  Future<List> fetchSongsList(String searchQuery) async {
    final VideoSearchList list = await yt.search.search(searchQuery);
    final searchedList = [
      for (final s in list)
        returnSongLayout(
          0,
          s,
        )
    ];

    return searchedList;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          SizedBox(height: 20.h,),
          Center(
            child: SearchB(rOnly: false, autoFocus: true,
            onChanged: (val)async{
        // for(var l in ls){
        //   searchRes?.add(SongModel(id:
        //       SongModel().formatSongTitle(l.title.split('-')[l.title.split('-').length - 1]), title:
        //   l.title)
        //   );
        // }
        setState(() {
            sT = val;
        });
             //print(list[0]);
            },),
          ),
            FutureBuilder(
              future: fetchSongsList(sT!),
              builder: (context, d) {

                return d.data != null
                    ? ListView.builder(
                  shrinkWrap: true,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: d.data?.length,
                  itemBuilder: (BuildContext ctxt, int index) {

                    return Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: ListTile(
                        leading: CachedNetworkImage(
                          width: 60,
                          height: 60,
                          imageUrl: d.data![index]['lowResImage'].toString(),
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
                          d.data![index]['title']
                              .toString()
                              .split('(')[0]
                              .replaceAll('&quot;', '"')
                              .replaceAll('&amp;', '&'),
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyle(
                          color: Colors.white
                        ),),
                        subtitle: Text(
                          d.data![index]['more_info']['singers']
                              .toString()
                              .split('(')[0]
                              .replaceAll('&quot;', '"')
                              .replaceAll('&amp;', '&'),
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyle(
                            fontWeight: FontWeight.w300,
                              fontSize: 14.sp,
                              color: Colors.grey
                          ),),
                        trailing: Text(
                          d.data![index]['duration']
                              .toString(),
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14.sp,
                              color: Colors.grey
                          ),),
                        onTap: (){
                          context.read<MusicProvider>().loading = true;
                          Get.to(SongDisplay(song: d.data![index],));
                        },
                      )

                    );
                  },
                )
                    : const SizedBox();
              },
            )
            // Expanded(
            //   child: ListView.builder(
            //       shrinkWrap: true,
            //       itemCount: songs?.length??0,
            //       itemBuilder: (context, index){
            //         return ListTile(
            //           onTap: ()async{
            //           },
            //           title: Text(
            //               songs['title']
            //                   .toString()
            //                   .split('(')[0]
            //                   .replaceAll('&quot;', '"')
            //                   .replaceAll('&amp;', '&'),
            //           ,style: CustomTextStyle(
            //               color: Colors.white
            //           ),),
            //
            //           // tileColor: context.read<ColorProvider>().origDeepAsh,
            //         );
            //       }),
            // )
        ],),
      ),
    );
  }
}
