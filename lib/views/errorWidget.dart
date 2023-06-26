import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../provider/color.dart';

class CachedImageErrorWidget extends StatelessWidget {
  const CachedImageErrorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: context
                  .read<ColorProvider>()
                  .blackAcc),
          borderRadius:
          BorderRadius.circular(12),
        ),
        child: Image.asset(
            'images/mus_pla.jpg'));
  }
}