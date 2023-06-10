import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dag/music/domain/song_model.dart';
import 'package:dag/music/presentation/song_display.dart';
import 'package:dag/provider/color.dart';
import 'package:dag/utils/custom_textstyles.dart';
import 'package:dag/utils/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../main.dart';
import '../../../music/data/hive_store.dart';
import '../../../provider/music.dart';
import '../../../utils/functions.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
final yt = YoutubeExplode();
class _SearchScreenState extends State<SearchScreen> {
  // List<Map<String, dynamic>>? songs;
  String? sT = '';
  bool reload = false;

  @override
  void initState() {
    // TODO: implement initState

     stt.initialize();
    super.initState();
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
            child: SearchB(rOnly: false, autoFocus:
            context.read<MusicProvider>().inSession ? false : true,
            onChanged: (val)async{
        // for(var l in ls){
        //   searchRes?.add(SongModel(id:
        //       SongModel().formatSongTitle(l.title.split('-')[l.title.split('-').length - 1]), title:
        //   l.title)
        //   );
        // }
             setState(() {
               sT =val;
             });
             //print(list[0]);
            },),
          ),

            FutureBuilder(
              future: fetchSongsList(sT!),
              builder: (context, d) {
               if (d.connectionState == ConnectionState.done)
                   {
                     return d.data != null ?
                       ListView.builder(
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
                                 width: 60.w,
                                 height: 60.h,
                                 imageUrl:
                                 d.data![index]['lowResImage'].toString(),
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
                                 formatTit(d.data![index]['title']),
                                 overflow: TextOverflow.ellipsis,
                                 style: CustomTextStyle(
                                     color: Colors.white
                                 ),),
                               subtitle: Text(
                                 formatTit(d.data![index]['authur']),
                                 overflow: TextOverflow.ellipsis,
                                 style: CustomTextStyle(
                                     fontWeight: FontWeight.w300,
                                     fontSize: 14.sp,
                                     color: Colors.grey
                                 ),),
                               trailing: Row(
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                   IconButton(onPressed: ()async{
                                     final manifest = await yt.
                                     videos.streamsClient.
                                     getManifest(d.data![index]["ytid"]);
                                     Favourite fav = Favourite()
                                       ..id = d.data![index]['ytid']
                                       ..songUrl = manifest.audioOnly.withHighestBitrate().
                                       url.toString()
                                       ..title = formatTit(d.data![index]['title'])
                                       ..imgUrl = d.data![index]['image']
                                       ..artiste = d.data![index]['authur']
                                     ..duration = d.data![index]['duration']??const Duration(seconds: 25);
                                     favBox?.put(d.data![index]["ytid"],fav);
                                     print("retrieved string: ${
                                         favBox?.get(d.data![index]["ytid"]).duration
                                     }");
                                     showToast(context, 'Music added to Favourites');
                                   }, icon:
                                   Icon(Icons.playlist_add,
                                     size: 25.sp,
                                     color:
                                   context.read<ColorProvider>().origWhite,)),
                                   // Text(
                                   //   d.data![index]['duration']
                                   //       .toString(),
                                   //   overflow: TextOverflow.ellipsis,
                                   //   style: CustomTextStyle(
                                   //       fontWeight: FontWeight.w300,
                                   //       fontSize: 14.sp,
                                   //       color: Colors.grey
                                   //   ),),
                                 ],
                               ),
                               onTap: (){
                                 //player.stop();
                                 context.read<MusicProvider>().singleT = true;
                                 context.read<MusicProvider>().dispSong =
                                 d.data![index];

                                 context.read<MusicProvider>().loading = true;
                                 context.read<MusicProvider>().
                                 inSession = false;
                                 Get.to(()=>const SongDisplay());
                               },
                             )

                         );
                       },
                     )
                     :Column(
                       children: [
                         SizedBox(height: 200.h,),
                          Center(child:
                           Text('No results found! 😔',style: CustomTextStyle(
                             color: Colors.grey
                           ),),),
                       ],
                     );
                   }
               else {
               return Column(
                 children: [
                   SizedBox(height: 200.h,),
                   const CircularProgressIndicator.adaptive(),
                 ],
               );
               }
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
