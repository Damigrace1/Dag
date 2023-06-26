import 'package:cached_network_image/cached_network_image.dart';
import 'package:dag/controllers/music_operations.dart';
import 'package:dag/models/music_model.dart';
import 'package:dag/music/data/hive_store.dart';
import 'package:dag/provider/home_provider.dart';
import 'package:dag/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../controllers/rebuilders.dart';
import '../main.dart';
import '../music/presentation/song_display.dart';
import '../music/presentation/song_widget.dart';
import '../provider/color.dart';
import '../provider/music.dart';
import '../utils/custom_textstyles.dart';
import '../value_notifiers.dart';

class Library extends StatefulWidget {
   Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  ScrollController scrollController = ScrollController();
  rebuild(){
    setState(() {});
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rebuildLibraryPage = rebuild;
  }
  // Future<void> _scrollListener() async {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero,(){
      context.read<MusicProvider>().favSongs = getFavSongs();
    });

    return Consumer2<ColorProvider, MusicProvider>(
        builder: (context, color, music, child) {
      return Scaffold(
        backgroundColor: color.scaffoldCol,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.read<HomeProvider>().tabIndex = 0;
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: color.origWhite,
            ),
          ),
          title: Text(
            'Favourites',
            style: CustomTextStyle(color: color.origWhite, fontSize: 18.sp),
          ),
          backgroundColor: color.scaffoldCol,
          actions: [
            // IconButton(onPressed: (){
            //   print(favBox!.length);
            // }, icon:
            // Icon(Icons.more_vert,color:color.origWhite,)),
            IconButton(
                onPressed: () {
                  context.read<MusicProvider>().songGroup = music.favSongs;
                  context.read<MusicProvider>().inSession = false;
                  context.read<MusicProvider>().songIndex = 0;
                  Get.to(() => const SongDisplay());
                },
                icon: Text(
                  'Play All',
                  style:
                      CustomTextStyle(color: color.primaryCol, fontSize: 16.sp),
                )),
            SizedBox(
              width: 20.w,
            )
          ],
        ),
        body: music.favSongs.isNotEmpty
            ? ListView.builder(
                controller: scrollController,
                itemCount: music.favSongs.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CachedNetworkImage(
                      width: 60.w,
                      height: 60.h,
                      imageUrl: music.favSongs[index].imgUrl!,
                      errorWidget: (context, url, error) {
                        print(error);
                        return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: color.blackAcc),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset('images/mus_pla.jpg'));
                      },
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
                      music.favSongs[index].title!,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      music.favSongs[index].authur!,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14.sp,
                          color: Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () async {
                              favBox?.delete(
                                  music.favSongs
                                  [index].id);
                            },
                            icon: Icon(
                              Icons.playlist_remove,
                              size: 25.sp,
                              color: context.read<ColorProvider>().origWhite,
                            )),
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
                    onTap: () async{
                      List<Favourite> l1 = music.favSongs;
                      List<Favourite> l3 = l1.sublist(index, l1.length);
                      List<Favourite> l2 = l1.sublist(0, index);
                      List<MusicModel> favToMusicModel = [];
                      (l3 + l2).forEach((fav) {
                        favToMusicModel.add(MusicModel(
                          author: fav.authur,
                          title: fav.title,
                          id: fav.id,
                          imgUrl: fav.imgUrl,
                          duration: fav.duration
                        ));
                      });
                      context.read<MusicProvider>().musicModelGroup = favToMusicModel;
                      context.read<MusicProvider>().inSession = false;
                      context.read<MusicProvider>().songIndex = 0;
                    //  await MusicOperations().playSong();
                      Get.to(()=>SongDisplay());
                     // MusicOperations().loadMultipleSongs(l3 + l2);
                    },
                  );
                },
              )
            : Column(
                children: [
                  SizedBox(
                    height: 200.h,
                  ),
                  Center(
                    child: Text(
                      'No Music found! 😔\n'
                      'Add some musics to your favourites. ',
                      textAlign: TextAlign.center,
                      style: CustomTextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
        persistentFooterButtons: [
          Consumer<MusicProvider>(builder: (context, music, child) {
            if (music.isPlaying) {
              return const SongWidget();
            } else {
              return const SizedBox();
            }
          })
        ],
      );
    });
  }
}
