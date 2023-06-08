import 'package:dag/music/presentation/homescreen.dart';
import 'package:dag/onboarding/presentation/onboarding.dart';
import 'package:dag/provider/registry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
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
                colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff85BE00)),
                useMaterial3: true,
              ),
              home: HomeScreen()
          )),
    );
  }
}
