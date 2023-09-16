

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dag/music/presentation/homescreen.dart';
import 'package:dag/provider/color.dart';
import 'package:dag/provider/music.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class ConnectivityService {

  static initConnectivityService(BuildContext context) {
    // Initialize the connectivity plugin

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Handle the connectivity change event
      if (result == ConnectivityResult.none) {
        netAvail =false;
        ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              content: Text('Oops! It seems you have lost internet connection!'),
              backgroundColor: context.read<ColorProvider>().
              primaryCol,
            ));
        print('No internet connection');
      } else {
        netAvail = true;
          notify ?
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Yay! Internet Connection restored'),
                backgroundColor: Colors.deepPurple,
              )) :
              notify = true;
      }
    });
  }
}
