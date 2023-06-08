import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:dag/nav%20screens/home.dart';
import 'package:dag/nav%20screens/mymusic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../nav screens/me.dart';
import '../../nav screens/search/presentation/search_music.dart';
import '../../provider/color.dart';
import '../../utils/custom_textstyles.dart';


final GlobalKey homeKey = GlobalKey();
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
int pressedButtonNo = 0;
class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List <Widget> screens = [
    Home(),
    SearchScreen(),
    MyMusic(),
    Me(),
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: homeKey,
      backgroundColor: Colors.black,
      body: screens[pressedButtonNo],
      bottomNavigationBar:

      CurvedNavigationBar(
        iconPadding: 15.w,
        color: context.read<ColorProvider>().blackAcc,
        backgroundColor: Colors.black,
        animationDuration: const Duration(milliseconds: 200),
        height: 50.h,
        index: pressedButtonNo,
        items:   <CurvedNavigationBarItem>[
          curvdNav(0,"Home",Icons.home,Icons.home_outlined),
          curvdNav(1,"Search",Icons.search,Icons.search_outlined),
          curvdNav(2,"All Music",Icons.music_note,Icons.music_note_outlined),
          curvdNav(3,"Me",Icons.person,Icons.person_outline),
        ],
        onTap: (index){
          setState(() {
            pressedButtonNo = index;
          });
        },
      ),
    );
  }

  CurvedNavigationBarItem curvdNav(
      int ind,
      String title,
      IconData selected,
      IconData Unselected
      ) {
    return CurvedNavigationBarItem(
          labelStyle: CustomTextStyle(
              color: (pressedButtonNo == ind)?
              context.read<ColorProvider>().primaryCol:
              Colors.grey,
            fontSize: 13.sp,
            fontWeight: FontWeight.w300
          ),
          label: pressedButtonNo == ind ? title : null,
          child: Icon(
              pressedButtonNo == ind ?
              selected:
              Unselected,
              size:  pressedButtonNo == ind ? 25.sp: 28.sp
              ,color: (pressedButtonNo == ind)?
          context.read<ColorProvider>().primaryCol:
          Colors.grey,
        ),);
  }
}
