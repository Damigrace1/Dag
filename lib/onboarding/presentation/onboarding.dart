import 'package:dag/music/presentation/homescreen.dart';
import 'package:dag/utils/custom_textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/color.dart';
import '../domain/content.dart';


class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {

  int currentIndex = 0;
 late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding:  EdgeInsets.symmetric(
                    horizontal: 20.w
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        contents[i].image,
                        //height: 300,
                      ),
                      Flexible(child: SizedBox(height: 100.h,)),
                      Text(
                        contents[i].title,
                        style: CustomTextStyle(
                          spacing: 10.sp,
                          fontFamily: GoogleFonts.bangers(),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.sp
                        )
                      ),
                      SizedBox(height: 20.h,),
                      Text(
                        contents[i].description,
                        textAlign: TextAlign.center,
                        style: CustomTextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 13.sp,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                    (index) => buildDot(index, context),
              ),
            ),
          ),
          SizedBox(height: 20.h,),
          InkWell(
              onTap: () {
                if (currentIndex == contents.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeScreen(),
                    ),
                  );
                }
                _controller.nextPage(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.bounceIn,
                );},
              child: Container(
                height: 40.h,
                width: 200.w,
                decoration: BoxDecoration(
                  color: context.read<ColorProvider>().primaryCol,
                  borderRadius: BorderRadius.circular(12.w)
                ),
                child: Center(
                  child: Text(  currentIndex == contents.length
                      - 1 ? "Continue" : "Next",style:
                      CustomTextStyle(
                        color: context.read<ColorProvider>().scaffoldCol
                      )
                      // GoogleFonts.acme(
                      //     textStyle: GoogleFonts.actor
                      //       (color: Colors.blue, letterSpacing: .5)
                      // )
                  // CustomTextStyle(
                  //   color: Colors.black,
                  // ),
                  ),
                ),
              ),),
          SizedBox(height: 20.h,)
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
