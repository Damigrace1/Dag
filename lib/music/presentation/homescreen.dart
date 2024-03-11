import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:dag/configs/setup.dart';
import 'package:dag/music/presentation/song_widget.dart';
import 'package:dag/nav%20screens/home.dart';
import 'package:dag/nav%20screens/library.dart';
import 'package:dag/views/local_player.dart';
import 'package:flutter/foundation.dart';
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
  List<Widget> screens = [
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

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeProvider,MusicProvider>(builder: (context, home, music,child) {
      return WillPopScope(
        onWillPop: () async {
          if (home.tabIndex != 0) {
            home.tabIndex = 0;
            return false;
          }
          return false;
        },
        child: Scaffold(
          key: homeKey,
          backgroundColor: Colors.black,
          body: screens[home.tabIndex],

          bottomSheet:
              music.inSession ?
              SongWidget()
                  : null,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex:home.tabIndex ,
            selectedItemColor: Colors.green,
            showUnselectedLabels: true,
            unselectedItemColor: Colors.grey.shade800,
            items: <BottomNavigationBarItem>[

              btNav(0,"Home",Icons.home,Icons.home_outlined),
              btNav(1,"Search",Icons.search,Icons.search_outlined),
              btNav(2,"Favourites",Icons.favorite,Icons.favorite_border),
              btNav(3,"Local Music",Icons.folder_rounded,Icons.folder_outlined),

            ],
            onTap: (index) {
              home.tabIndex = index;
            },
          ),
        ),
      );
    });
  }

  BottomNavigationBarItem btNav(
      int ind, String title, IconData selected, IconData Unselected
      ){
    return BottomNavigationBarItem(
        backgroundColor: Colors.black,
        icon:Icon(selected),
        label: title);
  }

  BottomNavigationBarItem navItem(
      int ind, String title, IconData selected, IconData Unselected) {
    return BottomNavigationBarItem(
      backgroundColor: Colors.black,
      label: '',
      //context.read<HomeProvider>().tabIndex  == ind ? title : 'k',
      icon: Icon(
        context.read<HomeProvider>().tabIndex == ind ? selected : Unselected,
        size: 23.sp,
        color: context.read<HomeProvider>().tabIndex == ind
            ? context.read<ColorProvider>().primaryCol
            : Colors.white,
      ),
    );
  }
}
