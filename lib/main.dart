import 'package:bharat_nxt/core/theme/app_theme.dart';
import 'package:bharat_nxt/cubit/article/article_cubit.dart';
import 'package:bharat_nxt/cubit/navigation/bottom_navigation_cubit.dart';
import 'package:bharat_nxt/player/player.dart';
import 'package:bharat_nxt/screens/favourites.dart';
import 'package:bharat_nxt/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_ , child) {
        return MaterialApp(
          title: 'Bharat Nxt',
          theme: AppTheme.lightTheme(),
          home: child,
        );
      },
      // child: MyHomePage(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (create)=>BottomNavigationCubit()),
        ],
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final items=[Home(),Favourites()];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Player(link: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
    );
    // return Scaffold(
    //   body: BlocBuilder<BottomNavigationCubit,int>(
    //     builder: (context,currentIndex){
    //       return IndexedStack(index: currentIndex,children: items,);
    //       // return items[currentIndex];
    //     }
    //   ),
    //   bottomNavigationBar: BlocConsumer<BottomNavigationCubit,int>(
    //     builder: (context,currentIndex){
    //       return BottomNavigationBar(
    //         currentIndex: currentIndex,
    //         onTap: (index){
    //           context.read<BottomNavigationCubit>().changeIndex(index);
    //         },
    //         items: [
    //           BottomNavigationBarItem(
    //             icon:  Icon(Icons.home,),
    //             label: 'Home',
    //           ),
    //           BottomNavigationBarItem(
    //             icon:  Icon(Icons.favorite,),
    //             label: 'Favourite',
    //           ),
    //         ],
    //       );
    //     },
    //     listener: (context,currentIndex) {
    //       // if(currentIndex==0){
    //       //   context.read<ArticleCubit>().showAllArticles();
    //       // }
    //       // else if(currentIndex==1){
    //       //   context.read<ArticleCubit>().loadFavouriteArticles();
    //       // }
    //     },
    //   ),
    // );
  }
}
