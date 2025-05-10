import 'package:bharat_nxt/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {

  final String hintText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final TextEditingController textEditingController;
  final VoidCallback? onIconTap;
  final VoidCallback? onTap;
  final TextInputType keyboardType;
  final Border? border;
  final bool? isReadOnly;
  final Color? bgColor;
  final Function(String)? onTextChanged;
  final List<TextInputFormatter>? inputFormatters;


  const CustomTextField({super.key, required this.hintText, this.suffixIcon,
    required this.textEditingController, this.onIconTap, required this.keyboardType,
    this.border, this.isReadOnly, this.onTap, this.inputFormatters, this.bgColor, this.prefixIcon, this.onTextChanged});

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: border,
          color: bgColor ?? (
              theme.brightness== Brightness.light?
              AppColors.black.withValues(alpha: 0.1): AppColors.white.withValues(alpha: 0.1)
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if(prefixIcon!=null)
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: prefixIcon,
            ),
          Expanded(
            child: TextFormField(
                onTap: onTap,
                controller: textEditingController,
                readOnly: isReadOnly??false,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 15.sp,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical:0.h,horizontal:20.w)
                ),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: 15.sp,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "$hintText is missing!";
                  }
                  return null;
                },
                onChanged: onTextChanged
            ),
          ),

          if(suffixIcon!=null)
            InkWell(
              onTap: onIconTap,
              child: suffixIcon,
            ),
          SizedBox(width: 10.w,),
        ],
      ),
    );
  }
}
