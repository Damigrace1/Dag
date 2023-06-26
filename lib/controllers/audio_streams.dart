

import 'package:dag/music/presentation/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../music/presentation/song_display.dart';
import '../provider/music.dart';
import 'music_operations.dart';

class AudioStreams{

  initStreams(){
    BuildContext? context = homeKey.currentContext;
    positStream = player.positionStream.listen((v) {
      context!.read<MusicProvider>().sV = v;
    });
    bufStream = player.bufferedPositionStream.listen((v) {
      context!.read<MusicProvider>().bV = v;
    });
    player.playingStream.listen((isPlay) {
      context!.read<MusicProvider>().play = isPlay;
    });
    player.playerStateStream.listen((state) {
      print('playerStateStream:$state');
      switch (state.processingState) {
        case ProcessingState.buffering:
          context!.read<MusicProvider>().loading = true;
          break;
        case ProcessingState.ready:
          context!.read<MusicProvider>().loading = false;
          context.read<MusicProvider>().play = true;
          break;
        case ProcessingState.completed:
          MusicOperations().nextSong();
          break;
        default:
          ProcessingState.idle;
      }
    });
    player.durationStream.listen((dur) {
      context!.read<MusicProvider>().endV = dur ?? const Duration();
    });
    //  player.currentIndexStream.listen((index) async {
    //   context!.read<MusicProvider>().songIndex = index!;
    // });
  }

}