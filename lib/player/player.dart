import 'package:bharat_nxt/player/landscape_video.dart';
import 'package:bharat_nxt/player/potrait_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import 'cubit/video_cubit.dart';
import 'cubit/video_state.dart';


class Player extends StatelessWidget {
  final String link;
  // final bool? isLandscape;
  final double? height;
  const Player({super.key, required this.link, this.height,});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>VideoCubit()..initVideoPlayer(link: link)),
        BlocProvider(create: (create)=>VideoOrientationCubit()),
      ],
      child: BlocBuilder<VideoOrientationCubit,Orientation>(
        builder: (context,orientation){
          return orientation == Orientation.landscape?
          LandscapeVideo(player: _vPlayer(iconSize: 20.sp,isLandscape: true)):
          PortraitVideo(player: _vPlayer(iconSize: 30.sp));
        },
      ),
    );
  }

  Widget _vPlayer({required double iconSize,bool? isLandscape})=>
      BlocBuilder<VideoCubit,VideoState>(
          builder: (context,VideoState state){
            if(state is VideoInitialized){
              return GestureDetector(
                  onTap: (){
                    context.read<VideoCubit>().toggleControls();
                    // _hideStatusBar(isLandscape: isLandscape);
                  },
                  child: _player(context: context, state: state, iconSize: iconSize,isLandscape: isLandscape)
              );
            }
            else if(state is VideoLoading){
              return SizedBox(
                height: height?? 0.25.sh,
                child: Stack(
                  children: [
                    Positioned.fill(
                        top: 5.h,
                        left: 5.w,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: ()=>Navigator.pop(context),
                            child: Icon(
                              Icons.close_sharp,size: iconSize,color: Colors.white,),
                          ),
                        )
                    ),
                    const Center(child: CircularProgressIndicator(color:  Colors.white,),),
                  ],
                ),
              );
            }
            else if(state is VideoError){
              return Stack(
                children: [
                  Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Playback error",style: TextStyle(color: Colors.white,fontSize: 12.sp),),
                          SizedBox(height: 5.h),
                          InkWell(
                            onTap: (){
                              context.read<VideoCubit>().initVideoPlayer(link: state.videoLink);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.r)
                              ),
                              child: Text("Retry",
                                style: TextStyle(color: Colors.black,fontSize: 10.sp),
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                  Positioned.fill(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          onTap: ()=>Navigator.pop(context),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Icon(
                              Icons.arrow_back_ios,size: 30.sp,color: Colors.white,),
                          ),
                        ),
                      )
                  )
                ],
              );
            }
            return SizedBox.shrink();
          }
      );

  Widget _player({required BuildContext context, required VideoInitialized state,
    required double iconSize, bool? isLandscape}){
    return AspectRatio(
      aspectRatio: state.videoPlayerController.value.aspectRatio,
      child: Stack(
        children: [
          VideoPlayer(state.videoPlayerController),

          ValueListenableBuilder(valueListenable: state.videoPlayerController,
            builder: (BuildContext context, VideoPlayerValue value, Widget? child) {
              if(value.isBuffering) {
                return const Center(child: CircularProgressIndicator(color:  Colors.white,),);
              }
              return Container();
            },
          ),
          Container(color: state.showControls? Colors.black45 : Colors.transparent,),

          Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: AnimatedOpacity(
                  opacity: state.showControls? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: ()=>state.showControls?context.read<VideoCubit>().backwardVideo():
                        context.read<VideoCubit>().toggleControls(),

                        child: Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: const BoxDecoration(
                                color: Colors.black26,
                                shape: BoxShape.circle
                            ),
                            child: Icon(
                              Icons.replay_10,
                              size: iconSize,
                              color: Colors.white,
                            )
                        ),
                      ),
                      InkWell(
                        onTap: ()=>state.showControls?context.read<VideoCubit>().toggleVideoPlay():
                        context.read<VideoCubit>().toggleControls(),
                        child: Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: const BoxDecoration(
                              color: Colors.black26,
                              shape: BoxShape.circle
                          ),
                          child: Icon(
                            state.videoPlayerController.value.isPlaying?
                            Icons.pause:Icons.play_arrow,
                            size: iconSize,
                            color: Colors.white,),
                        ),
                      ),
                      InkWell(
                        onTap: ()=>state.showControls?context.read<VideoCubit>().forwardVideo():
                        context.read<VideoCubit>().toggleControls(),
                        child: Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: const BoxDecoration(
                              color: Colors.black26,
                              shape: BoxShape.circle
                          ),
                          child: Icon(
                            Icons.forward_10,
                            size: iconSize,
                            color: Colors.white,),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ),

          Positioned.fill(
              bottom: isLandscape??false? 40.h: 0,
              left: isLandscape??false?20.w:5.w,
              right: isLandscape??false?20.w:5.w,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ValueListenableBuilder(
                  valueListenable: state.videoPlayerController,
                  builder: (BuildContext context, value, Widget? child) {
                    final currentPosition = _formatDuration(value.position);
                    final totalDuration = _formatDuration(value.duration);
                    return AnimatedOpacity(
                      opacity: state.showControls? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: isLandscape??false? 0: 5.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('$currentPosition : $totalDuration',
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      color: Colors.white,
                                      fontSize: isLandscape==true? 10.sp: 18.sp
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    if(state.showControls){
                                      isLandscape??false?
                                      context.read<VideoOrientationCubit>().portrait():
                                      context.read<VideoOrientationCubit>().landscape();
                                    }
                                  },
                                  child: Icon(isLandscape==true? Icons.fullscreen_exit : Icons.fullscreen,
                                    color:Colors.white,
                                    size: iconSize,
                                  ),
                                )
                              ],
                            ),
                          ),
                          VideoProgressIndicator(
                              state.videoPlayerController,
                              allowScrubbing: true
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
          ),

          Positioned.fill(
              top: isLandscape??false? 20.h: 5.h,
              right: isLandscape??false?20.w: 5.w,
              child: AnimatedOpacity(
                opacity: state.showControls? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Align(
                  alignment: Alignment.topRight,
                  child:  Visibility(
                    visible: state.showControls,
                    child: InkWell(
                        onTap: (){
                          _showBottomDialog(context: context,
                              controller: state.videoPlayerController,videoQualities: state.videoQualities??[]
                              ,currentQuality: state.currentQuality??'adaptive',
                            isLandscape: isLandscape
                          );
                        },
                        child: Icon(Icons.settings,
                          size: iconSize,
                          color: Colors.white,
                        )),
                  ),
                ),
              )
          ),

          Positioned.fill(
              top: isLandscape??false? 20.h: 5.h,
              left: isLandscape??false?20.w: 5.w,
              child: Align(
                alignment: Alignment.topLeft,
                child: AnimatedOpacity(
                  opacity: state.showControls? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: InkWell(
                    onTap: (){
                      // if(isLandscape==true){
                      //   if(state.showControls) {
                      //     context.read<VideoOrientationCubit>().portrait();
                      //     if(isTrailer){
                      //       context.read<VideoCubit>().disposePlayer();
                      //     }
                      //   }
                      //   else{
                      //     context.read<VideoCubit>().toggleControls();
                      //   }
                      // }
                      // else{
                      //   Navigator.pop(context);
                      // }
                    },
                    child: Icon(
                      Icons.close_sharp,
                      size: iconSize,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  void _showBottomDialog({required BuildContext context,
    required VideoPlayerController controller,required List<String> videoQualities,
    required String currentQuality,bool? isLandscape}){

    String? currentQuality= context.read<VideoCubit>().currentQuality;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (c){
          return SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30.h,horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _bottomSettingsIcon(
                      context: context,
                      settingsName: 'Quality',
                      settingsIcon: Icons.high_quality_outlined,
                      value: currentQuality=='adaptive'|| currentQuality==null ?'Auto': '${currentQuality}p',
                      onTap: () {
                        _videoQualityDialog(context: context, controller: controller,
                            videoQualities: videoQualities,currentQuality: currentQuality??'adaptive',
                            isLandscape: isLandscape);
                      },
                    isLandscape: isLandscape
                  ),
                  _bottomSettingsIcon(
                      context: context,
                      settingsName: 'Playback speed',
                      settingsIcon: Icons.speed,
                      value: '${controller.value.playbackSpeed}',
                      onTap: () {
                        _playBackDialog(context: context,controller: controller,isLandscape: isLandscape);
                      },
                      isLandscape: isLandscape
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget _bottomSettingsIcon({required BuildContext context,
    required String settingsName,required IconData settingsIcon, required String value, required VoidCallback onTap,
    bool? isLandscape}){

    double iconSize= isLandscape== true? 15.sp : 25.sp;
    double fontSize= isLandscape== true? 10.sp : 18.sp;
    fontSize =18;
    final theme= Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isLandscape== true? 12.h: 8.h,),
        child: Row(
          children: [
            Icon(settingsIcon,size: iconSize,),
            SizedBox(width: 20.w,),
            Text(settingsName,
                style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: fontSize,
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold
                )
            ),
            Spacer(),
            Text(value,
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: fontSize,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Icon(Icons.arrow_forward_ios,size: 12.sp,),
          ],
        ),
      ),
    );
  }

  void _videoQualityDialog({required BuildContext context,
    required VideoPlayerController controller, required List<String> videoQualities,
    required String currentQuality,bool? isLandscape}){

    double fontSize= isLandscape== true? 10.sp : 18.sp;

    final theme= Theme.of(context);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (c){
          return SafeArea(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30.h,horizontal: 20.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: videoQualities.map((quality)=>
                      InkWell(
                        onTap: (){
                          context.read<VideoCubit>().changeQuality(quality);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Row(
                            children: [
                              Opacity(
                                  opacity: quality==currentQuality? 1 : 0,
                                  child: Icon(Icons.check,size: 18.sp,)
                              ),
                              SizedBox(width: 10.w,),
                              Text(quality.toLowerCase()=='adaptive'? 'Auto' : '${quality}p',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  )),
                            ],
                          ),
                        ),
                      )).toList(),
                ),
              ),
            ),
          );
        }
    );
  }

  void _playBackDialog({required BuildContext context, required VideoPlayerController controller,
    bool? isLandscape}){

    double fontSize= isLandscape== true? 10.sp : 18.sp;
    final theme= Theme.of(context);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (c){
          return SafeArea(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30.h,horizontal: 20.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [0.25,0.5,1.0,1.25,1.5,2.0].map((e)=>
                      InkWell(
                        onTap: (){
                          context.read<VideoCubit>().changeSpeed(e);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Row(
                            children: [
                              Opacity(
                                  opacity: e==controller.value.playbackSpeed? 1 : 0,
                                  child: Icon(Icons.check,size: 18.sp,)
                              ),
                              SizedBox(width: 10.w,),
                              Text('$e',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  )),
                            ],
                          ),
                        ),
                      )).toList(),
                ),
              ),
            ),
          );
        }
    );
  }

  void _hideStatusBar({bool? isLandscape}){
    if(isLandscape??false){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
        SystemUiOverlay.bottom
      ]);
    }
  }
}
