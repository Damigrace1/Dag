import 'package:dag/nav%20screens/search/presentation/search_music.dart';
import 'package:dag/utils/custom_textstyles.dart';
import 'package:dag/utils/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../controllers/rebuilders.dart';
import '../provider/color.dart';
class SearchHistWidget extends StatelessWidget {
  String text;
   SearchHistWidget({Key? key,required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
        searchCont.text = text;
        rebuildSearchMusicPage();
      },
      child: Container(
    // height: 30.h,
        width: 100.w,
        decoration: BoxDecoration(
          color: context.read<ColorProvider>().blackAcc,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: IntrinsicWidth(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: CustomTextStyle(color: Colors.white,fontSize: 15.sp),),
            ),
          ),
        ),
      ),
    );
  }
}
