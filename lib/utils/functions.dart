import 'package:flutter/cupertino.dart';

formatDur(Duration dur){
  int? m = dur.inMinutes; // Get the minutes part
  int s = dur.inSeconds % 60;
  String d = '${m.toString().length == 1 ? '0$m' : m} :'
      ' ${s.toString().length == 1 ? '0$s' : s}';
  return d;
}

calcTotDur( Duration dur){
  int tot = dur.inMinutes * 60 + dur.inSeconds;
  return tot;
}