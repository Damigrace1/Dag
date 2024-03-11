import 'package:avatar_glow/avatar_glow.dart';
import 'package:dag/utils/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../main.dart';
import '../provider/music.dart';
import 'custom_textstyles.dart';
import 'functions.dart';



class SearchBox extends StatefulWidget {
  const SearchBox({Key? key, required this.controller,
    required this.onChanged}) : super(key: key);
  final void Function(String) onChanged;
  final  TextEditingController controller;
  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      width: 340.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(40.r)
      ),
      alignment: Alignment.center,
      child: Center(
        child: TextFormField(
          autofocus: false,
          onChanged:widget.onChanged ,
          readOnly: false,
          style: CustomTextStyle(color: Colors.white),
          controller: widget.controller,
          decoration: InputDecoration(
              hintText: 'Start searching',
              contentPadding: EdgeInsets.zero,
              suffixIconConstraints: BoxConstraints(maxHeight: 35.h),
              constraints: BoxConstraints(maxHeight: 35.h),
              hintStyle: CustomTextStyle(
                color: Colors.grey,
              ),
              fillColor: Colors.grey,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)
              ),
              suffixIcon: Consumer<MusicProvider>(
                  builder: (context, music, child) {
                    return AvatarGlow(
                        glowColor: Colors.green,
                        endRadius: 20.r,
                        duration: Duration(milliseconds: 2000),
                        repeat: true,
                        animate: music.rec,
                        showTwoGlows: true,
                        repeatPauseDuration: Duration(milliseconds: 100),
                        child: InkWell(
                            onTap: () async {
                              showToast('Speak to search now');
                              context.read<MusicProvider>().rec = true;
                              stt.listen(
                                  onResult: (res) => {
                                    if (res.finalResult)
                                      {
                                        print(res.recognizedWords),
                                        widget.controller.text = res.recognizedWords,
                                        widget.onChanged(widget.controller.text),
                                        setState(() {})
                                      }
                                  },
                                  listenMode: ListenMode.dictation);
                              context.read<MusicProvider>().rec = false;
                            },
                            child: Icon(
                              Icons.mic,
                              color: Colors.green,
                              size: 20.sp,
                            )));
                  })
          ),

        ),
      ),
    );
  }
}
