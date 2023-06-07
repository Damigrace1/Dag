import 'package:dag/provider/music.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'color.dart';

final providers = <SingleChildWidget>[
  ChangeNotifierProvider(create: (_) => ColorProvider()),
  ChangeNotifierProvider(create: (_) => MusicProvider()),
];