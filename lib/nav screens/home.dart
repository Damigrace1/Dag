import 'package:cached_network_image/cached_network_image.dart';
import 'package:dag/music/presentation/homescreen.dart';
import 'package:dag/music/presentation/song_widget.dart';
import 'package:dag/nav%20screens/search/presentation/search_music.dart';
import 'package:dag/provider/color.dart';
import 'package:dag/provider/home_provider.dart';
import 'package:dag/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../controllers/music_operations.dart';
import '../music/data/hive_store.dart';
import '../music/presentation/song_display.dart';
import '../provider/music.dart';
import '../utils/custom_textstyles.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  List defaultSongs = [];
  String searchT = 'all';
  late FlutterGifController controller;
  @override
  void initState() {
    // TODO: implement initState
    controller = FlutterGifController(vsync: this);
    super.initState();
   // scrollController.addListener(_scrollListener);

  }
  @override
  void dispose() {
    // TODO: implement dispose
    //scrollController.removeListener(_scrollListener);
    // scrollController.dispose();
    controller.dispose();
    super.dispose();

  }
 ScrollController scrollController = ScrollController();

  // Future<void> _scrollListener() async {
  //   if (scrollController.position.userScrollDirection == ScrollDirection.reverse)
  //   {
  //     print('scrolling down');
  //     for( int i = 50 ; i > 2 ; i-- ){
  //       context.read<HomeProvider>().navHeight = double.parse(i.toString());
  //       await Future.delayed(Duration(milliseconds: 12));
  //     }
  //     // User is scrolling down, hide the bottom navigation bar
  //   context.read<HomeProvider>().showNavBar = false;
  //   } else if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
  //     // User is scrolling up, show the bottom navigation bar
  //     print('scrolling up');
  //     for( int i = 0 ; i < 50 ; i++ ){
  //       context.read<HomeProvider>().navHeight = double.parse(i.toString());
  //       await Future.delayed(Duration(milliseconds: 12));
  //     }
  //     context.read<HomeProvider>().showNavBar = true;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
   //  yt.search.getQuerySuggestions('christian').then((value) {
   //    print(value.audioOnly);
   //  });
   //  yt.videos.streamsClient.getManifest('2mfBfjTKPG8').then((value) {
   //   print(value.audio.first);
   // });
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.search,color: Colors.white,),
          onPressed: (){
            context.read<HomeProvider>().tabIndex  = 1;
          },
        ),
        title: Text('Home',style: CustomTextStyle(
          color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.bold
        ),),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.more_vert,color: Colors.white,),
        //     onPressed: (){},
        //   ),
        // ],
      ),
      persistentFooterButtons: [
        Consumer<MusicProvider>(
            builder: (context,music,child){
              if(music.isPlaying) {
                return const SongWidget();
              }
              else {
                return const SizedBox();
              }

            })
      ],
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          controller:  scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Browse',style: CustomTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.sp,color: Colors.white
              ),),
              // AnimatedDrawing.svg(
              //   'images/81966-girl-listening-to-music.gif',
              //   run: true,
              //   duration: new Duration(seconds: 3),
              //   onFinish: () => setState(() {
              //     print('sdfghjk');
              //   }),
              // ),
            //

              SizedBox(height: 15.h,),
              Row(children: [
                browseText(0,'All',"all songs"),
                browseText(1,'New','new songs'),
                browseText(2,'Popular', 'best songs'),
                //browseText(3,'Favourites'),
              ],),
              SizedBox(height: 15.h,),
              SizedBox(
                height: 200.h,
                child: FutureBuilder(
                  future: fetchSongsList(searchT),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
                  {
                    if(snapshot.connectionState == ConnectionState.done){
                      List<Map<String, dynamic>>  suggMus = snapshot.data??[];

                      return
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: suggMus.length,
                          itemBuilder: (BuildContext context, int index) {
                            return suggestedMusic(
                                suggMus,
                              index
                            );
                          },
                        );
                    }
                    else {
                      return Shimmer.fromColors(
                        baseColor: Colors.white54,
                        highlightColor: Colors.white38,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15.w),
                              width: 300.w,
                              height: 135.h,
                              decoration: BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                            SizedBox(height: 10.h,),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15.w),
                              width: 70.w,
                              height: 20.h,
                              decoration: BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius: BorderRadius.circular(5)
                              ),

                            )
                          ],
                        ),
                      );
                    }
                  },),
              ),
              Text('Suggested',style: CustomTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.sp,color: Colors.white
              ),),
              SizedBox(height: 15.h,),
              SizedBox(
                height: 200.h,
                child: FutureBuilder(
                  future: fetchSongsList('christian music'),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
                  {
                    if(snapshot.connectionState == ConnectionState.done){
                      List<Map<String, dynamic>> suggMus = snapshot.data??[];
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: suggMus.length,
                          itemBuilder: (BuildContext context, int index) {
                            return suggestedMusic(
                                suggMus,
                              index
                            );
                          },
                        );
                    }
                    else {
                      return Shimmer.fromColors(
                        baseColor: Colors.white54,
                        highlightColor: Colors.white38,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15.w),
                              width: 300.w,
                              height: 135.h,
                              decoration: BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                            SizedBox(height: 10.h,),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15.w),
                              width: 70.w,
                              height: 20.h,
                              decoration: BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius: BorderRadius.circular(5)
                              ),

                            )
                          ],
                        ),
                      );
                    }
                  },),
              ),

            ],
          ),
        ),
      ),
    );

  }

  Column browseMusic() {
    return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.w),
                    width: 110.w,
                    height: 120.h,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Image.asset('images/m1.png'),
                  ),
                  SizedBox(height: 7.h,),
                  Text('Title',style: CustomTextStyle(fontSize: 14.sp),),
                  SizedBox(height:4 .h,),
                  Text('Artist',style: CustomTextStyle(fontSize: 12.sp,
                  color: Colors.grey,fontWeight: FontWeight.w300),)
                ],
              );
  }
  InkWell suggestedMusic(
      List<Map<String, dynamic>> musicMap,
      int index
      ) {
    return InkWell(
      onTap: ()async{
        MusicOperations.playRemoteSong( musicMap??[], index, controller);
        MusicOperations().loadMusic(
            context,
            controller);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        width: 125.w,
       // height: 155.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              width: 125.w,
              height: 135.h,
              fit: BoxFit.cover,
              imageUrl: musicMap[index]['image'].toString(),
              errorWidget: (context, url, error)=>Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: context.read<ColorProvider>().blackAcc),
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
            SizedBox(height: 7.h,),
            Text(musicMap[index]['title'],
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyle(fontSize: 12.sp),),
            SizedBox(height:4 .h,)
          ],
        ),
      ),
    );
  }

  int browseItem = 0;
  TextButton browseText(
      int ind,
      String title,
      String query
      ) {
    return TextButton(
              onPressed: (){
                setState(() {
                  browseItem = ind;
                  searchT = query;
                });
              },
              child: Text(title,style: CustomTextStyle(
                color: browseItem == ind ? Colors.white :
                Colors.grey,
              ),),
            );
  }
}
