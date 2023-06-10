
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../provider/color.dart';
import '../provider/music.dart';
import 'custom_textstyles.dart';

TextEditingController searchCont = TextEditingController();
class SearchB extends StatelessWidget {
  bool rOnly;
  bool autoFocus = false;
  void Function()? onTap;
   Function(String val)? onChanged;
  SearchB({Key? key,required this.rOnly,this.onTap,this.onChanged,
    required this.autoFocus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return
      Stack(
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
                      autofocus: autoFocus,
                      onChanged: onChanged,
                      readOnly: rOnly,
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
                  Consumer2<ColorProvider,MusicProvider>(
                      builder: (context,color,music,child){
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
                                radius: 18.r,
                                child: InkWell(
                                  onTap:()async{
                                    music.rec = true;
                                    await  stt.listen(onResult: (res)=>{
                                      print(res),
                                      searchCont.text = res.recognizedWords
                                    });
                                    music.rec = false;
                                  },
                                  child: const Icon(Icons.mic)
                                ),)
                          );

                      }),
                  Icon(
                    Icons.search_outlined,
                    color:  Colors.grey
                  ),
                  SizedBox(width: 10.w,),
                ],
              ))
        ],
      );

  }

}