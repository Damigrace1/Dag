import 'package:dag/music/presentation/homescreen.dart';
import 'package:dag/utils/custom_textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          ElevatedButton(
              onPressed: () {
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
              child: Text(  currentIndex == contents.length
                  - 1 ? "Continue" : "Next",style: CustomTextStyle(
                color: Colors.white
              ),),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(300.w, 40.h),
            backgroundColor: Color(0xff7E57C2)
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
