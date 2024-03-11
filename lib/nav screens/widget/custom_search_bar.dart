// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class CustomSearchBar extends StatelessWidget {
//   const CustomSearchBar({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//       height: 30.h,
//       width: 340.w,
//       padding: EdgeInsets.symmetric(horizontal: 12.w),
//       decoration: BoxDecoration(
//           color: Colors.grey.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(40.r)
//       ),
//       alignment: Alignment.center,
//       child: Center(
//         child: TextFormField(
//           autofocus: false,
//           onChanged: (val) {
//             if (val.length == 0) {
//               SearchWidgetController.retrieveSearchList();
//             }
//             setState(() {});
//           },
//           readOnly: false,
//           style: CustomTextStyle(color: Colors.white),
//           controller: searchCont,
//           decoration: InputDecoration(
//               hintText: 'Start searching',
//               contentPadding: EdgeInsets.zero,
//               hintStyle: CustomTextStyle(
//                 color: Colors.grey,
//               ),
//               fillColor: Colors.grey,
//               enabledBorder: InputBorder.none,
//               focusedBorder: InputBorder.none,
//               suffixIcon: Consumer<MusicProvider>(
//                   builder: (context, music, child) {
//                     return AvatarGlow(
//                         glowColor: Colors.green,
//                         endRadius: 20.r,
//                         duration: Duration(milliseconds: 2000),
//                         repeat: true,
//                         animate: music.rec,
//                         showTwoGlows: true,
//                         repeatPauseDuration: Duration(milliseconds: 100),
//                         child: InkWell(
//                             onTap: () async {
//                               listenTo(searchCont);
//                             },
//                             child: Icon(
//                               Icons.mic,
//                               color: Colors.green,
//                               size: 20.sp,
//                             )));
//                   })
//           ),
//
//         ),
//       ),
//     );
//   }
// }
