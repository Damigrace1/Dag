import 'package:cached_network_image/cached_network_image.dart';
import 'package:dag/music/data/hive_store.dart';
import 'package:dag/provider/home_provider.dart';
import 'package:dag/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../music/presentation/song_display.dart';
import '../music/presentation/song_widget.dart';
import '../provider/color.dart';
import '../provider/music.dart';
import '../utils/custom_textstyles.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {

  @override
  Widget build(BuildContext context) {
    List<Favourite> favs = getFavSongs();
    return Consumer2<ColorProvider,MusicProvider>(
        builder: (context,color,music,child){
          return Scaffold(
            backgroundColor: color.scaffoldCol,
            appBar: AppBar(
              leading: IconButton(
                onPressed: (){
                  context.read<HomeProvider>().tabIndex = 0;
                },
                icon: Icon(Icons.keyboard_arrow_left,
                  color: color.origWhite,),
              ),
              title:  Text('Favourites',style: CustomTextStyle(
                  color: color.origWhite,
                  fontSize: 18.sp
              ),),
              backgroundColor: color.scaffoldCol,
              actions: [
                // IconButton(onPressed: (){
                //   print(favBox!.length);
                // }, icon:
                // Icon(Icons.more_vert,color:color.origWhite,)),
                IconButton(onPressed: (){
                  context.read<MusicProvider>().
                  songGroup = favs;
                  context.read<MusicProvider>().loading = true;
                  context.read<MusicProvider>().
                  inSession = false;
                  Get.to(()=>const SongDisplay());
                },
                    icon:
                    Text('Play All',style: CustomTextStyle(color: color.primaryCol,
                        fontSize: 16.sp),)),
                SizedBox(width: 20.w,)
              ],
            ),
            body: favs.isNotEmpty ?

            ListView.builder(
              itemCount: favs.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CachedNetworkImage(
                    width: 60.w,
                    height: 60.h,
                    imageUrl:favs[index].imgUrl!,
                    errorWidget: (context, url, error){
                      print(error);
                       return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: color.blackAcc),
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
                  title: Text(favs[index].title!,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyle(
                        color: Colors.white
                    ),),
                  subtitle: Text(
                    favs[index].artiste!,
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
                       setState(() {
                         favBox?.delete(favs[index].id);
                       });

                      }, icon:
                      Icon(Icons.playlist_remove,
                        size: 25.sp,
                        color: context.read<ColorProvider>().origWhite,)),
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
                    List<Favourite> l1 = favs;
                    List<Favourite> l3 = l1.sublist(index,l1.length);
                    List <Favourite>l2 = l1.sublist(0,index);
                    context.read<MusicProvider>().
                    songGroup = l3 + l2;
                    context.read<MusicProvider>().loading = true;
                    context.read<MusicProvider>().
                    inSession = false;
                    Get.to(()=>const SongDisplay());
                  },
                );
              },

            ) :
            Column(
              children: [
                SizedBox(height: 200.h,),
                Center(child:
                Text('No Music found! 😔\n'
                    'Add some musics to your favourites. ',
                    textAlign: TextAlign.center,
                  style: CustomTextStyle(
                    color: Colors.grey
                ),),),
              ],
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
          );
        }
    );
  }
}
