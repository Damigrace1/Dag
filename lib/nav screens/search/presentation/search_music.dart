import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dag/music/domain/song_model.dart';
import 'package:dag/music/presentation/song_display.dart';
import 'package:dag/provider/color.dart';
import 'package:dag/provider/home_provider.dart';
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
void listenTo(){
  context.read<MusicProvider>().rec = true;
  stt.listen(onResult: (res)=>{
    print('dfghjkl;'),
    if(res.finalResult)
      {
        print(res.recognizedWords),
        searchCont.text = res.recognizedWords,
        setState(() {})
      }
  },
      listenMode: ListenMode.dictation);
  context.read<MusicProvider>().rec = false;
}
  @override
  void initState() {
    // TODO: implement initState
   Future.delayed(Duration.zero,(){
     showToast(context, 'Speak to search now');
     listenTo();
   });
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchCont.clear();
  }

  @override
  Widget build(BuildContext context) {

    return
      SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h,),
            Center(
              child: Stack(
                children:  [
                  Container(
                    width: 339.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,color: Colors.white
                      ),
                      borderRadius: BorderRadius.circular(20),

                    ),
                  ),
                  Positioned.fill(
                      child: Row(
                        children: [
                          SizedBox(width: 10.w,),
                          Expanded(
                            child:  TextField(
                              autofocus: false,
                              onChanged: (val){
                                setState(() {
                                });
                              },
                              readOnly: false,
                              style: CustomTextStyle(
                                  color: Colors.white
                              ),
                              controller: searchCont,
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Start searching',
                                  hintStyle: CustomTextStyle(color: Colors.grey,)
                              ),
                            ),
                          ),
                          Consumer<MusicProvider>(
                              builder: (context,music,child){
                                return
                                  AvatarGlow(
                                      glowColor: Colors.green,
                                      endRadius: 40.r,
                                      duration: Duration(milliseconds: 2000),
                                      repeat: true,
                                      animate: music.rec,
                                      showTwoGlows: true,
                                      repeatPauseDuration: Duration(milliseconds: 100),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        child: InkWell(
                                            onTap:()async{
                                              listenTo();
                                            },
                                            child: const Icon(Icons.mic)
                                        ),)
                                  );

                              }),
                          IconButton(
                            onPressed: (){
                              searchCont.clear();
                            },
                            icon: Icon(
                                Icons.clear,
                                color:  Colors.grey
                            ),
                          ),
                          SizedBox(width: 10.w,),
                        ],
                      ))
                ],
              ),
            ),
            FutureBuilder(
                    future: fetchSongsList(searchCont.text),
                    builder: (context, d) {
                      print('dfghjkl');
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
                                    errorWidget: (context, url, error){
                                      return Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: context.read<ColorProvider>().blackAcc),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Image.asset('images/mus_pla.jpg'));},
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
                                        showToast(context, 'Music added to Favourites');
                                      }, icon:
                                      Icon(Icons.favorite_border,
                                        size: 25.sp,
                                        color:
                                        context.read<ColorProvider>().origWhite,)),
                                    ],
                                  ),
                                  onTap: ()async{
                                    final manifest = await yt.
                                    videos.streamsClient.
                                    getManifest(d.data![index]["ytid"]);
                                    context.read<MusicProvider>().songGroup = [
                                      Favourite()
                                        ..id = d.data![index]['ytid']
                                        ..songUrl = manifest.audioOnly.withHighestBitrate().
                                        url.toString()
                                        ..title = formatTit(d.data![index]['title'])
                                        ..imgUrl = d.data![index]['image']
                                        ..artiste = d.data![index]['authur']
                                        ..duration = d.data![index]['duration']??const Duration(seconds: 25)
                                    ] ;
                                    context.read<MusicProvider>().loading = true;
                                    context.read<MusicProvider>().inSession = false;
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
          ],),
      ),
      );

  }
}
