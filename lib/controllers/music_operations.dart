import 'dart:async';

import 'package:dag/controllers/searchWidgetController.dart';
import 'package:dag/models/music_model.dart';

import 'package:dag/music/presentation/homescreen.dart';
import 'package:dag/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../music/presentation/song_display.dart';
import '../nav screens/search/presentation/search_music.dart';
import '../provider/music.dart';
import '../utils/functions.dart';
import '../utils/global_declarations.dart';
import '../utils/search.dart';
import 'audio_streams.dart';
import 'fav_box.dart';

class MusicOperations {
  Future<String> getUrl(String videoId) async {
    try {
      final manifest = await yt.videos.streamsClient.getManifest(videoId);
      return manifest.audioOnly.withHighestBitrate().url.toString();
    } catch (e) {
      print(e);
      return '';
    }
  }

  // void loadMusic(BuildContext context, FlutterGifController controller) async {
  //   context.read<MusicProvider>().loading = true;
  //   context.read<MusicProvider>().inSession = false;
  //   context.read<MusicProvider>().isLocalPlay = false;
  //   Get.to(() => const SongDisplay());
  // }

  Future<void> saveToFavourites(
      BuildContext context,
      MusicModel musicModel) async {
    final fav = FavBox.createFavourite(musicModel);
    FavBox.addToFavourite( fav);
    context.read<MusicProvider>().favSongs.add(FavBox.createFavourite(
       musicModel));
  }

  AudioSource createAudioSource(
    MusicModel music,
  ) {
    return AudioSource.uri(
      Uri.parse(music.musicUrl!),
      tag: MediaItem(
        id: music.id!,
        album: '',
        duration: music.duration??Duration(),
        artist: music.author ==  music.title ? '' :  music.author??'',
        title: music.title!,
        artUri: Uri.parse(music.imgUrl!),
      ),
    );
  }


  Future playSong({int? index}) async {
    // Another music url needs will be generated because saved url does expire.

      BuildContext? context = homeKey.currentContext;
      context!.read<MusicProvider>().endV = Duration.zero;
      context.read<MusicProvider>().loading = true;

      context.read<MusicProvider>().sV = Duration.zero;

      final duration;
      if (!context.read<MusicProvider>().isLocalPlay) {
        MusicModel? noUrlModel = context
            .read<MusicProvider>()
            .musicModelGroup
            ?.elementAt(index!);
        final String musicUrl = await getUrl(noUrlModel!.id!);
        MusicModel urlModel = MusicModel.attachUrl(noUrlModel, musicUrl);
        AudioSource audioSource = createAudioSource(urlModel);
        duration = await player.setAudioSource(audioSource);
      } else
      {
        try {
          List<MusicModel> musicModels = [];
          localMusic.forEach((mus) {
            MusicModel mMod = MusicModel(
                musicUrl: mus.data,
                author: mus.composer ?? 'Unknown',
                title: mus.title ?? '',
                id: mus.data,
                // imgUrl:'',
                duration: Duration(seconds: mus.duration!));
            musicModels.add(mMod);
          });
          List<MusicModel> l1 = musicModels;
          List<MusicModel> l3 =
              l1.sublist(context.read<MusicProvider>().songIndex, l1.length);
          List<MusicModel> l2 =
              l1.sublist(0, context.read<MusicProvider>().songIndex);
          List<MusicModel> newMusicModelList = l3 + l2;
          context.read<MusicProvider>().songIndex = 0;
          context.read<MusicProvider>().musicModelGroup = newMusicModelList;

          List<AudioSource> audioSources = [];
          newMusicModelList.forEach((newMusicModel) {
            audioSources.add(
              AudioSource.file(
                newMusicModel.musicUrl ?? '',
                tag: MediaItem(
                  id: '',
                  album: 'Unknown',
                  title: newMusicModel.title ?? '',
                ),
              ),
            );
          });

          duration = await player
              .setAudioSource(ConcatenatingAudioSource(children: audioSources));
        } catch (e) {
          throw e;
        }
      }
      switch(context.read<MusicProvider>().loopMode){
        case PlayMode.all :  player.setLoopMode(LoopMode.all);
        break;
        case PlayMode.one :  player.setLoopMode(LoopMode.one);
        break;
        case PlayMode.off :  player.setLoopMode(LoopMode.off);
        break;
        default:   player.setLoopMode(LoopMode.off);
      }
      player.play();
      context.read<MusicProvider>().endV = duration!;
      context.read<MusicProvider>().play = true;
      context.read<MusicProvider>().loading = false;
      context.read<MusicProvider>().isPlaying = true;
      context.read<MusicProvider>().inSession = true;
      AudioStreams().initStreams();

  }

  Future <String> loadPlayGroup() async{
    BuildContext? context = homeKey.currentContext;
    List<MusicModel> music = [];
    searchResList.forEach((musicMap) {
      music.add(MusicModel.fromJson(musicMap));
    });
    context!.read<MusicProvider>().musicModelGroup = music;
    return 'done';
  }

  nextSong() async {
    BuildContext context = homeKey.currentContext!;
    context.read<MusicProvider>().loading = true;
    if(  context.read<MusicProvider>().loopMode != PlayMode.one)
   { context.read<MusicProvider>().songIndex++;}
    if (!context.read<MusicProvider>().isLocalPlay ) {
      await MusicOperations()
          .playSong(index: context.read<MusicProvider>().songIndex);
    } else {
      player.seekToNext();
    }
    context.read<MusicProvider>().loading = false;
  }

  previousSong() async {
    BuildContext context = homeKey.currentContext!;
    context.read<MusicProvider>().loading = true;
    if(  context.read<MusicProvider>().loopMode != PlayMode.one)
 {   context.read<MusicProvider>().songIndex--;}
    if (!context.read<MusicProvider>().isLocalPlay) {
      await MusicOperations()
          .playSong(index: context.read<MusicProvider>().songIndex);
    } else {
      player.seekToPrevious();
    }
    context.read<MusicProvider>().loading = false;
  }

  static favMusicChecker(BuildContext context) {
    Future.delayed(Duration.zero, () {
      context.read<MusicProvider>().isFav = context
          .read<MusicProvider>()
          .favSongs
          .any((testSong) =>
              testSong.id ==
              context
                  .read<MusicProvider>()
                  .musicModelGroup![context.read<MusicProvider>().songIndex]
                  .id!);
    });
  }
  static playRemoteSong(
      List<Map<String, dynamic>> musicMap,
      int index,
      FlutterGifController controller
      )async{
    BuildContext context = homeKey.currentContext!;
    SearchWidgetController.saveSearchToHist(
        searchCont.text);
    searchResList = musicMap;
    context.read<MusicProvider>().isLocalPlay = false;
    await MusicOperations().loadPlayGroup();
    loadMusic(index);
}}
