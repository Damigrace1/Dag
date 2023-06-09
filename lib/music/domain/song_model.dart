import 'package:dag/utils/functions.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SongModel {
  final String? id;
  final String? title;
  final String? image;
  final String? imgUrl;
  final Duration? dur;
  final String? artistes;
  SongModel({
    this.artistes,
     this.id,
     this.dur,
     this.title,
     this.image,
     this.imgUrl
  });

}
String formatSongTitle(String title) {
  return title
      .replaceAll('&amp;', '&')
      .replaceAll('&#039;', "'")
      .replaceAll('&quot;', '"')
      .replaceAll('[Official Music Video]', '')
      .replaceAll('OFFICIAL MUSIC VIDEO', '')
      .replaceAll('(OFFICIAL MUSIC VIDEO)', '')
      .replaceAll('Video', '')
      .replaceAll('[Official Video]', '')
      .replaceAll('[OFFICIAL VIDEO]', '')
      .replaceAll('[official music video]', '')
      .replaceAll('[Official Perfomance Video]', '')
      .replaceAll('[Lyrics]', '')
      .replaceAll('[Lyric Video]', '')
      .replaceAll('Lyric Video', '')
      .replaceAll('[Official Lyric Video]', '')
      .split(' (')[0]
      .split('|')[0]
      .trim();
}
Map<String, dynamic> returnSongLayout(dynamic index, Video song) {
String d = formatDur(song.duration!);
  return {

  'duration': d,
    'id': index,
    'ytid': song.id.toString(),
    'title': formatSongTitle(
      song.title.split('-')[song.title.split('-').length - 1],
    )??'',
    'image': song.thumbnails.standardResUrl??'',
    'lowResImage': song.thumbnails.lowResUrl??'',
    'highResImage': song.thumbnails.maxResUrl,
    'album': '',
    'type': 'song',
    'authur':song.author??'',
    'more_info': {
      'primary_artists': song.title.split('-')[0],
      'singers': song.title.split('-')[0],
    }
  };
}
