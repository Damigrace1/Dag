import 'package:dag/music/presentation/homescreen.dart';
import 'package:dag/onboarding/presentation/onboarding.dart';
import 'package:dag/provider/registry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'configs/connectivity.dart';
import 'music/data/hive_store.dart';

Box? favBox;
Box? user;
Box? searchBox;
bool netAvail = false;
SpeechToText stt = SpeechToText();
Future<void> main()async {

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(FavouriteAdapter());
 favBox = await Hive.openBox('favBox');
searchBox = await Hive.openBox('sBox');
 user = await Hive.openBox('user_details');
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:
    Color(0xfff9ce80), // Set the status bar color to transparent
    systemNavigationBarColor:
    Colors.black, // Set the systemNavigation bar color to transparent
  ));

  // Set the preferred screen orientations for the app (portrait mode only)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: ScreenUtilInit(
        designSize: const Size(360, 640),
        minTextAdapt: true,
          builder: (context, child) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            color: Colors.black,
              title: 'Dag',
              theme: ThemeData(
                iconTheme:const IconThemeData(
              color: Colors.white
                ) ,
                fontFamily: 'Poppins',
                colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffF9CE80)),
                useMaterial3: true,
              ),
              home: user?.get('isNew') == null ?  Onboarding()
                  : const HomeScreen()
          )),
    );
  }
}

