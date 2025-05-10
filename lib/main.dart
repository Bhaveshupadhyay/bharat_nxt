import 'package:bharat_nxt/core/theme/app_theme.dart';
import 'package:bharat_nxt/cubit/article/article_cubit.dart';
import 'package:bharat_nxt/cubit/article/article_favourite_cubit.dart';
import 'package:bharat_nxt/screens/home.dart';
import 'package:flutter/material.dart';
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
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (create)=>ArticleCubit()..loadArticles()),
          // BlocProvider(create: (create)=>ArticleFavouriteCubit()),
        ],
        child: const Home(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
