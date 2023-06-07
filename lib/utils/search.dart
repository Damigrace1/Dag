import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                          hintText: 'Start type',
                          hintStyle: CustomTextStyle(color: Colors.grey,)
                      ),
                    ),
                  ),
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