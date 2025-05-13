import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/common/state/data_state.dart';
import '../cubit/article/article_cubit.dart';
import '../models/articles_model.dart';
import '../widgets/article_card.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/loader.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  final TextEditingController _searchController= TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSearchBarVisible = true;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isSearchBarVisible) {
          setState(() {
            _isSearchBarVisible = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isSearchBarVisible) {
          setState(() {
            _isSearchBarVisible = true;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: () async {
          await context.read<ArticleCubit>().loadFavouriteArticles();
        },
        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _isSearchBarVisible ? 70.h : 0,
              child: AnimatedOpacity(
                opacity: _isSearchBarVisible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 200),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: _isSearchBarVisible? 10.h:0, horizontal: 20.w,),
                  child: CustomTextField(
                    hintText: 'Search articles...',
                    textEditingController: _searchController,
                    keyboardType: TextInputType.text,
                    onTextChanged: (text){
                      context.read<ArticleCubit>().search(text);
                    },
                    prefixIcon: Icon(Icons.search,size: 20.sp,),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ArticleCubit,DataState>(
                builder: (BuildContext context, DataState state) {
                  if(state is DataLoaded<List<ArticlesModel>>){
                    return ListView.builder(
                        controller: _scrollController,
                        itemCount: state.data.length,
                        itemBuilder: (context,index){
                          return ArticleCard(article: state.data[index]);
                        }
                    );
                  }
                  else if (state is DataLoading){
                    return Center(child: Loader());
                  }
                  else if(state is DataLoadFailed){
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Center(child: Text(state.failure.msg??'',style: Theme.of(context).textTheme.titleSmall,),),
                    );
                  }
                  return SizedBox.shrink();
                },

              ),
            )
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
