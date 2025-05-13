import 'dart:convert';

import 'package:bharat_nxt/core/common/state/data_state.dart';
import 'package:bharat_nxt/models/articles_model.dart';
import 'package:bharat_nxt/services/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constant/keys.dart';

class ArticleCubit extends Cubit<DataState>{

  List<ArticlesModel>? _articles;
  ArticleCubit():super(DataInitial());

  Future<void> loadArticles() async {
    emit(DataLoading());
    final res= await Api().getArticles();
    res.fold(
            (failure){
              emit(DataLoadFailed(failure: failure));
            },
            (articles){
              _articles=articles;
              emit(DataLoaded<List<ArticlesModel>>(data: articles));
            }
    );
  }

  void search(String text){
    if(text.trim().isNotEmpty){
      emit(DataLoading());
      if(_articles!=null && (_articles?.isNotEmpty??false)){
        final filteredArticles= _articles!.where((e)=>
        e.title.toLowerCase().contains(text.toLowerCase())|| e.body.toLowerCase().contains(text.toLowerCase()))
            .toList();
        emit(DataLoaded<List<ArticlesModel>>(data: filteredArticles));
      }
    }
    else{
      emit(DataLoaded<List<ArticlesModel>>(data: _articles??[]));
    }
  }

  void showAllArticles(){
    emit(DataLoaded<List<ArticlesModel>>(data: _articles??[]));
  }

  Future<void> loadFavouriteArticles() async {
    final articles= await _loadsFavouritesFromPrefs();
    final list= articles.entries.map((entry)=> ArticlesModel.fromJson(jsonDecode(entry.value))).toList();
    emit(DataLoaded<List<ArticlesModel>>(data: list));
  }

  Future<Map<String,dynamic>> _loadsFavouritesFromPrefs() async {
    final prefs= await SharedPreferences.getInstance();
    final json= prefs.getString(Keys.favouriteArticles);
    final articles= json!=null? jsonDecode(json) as Map<String,dynamic> : <String,dynamic>{};
    return articles;
  }

}