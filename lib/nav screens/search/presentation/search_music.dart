import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dag/controllers/fav_box.dart';
import 'package:dag/controllers/music_operations.dart';
import 'package:dag/controllers/searchWidgetController.dart';
import 'package:dag/models/music_model.dart';
import 'package:dag/music/domain/song_model.dart';
import 'package:dag/music/presentation/song_display.dart';
import 'package:dag/provider/color.dart';
import 'package:dag/provider/home_provider.dart';
import 'package:dag/utils/build_search.dart';
import 'package:dag/utils/custom_textstyles.dart';
import 'package:dag/utils/search.dart';
import 'package:dag/views/errorWidget.dart';
import 'package:dag/views/searchHistWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../configs/connectivity.dart';
import '../../../controllers/rebuilders.dart';
import '../../../main.dart';
import '../../../music/data/hive_store.dart';
import '../../../music/presentation/song_widget.dart';
import '../../../provider/music.dart';
import '../../../utils/functions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

final yt = YoutubeExplode();
List<Map<String, dynamic>> searchResList = [];
final searchPageKey = GlobalKey();

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  // List<Map<String, dynamic>>? songs;

  late FlutterGifController controller;
  @override
  void initState() {
    // TODO: implement initState
    rebuildSearchMusicPage = rebuild;
    super.initState();
    controller = FlutterGifController(vsync: this);

    Future.delayed(Duration.zero, () {
      SearchWidgetController.retrieveSearchList();
      setState(() {});
    });
    // _scrollController.addListener((){
    //   if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent ){
    //     setState(() {
    //       showAll = false;
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //scrollController.removeListener(_scrollListener);
    // scrollController.dispose();
    searchCont.clear();
    controller.dispose();
    super.dispose();
  }

  ScrollController _scrollController = ScrollController();

  rebuild() {
    setState(() {});
  }
  bool showAll = false;
  @override
  Widget build(BuildContext context) {
    // print(context.read<MusicProvider>().songIndex);
    // if(context.read<MusicProvider>().searchHistWid.isEmpty){
    //   context.read<MusicProvider>().searchHistWid.add(
    //     SearchHistWidget(text: '')
    //   );
    // }
    return Scaffold(
      key: searchPageKey,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled)
          {
            return [
              SliverAppBar(
                backgroundColor: Colors.black,
                title: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                     SearchBox(controller: searchCont,
                       onChanged: (val) {
                         if (val.length == 0) {
                           SearchWidgetController.retrieveSearchList();
                         }
                         setState(() {});
                       },),

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
          
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                searchCont.text.isEmpty
                    ? Stack(
                      children: [
                        Column(

                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Flexible(
                                flex: 3,
                                child: Wrap(
                                    spacing: 8.0.w,
                                    runSpacing: 10.0.h,
                                    children:
                                        showAll ?
                                        context.read<MusicProvider>().searchHistWid
                                            .reversed.toList() :
                                      context.read<MusicProvider>().searchHistWid
                                    .reversed.take(4).toList()),
                              ),
                            //  Divider(),
                              Flexible(
                                  flex: 9,
                                  child: FutureBuilder(
                                    future: fetchSongsList(
                                        context.read<MusicProvider>().searchHistWid.isNotEmpty ?
                                        context.read<MusicProvider>().searchHistWid.reversed.first.text :
                                            ''
                                    ),
                                    builder: (context, d) {
                                      if (d.connectionState == ConnectionState.done) {
                                        return d.data != null
                                            ? ListView.builder(
                                          shrinkWrap: true,
                                          addAutomaticKeepAlives: false,
                                          addRepaintBoundaries: false,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: d.data?.length,
                                          itemBuilder: (BuildContext ctxt, int index) {
                                            return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5, bottom: 5),
                                                child: ListTile(
                                                  leading: CachedNetworkImage(
                                                    width: 60.w,
                                                    height: 60.h,
                                                    imageUrl: d.data![index]
                                                    ['lowResImage']
                                                        .toString(),
                                                    errorWidget: (context, url, error) {
                                                      return CachedImageErrorWidget();
                                                    },
                                                    imageBuilder:
                                                        (context, imageProvider) =>
                                                        DecoratedBox(
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(12),
                                                            image: DecorationImage(
                                                              image: imageProvider,
                                                              centerSlice:
                                                              const Rect.fromLTRB(
                                                                  1, 1, 1, 1),
                                                            ),
                                                          ),
                                                        ),
                                                  ),
                                                  title: Text(
                                                    formatTit(d.data![index]['title']),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: CustomTextStyle(
                                                        fontSize: 15.sp,
                                                        color: Colors.white),
                                                  ),
                                                  subtitle: Text(
                                                    formatTit(d.data![index]['authur']),
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
                                                            MusicOperations().saveToFavourites(context,
                                                              MusicModel()
                                                                ..id = d.data?[index]['ytid']
                                                                ..title =  d.data?[index]['title']
                                                                ..imgUrl =  d.data?[index]['image']
                                                                ..author =  d.data?[index]['more_info']['singers']
                                                                ..duration =  d.data?[index]['duration']
                                                            );
                                                          },
                                                          icon: Icon(
                                                            Icons.favorite_border,
                                                            size: 25.sp,
                                                            color: context
                                                                .read<ColorProvider>()
                                                                .origWhite,
                                                          )),
                                                    ],
                                                  ),
                                                  onTap: () async {
                                                    MusicOperations.playRemoteSong( d.data??[], index, controller);
                                                  },
                                                ));
                                          },
                                        )
                                            : Column(
                                          children: [
                                            SizedBox(
                                              height: 200.h,
                                            ),
                                            Center(
                                              child: Text(
                                                'No results found! 😔',
                                                style:
                                                CustomTextStyle(color: Colors.grey),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 200.h,
                                            ),
                                            const CircularProgressIndicator.adaptive(),
                                          ],
                                        );
                                      }
                                    },
                                  ))
                            ],
                          ),
                        if( context.read<MusicProvider>().searchHistWid.length == 4)
                        Positioned(
                            top: showAll?null :50.h,
                            right: 0.w,
                            child: TextButton(onPressed: (){
                              setState(() {
                                showAll = true;
                              });
                            }, child: Text(showAll ?'': 'See more...',style: TextStyle(color: Colors.green),)))
                      ],
                    )
                    : FutureBuilder(
                        future: fetchSongsList(searchCont.text),
                        builder: (context, d) {
                          if (d.connectionState == ConnectionState.done) {
                            return d.data != null
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    addAutomaticKeepAlives: false,
                                    addRepaintBoundaries: false,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: d.data?.length,
                                    itemBuilder: (BuildContext ctxt, int index) {
                                      return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: ListTile(
                                            leading: CachedNetworkImage(
                                              width: 60.w,
                                              height: 60.h,
                                              imageUrl: d.data![index]
                                                      ['lowResImage']
                                                  .toString(),
                                              errorWidget: (context, url, error) {
                                                return CachedImageErrorWidget();
                                              },
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      DecoratedBox(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    centerSlice:
                                                        const Rect.fromLTRB(
                                                            1, 1, 1, 1),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              formatTit(d.data![index]['title']),
                                              overflow: TextOverflow.ellipsis,
                                              style: CustomTextStyle(
                                                  fontSize: 15.sp,
                                                  color: Colors.white),
                                            ),
                                            subtitle: Text(
                                              formatTit(d.data![index]['authur']),
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
                                                      MusicOperations().saveToFavourites(context,
                                                          MusicModel()
                                                            ..id = d.data?[index]['ytid']
                                                            ..title =  d.data?[index]['title']
                                                            ..imgUrl =  d.data?[index]['image']
                                                            ..author =  d.data?[index]['more_info']['singers']
                                                            ..duration =  d.data?[index]['duration']
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.favorite_border,
                                                      size: 25.sp,
                                                      color: context
                                                          .read<ColorProvider>()
                                                          .origWhite,
                                                    )),
                                              ],
                                            ),
                                            onTap: () async {
                                              MusicOperations.playRemoteSong( d.data??[], index, controller);
                                            },
                                          ));
                                    },
                                  )
                                : Column(
                                    children: [
                                      SizedBox(
                                        height: 200.h,
                                      ),
                                      Center(
                                        child: Text(
                                          'No results found! 😔',
                                          style:
                                              CustomTextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  );
                          } else {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 200.h,
                                ),
                                const CircularProgressIndicator.adaptive(),
                              ],
                            );
                          }
                        },
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }


}
