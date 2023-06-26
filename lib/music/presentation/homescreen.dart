import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:dag/configs/setup.dart';
import 'package:dag/nav%20screens/home.dart';
import 'package:dag/nav%20screens/library.dart';
import 'package:dag/views/local_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../configs/connectivity.dart';
import '../../controllers/local_media.dart';
import '../../main.dart';
import '../../nav screens/me.dart';
import '../../nav screens/search/presentation/search_music.dart';
import '../../provider/color.dart';
import '../../provider/home_provider.dart';
import '../../provider/music.dart';
import '../../utils/custom_textstyles.dart';
import '../../utils/functions.dart';
import '../../utils/global_declarations.dart';


final GlobalKey homeKey = GlobalKey();
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  List <Widget> screens = [
    Home(),
    SearchScreen(),
    Library(),
    LocalPlayer()
    //Me(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  Setup().init(context);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
        builder: (context,home,child){
          return WillPopScope(
            onWillPop: ()async{
              if(home.tabIndex != 0){
                home.tabIndex = 0;
                return false;
              }
              return false;
            },
            child: Scaffold(
              key: homeKey,
              backgroundColor: Colors.black,
              body: screens[home.tabIndex],
              bottomNavigationBar:
              CurvedNavigationBar(
                iconPadding: 15.w,
                color: context.read<ColorProvider>().blackAcc,
                backgroundColor: Colors.black,
                animationDuration: const Duration(milliseconds: 200),
                height: 50.h,
                index: home.tabIndex,
                items:   <CurvedNavigationBarItem>[
                  curvdNav(0,"Home",Icons.home,Icons.home_outlined),
                  curvdNav(1,"Search",Icons.search,Icons.search_outlined),
                  curvdNav(2,"Favourites",Icons.favorite,Icons.favorite_border),
                  curvdNav(3,"Local Music",Icons.folder_rounded,Icons.folder_outlined),
                 // curvdNav(3,"Me",Icons.person,Icons.person_outline),
                ],
                onTap: (index){
                  home.tabIndex = index;
                },
              ),
            ),
          );
        }
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
              color: (context.read<HomeProvider>().tabIndex == ind)?
              context.read<ColorProvider>().primaryCol:
              Colors.grey,
            fontSize: 13.sp,
            fontWeight: FontWeight.w300
          ),
          label: context.read<HomeProvider>().tabIndex  == ind ? title : null,
          child: Icon(
            context.read<HomeProvider>().tabIndex  == ind ?
              selected:
              Unselected,
              size:  context.read<HomeProvider>().tabIndex  == ind ?
              25.sp: 28.sp,color:
          (context.read<HomeProvider>().tabIndex  == ind)?
          context.read<ColorProvider>().primaryCol:
          Colors.grey,
        ),);
  }
}
