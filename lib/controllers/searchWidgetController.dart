import 'package:dag/main.dart';
import 'package:dag/music/presentation/homescreen.dart';
import 'package:dag/provider/music.dart';
import 'package:dag/views/searchHistWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SearchWidgetController {
  static bool? searchStringExist(String searchString){
   return searchBox?.values.any((element) => element == searchString);
  }

  static void saveSearchToHist(String searchString) {
    if(!searchStringExist(searchString)!){
    searchBox?.add(searchString);
  }}

  static void retrieveSearchList() {
    BuildContext? context = homeKey.currentContext;
    context?.read<MusicProvider>().searchHistWid.clear();
    searchBox?.values.forEach((element) {
      context
          ?.read<MusicProvider>()
          .searchHistWid
          .add(SearchHistWidget(text: element));
    });
  }

  static void deleteSearchString(SearchHistWidget searchHistWidget) {
    BuildContext? context = homeKey.currentContext;
    int? index =
        context?.read<MusicProvider>().searchHistWid.indexOf(searchHistWidget);
    searchBox?.deleteAt(index!);
    context?.read<MusicProvider>().searchHistWid.removeAt(index!);
  }

}
