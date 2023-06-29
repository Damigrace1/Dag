class MusicModel {
  String? id;
  String? title;
  String? imgUrl;
  String? author;
  Duration? duration;
  String? musicUrl;
  MusicModel({
    this.author,
    this.title,
    this.id,
    this.imgUrl,
    this.duration,
    this.musicUrl
  });

  factory MusicModel.fromJson(Map<String, dynamic> musicMap) {
    return MusicModel(
      author: musicMap['more_info']['singers'],
      title: musicMap['title'],
      id: musicMap['ytid'],
      imgUrl: musicMap['image'],
      duration: musicMap['duration'],
    );
  }

  factory MusicModel.attachUrl(MusicModel initialModel,String url) {
    return MusicModel(
      author: initialModel.author,
      title: initialModel.title,
      id: initialModel.id,
      imgUrl: initialModel.imgUrl,
      duration: initialModel.duration,
      musicUrl: url
    );
  }
}

class MusicModelTest{
  String? id;
  String? title;
  String? imgUrl;
  String? author;
  Duration? duration;
  String? musicUrl;
  MusicModelTest({
    this.author,
    this.title,
    this.id,
    this.imgUrl,
    this.duration,
    this.musicUrl
  });
}

class Test{
  String name;
  Test({required this.name});
}