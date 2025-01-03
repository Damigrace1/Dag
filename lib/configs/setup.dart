

import 'package:dag/models/video_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../controllers/local_media.dart';
import '../main.dart';
import '../provider/music.dart';
import '../utils/functions.dart';
import '../utils/global_declarations.dart';
import 'connectivity.dart';

class Setup {
   init(BuildContext context)async{
     ConnectivityService. initConnectivityService(context);
     stt.initialize();
     Future.delayed(Duration.zero,()async{
       context.read<MusicProvider>().favSongs = getFavSongs();
     });
     user?.put('isNew', false);
  }
}