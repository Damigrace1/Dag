import 'package:dag/music/presentation/homescreen.dart';
import 'package:dag/nav%20screens/search/presentation/search_music.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../utils/custom_textstyles.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int browseItem = 0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.search,color: Colors.white,),
          onPressed: (){
            setState(() {
              pressedButtonNo = 1;
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert,color: Colors.white,),
            onPressed: (){},
          ),
        ],
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Browse',style: CustomTextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28.sp,color: Colors.white
              ),),
              SizedBox(height: 15.h,),
              Row(children: [
                browseText(0,'All'),
                browseText(1,'New'),
                browseText(2,'Popular'),
                browseText(3,'Favourites'),
              ],),
              SizedBox(height: 15.h,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    browseMusic(),
                    browseMusic(),
                    browseMusic()
                  ],
                ),
              ),
              SizedBox(height: 25.h,),
              Text('Suggested',style: CustomTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.sp,color: Colors.white
              ),),
              SizedBox(height: 15.h,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    suggestedMusic(),
                    suggestedMusic(),
                    suggestedMusic()
                  ],
                ),
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
  Column suggestedMusic() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          width: 125.w,
          height: 135.h,
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
  TextButton browseText(
      int ind,
      String title
      ) {
    return TextButton(
              onPressed: (){
                setState(() {
                  browseItem = ind;
                });
              },
              child: Text(title,style: CustomTextStyle(
                color: browseItem == ind ? Colors.white :
                Colors.grey,
              ),),
            );
  }
}
