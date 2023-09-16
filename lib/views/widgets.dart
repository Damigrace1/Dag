import 'package:cached_network_image/cached_network_image.dart';
import 'package:dag/music/presentation/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../controllers/music_operations.dart';
import '../provider/color.dart';
import '../utils/custom_textstyles.dart';


InkWell suggestedMusic(
    List<Map<String, dynamic>> musicMap,
    int index,
    FlutterGifController controller
    ) {
  BuildContext context = homeKey.currentContext!;
  return InkWell(
    onTap: ()async{
      MusicOperations.playRemoteSong( musicMap??[], index, controller);
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