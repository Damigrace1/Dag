import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/color.dart';
import '../provider/music.dart';

class Me extends StatefulWidget {
  const Me({Key? key}) : super(key: key);

  @override
  State<Me> createState() => _MeState();
}

class _MeState extends State<Me> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorProvider,MusicProvider>(
        builder: (context,color,music,child){
          return Scaffold(
            backgroundColor:color.scaffoldCol ,
            body: Text('Me'),
          );
        });

  }
}
