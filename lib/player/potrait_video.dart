import 'package:bharat_nxt/player/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PortraitVideo extends StatelessWidget {
  final Widget player;
  const PortraitVideo({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return SafeArea(
      child: Container(
        height: 1.sw> 600? 0.35.sh: 0.25.sh,
        width: double.infinity,
        color: Colors.black,
        child: player,
      ),
    );
  }
}