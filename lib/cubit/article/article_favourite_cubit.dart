import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constant/keys.dart';
import '../../models/articles_model.dart';

class ArticleFavouriteCubit extends Cubit<bool>{
  ArticleFavouriteCubit():super(false);

  Future<void> checkIsFavourite({required int id}) async {
    final articles= await _loadsFavouritesFromPrefs();
    emit(articles.containsKey(id.toString()));
  }

  Future<void> favourite({required bool isMarkedFavourite,required ArticlesModel articlesModel})async {
    if(isMarkedFavourite){ //-> if the article is marked as favourite then remove it from favourites
      removePostFromFavourite(articlesModel: articlesModel);
    }
    else{
      addPostToFavourite(articlesModel: articlesModel);
    }
    emit(!isMarkedFavourite);
  }

  Future<void> addPostToFavourite({required ArticlesModel articlesModel}) async {
    final prefs= await SharedPreferences.getInstance();
    final articles= await _loadsFavouritesFromPrefs();
    articles[articlesModel.id.toString()]= jsonEncode(articlesModel.toJson());
    print(articles);
    prefs.setString(Keys.favouriteArticles, jsonEncode(articles));
  }

  Future<void> removePostFromFavourite({required ArticlesModel articlesModel}) async {
    final prefs= await SharedPreferences.getInstance();
    final articles= await _loadsFavouritesFromPrefs();
    articles.remove(articlesModel.id.toString());
    prefs.setString(Keys.favouriteArticles, jsonEncode(articles));
  }

  Future<Map<String,dynamic>> _loadsFavouritesFromPrefs() async {
    final prefs= await SharedPreferences.getInstance();
    final json= prefs.getString(Keys.favouriteArticles);
    final articles= json!=null? jsonDecode(json) as Map<String,dynamic> : <String,dynamic>{};
    return articles;
  }
}