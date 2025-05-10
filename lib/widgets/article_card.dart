import 'package:bharat_nxt/core/theme/app_colors.dart';
import 'package:bharat_nxt/cubit/article/article_cubit.dart';
import 'package:bharat_nxt/cubit/article/article_favourite_cubit.dart';
import 'package:bharat_nxt/models/articles_model.dart';
import 'package:bharat_nxt/screens/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArticleCard extends StatelessWidget {
  final ArticlesModel article;
  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>ArticleFavouriteCubit()..checkIsFavourite(id: article.id),
      child: InkWell(
        onTap: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (builder)=>Details(article: article)));
        },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Expanded(
                      child: Text(
                        article.title,
                        style: Theme.of(context)
                            .textTheme.headlineSmall,
                      ),
                    ),
                    BlocBuilder<ArticleFavouriteCubit,bool>(
                      builder: (BuildContext context, bool isMarkedFavourite) {
                        return GestureDetector(
                          onTap: (){
                            context.read<ArticleFavouriteCubit>().favourite(
                                isMarkedFavourite: isMarkedFavourite, articlesModel: article);
                          },
                          child: Icon(
                            isMarkedFavourite?
                            Icons.favorite
                                : Icons.favorite_border,
                            color:
                            isMarkedFavourite ? AppColors.red : AppColors.grey,
                            size: 28.sp,
                          ),
                        );
                      },
                    )
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  article.body,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 16.h),
                Row(
                  spacing: 10.w,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blueGrey.shade200,
                      radius: 20.r,
                      child: Text(
                        article.id.toString(),
                        style: TextStyle(color: Colors.white,fontSize: 14.sp),
                      ),
                    ),
                    Text(
                      'User ID: ${article.userId}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
