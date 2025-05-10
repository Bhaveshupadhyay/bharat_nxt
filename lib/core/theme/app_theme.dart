import 'package:bharat_nxt/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme{
  static ThemeData lightTheme()=>
      ThemeData.light().copyWith(
        textTheme: TextTheme(
          headlineSmall: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.black
          ),
          headlineLarge: GoogleFonts.poppins(
            fontSize: 25.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.black
          ),
          bodySmall: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black
          ),
          bodyLarge: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black
          ),
          titleSmall: GoogleFonts.poppins(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black
          ),
          labelSmall: GoogleFonts.poppins(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black.withValues(alpha: 0.6)
          ),
        ),
      );
}