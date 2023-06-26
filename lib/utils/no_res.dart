import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_textstyles.dart';

class NoResFound extends StatelessWidget {
  const NoResFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200.h,
          child: Image.asset('images/task.png'),
        ),
        Text(
          'Oops! Result not found.',
          style: CustomTextStyle(
              fontSize: 22.sp, color: Colors.white.withAlpha(200)),
        )
      ],
    );
  }
}