import 'package:hive/hive.dart';

import '../../utils/functions.dart';
part 'hive_store.g.dart';
@HiveType(typeId:0)
class Favourite extends HiveObject{
  @HiveField(0)
  String? title;

  @HiveField(1)
  String? authur;

  @HiveField(2)
  String? songUrl;

  @HiveField(3)
  String? imgUrl;

  @HiveField(4)
  String? id;

  @HiveField(5)
  Duration? duration;


}