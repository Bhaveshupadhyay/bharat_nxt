import 'package:bharat_nxt/core/common/state/data_state.dart';
import 'package:bharat_nxt/models/articles_model.dart';
import 'package:bharat_nxt/services/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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


}