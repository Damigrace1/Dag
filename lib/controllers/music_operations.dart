import 'package:dag/models/music_model.dart';
import 'package:dag/music/data/hive_store.dart';
import 'package:dag/music/domain/song_model.dart';
import 'package:dag/music/presentation/homescreen.dart';
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

  Map<String, dynamic> favMapWithoutMusicUrl(Favourite favourite) {
    return {
      'ytid': favourite.id,
      'title': favourite.title,
      'image': favourite.imgUrl,
      'authur': favourite.authur,
      'duration': favourite.duration
    };
  }

  void loadSingleMusic(BuildContext context, FlutterGifController controller,
      Map<String, dynamic> musicMap) async {
    showLoader(controller, context);
    final musicModel = MusicModel.fromJson(musicMap);
    context.read<MusicProvider>().musicModelGroup = [musicModel];
    context.read<MusicProvider>().loading = true;
    context.read<MusicProvider>().inSession = false;
    Navigator.pop(context);
    Get.to(() => const SongDisplay());
  }

  // void loadMultipleSongs(List<Favourite> songs) {
  //   BuildContext? ctx = homeKey.currentContext;
  //   ctx?.read<MusicProvider>().songGroup = songs;
  //
  //   ctx?.read<MusicProvider>().loading = true;
  //   ctx?.read<MusicProvider>().inSession = false;
  //   Get.to(() => const SongDisplay());
  // }

  Future<void> saveToFavourites(
      BuildContext context,
      FlutterGifController controller,
      String musicId,
      Map<String, dynamic> musicMap) async {
    showLoader(controller, context);
    final musicUrl = await getUrl(musicId);
    final fav = FavBox.createFavourite(musicMap, musicUrl);
    FavBox.addToFavourite(musicId, fav);
    Navigator.pop(context);
  }

  AudioSource createAudioSource(
    Favourite music,
  ) {
    return AudioSource.uri(
      Uri.parse(music.songUrl!),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: music.id!,
        // Metadata to display in the notification:
        album: 'Unknown',
        title: music.title!,
        artUri: Uri.parse(music.imgUrl!),
      ),
    );
  }

  AudioSource createAudioSourceTest(
    MusicModel music,
  ) {
    return AudioSource.uri(
      Uri.parse(music.musicUrl!),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: music.id!,
        // Metadata to display in the notification:
        album: 'Unknown',
        title: music.title!,
        artUri: Uri.parse(music.imgUrl!),
      ),
    );
  }

  Future playSong({int? index}) async {
    // Another music url needs was generated because saved url does expire.
    try {
      BuildContext? context = homeKey.currentContext;
      context!.read<MusicProvider>().endV = Duration.zero;
      context.read<MusicProvider>().loading = true;
      context.read<MusicProvider>().inSession = false;
      context.read<MusicProvider>().sV = Duration.zero;
      Favourite? favourite =
          context.read<MusicProvider>().songGroup?.elementAt(index ?? 0);
      final String musicUrl = await getUrl(favourite!.id!);
      Map<String, dynamic> musicMap =
          MusicOperations().favMapWithoutMusicUrl(favourite);
      final fav = FavBox.createFavourite(musicMap, musicUrl);
      AudioSource audioSource = createAudioSource(fav);
      final duration = await player.setAudioSource(audioSource);

      context.read<MusicProvider>().endV = duration!;
      context.read<MusicProvider>().play = true;
      context.read<MusicProvider>().loading = false;
      player.play();
      // positStream?.resume();
      // bufStream?.resume();
      context.read<MusicProvider>().isPlaying = true;
      context.read<MusicProvider>().inSession = true;
      AudioStreams().initStreams();
    } catch (e) {
      debugPrint('play error: $e');
    }
  }

  Future playSongTest({int? index}) async {
    // Another music url needs will be generated because saved url does expire.
    print(localMusic.length);
    try {
      BuildContext? context = homeKey.currentContext;
      context!.read<MusicProvider>().endV = Duration.zero;
      context.read<MusicProvider>().loading = true;
      context.read<MusicProvider>().inSession = false;
      context.read<MusicProvider>().sV = Duration.zero;

      final duration;
      if (!context.read<MusicProvider>().isLocalPlay) {
        MusicModel? noUrlModel =
        context.read<MusicProvider>().musicModelGroup?.elementAt(index ?? 0);
        final String musicUrl = await getUrl(noUrlModel!.id!);
        MusicModel urlModel = MusicModel.attachUrl(noUrlModel, musicUrl);
        AudioSource audioSource = createAudioSourceTest(urlModel);
        duration = await player.setAudioSource(audioSource);
      } else {

        List<AudioSource> audioSources = [];
        localMusic.forEach((metadata) {
          // context.read<MusicProvider>().musicModelGroup!.
          //     add(
          //   MusicModel(
          //     author: metadata.authorName??'',
          //     title: metadata.trackName ?? metadata.filePath!.split('/').last,
          //     duration: Duration(seconds: metadata.trackDuration!),
          //
          //   )
          // );

          audioSources.add(
            AudioSource.file(
              metadata.filePath ?? '',
              tag: MediaItem(
                id: '',
                album: metadata.albumName ?? 'Unknown',
                title: metadata.trackName ?? metadata.filePath!.split('/').last,
                artUri: metadata.albumArt != null ?
                Uri.dataFromBytes(metadata.albumArt!.toList()) : null
              ),
            ),
          );
        });
        List<AudioSource> l1 = audioSources;
        List<AudioSource> l3 = l1.sublist(context.read<MusicProvider>().songIndex,
            l1.length);
        List<AudioSource> l2 = l1.sublist(0, index);
        AudioSource audioSource = ConcatenatingAudioSource(children: l3 + l2);
        duration = await player.setAudioSource(
            audioSource
        );
      }
      player.play();
      context.read<MusicProvider>().endV = duration!;
      context.read<MusicProvider>().play = true;
      context.read<MusicProvider>().loading = false;
      context.read<MusicProvider>().isPlaying = true;
      context.read<MusicProvider>().inSession = true;
      AudioStreams().initStreams();
    } catch (e) {
      debugPrint('play error: $e');
    }
  }

  Future playLocalSong({int? index}) async {
    // Another music url needs was generated because saved url does expire.
    try {
      BuildContext? context = homeKey.currentContext;
      context!.read<MusicProvider>().endV = Duration.zero;
      context.read<MusicProvider>().loading = true;
      context.read<MusicProvider>().inSession = false;
      context.read<MusicProvider>().sV = Duration.zero;
      Favourite? favourite =
          context.read<MusicProvider>().songGroup?.elementAt(index ?? 0);
      // player.stop();
      final String musicUrl = await getUrl(favourite!.id!);
      Map<String, dynamic> musicMap =
          MusicOperations().favMapWithoutMusicUrl(favourite);
      final fav = FavBox.createFavourite(musicMap, musicUrl);
      AudioSource audioSource = createAudioSource(fav);
      final duration = await player.setAudioSource(audioSource);

      context.read<MusicProvider>().endV = duration!;
      context.read<MusicProvider>().play = true;
      context.read<MusicProvider>().loading = false;
      player.play();
      // positStream?.resume();
      // bufStream?.resume();
      context.read<MusicProvider>().isPlaying = true;
      context.read<MusicProvider>().inSession = true;
      AudioStreams().initStreams();
    } catch (e) {
      debugPrint('play error: $e');
    }
  }

  loadPlayGroup(String authur) async {
    BuildContext? context = homeKey.currentContext;
    List<MusicModel> music = [];
    List musicMapList = await fetchSongsList(searchCont.text);
    musicMapList.forEach((musicMap) {
      music.add(MusicModel.fromJson(musicMap));
    });
    context!.read<MusicProvider>().musicModelGroup = music;
  }

  nextSong() async {
    BuildContext context = homeKey.currentContext!;
    context.read<MusicProvider>().loading = true;
    context.read<MusicProvider>().songIndex++;
    await MusicOperations()
        .playSongTest(index: context.read<MusicProvider>().songIndex);
    context.read<MusicProvider>().loading = false;
  }

  previousSong() async {
    BuildContext context = homeKey.currentContext!;
    context.read<MusicProvider>().loading = true;
    context.read<MusicProvider>().songIndex--;
    await MusicOperations()
        .playSongTest(index: context.read<MusicProvider>().songIndex);
    context.read<MusicProvider>().loading = false;
  }
}
