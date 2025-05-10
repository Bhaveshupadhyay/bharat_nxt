import 'package:bharat_nxt/models/articles_model.dart';
import 'package:bharat_nxt/models/failure.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class Api{
  final _dio= Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
    )
  );
  
  Future<Either<Failure,List<ArticlesModel>>> getArticles() async {

    try{
      final res= await _dio.get('/posts');
      if(res.statusCode==200){
        List<ArticlesModel> list=[];
        for(var json in res.data){
          list.add(ArticlesModel.fromJson(json));
        }
        return right(list);
      }
      else{
        return left(Failure(res.statusMessage));
      }
    }
    on DioException catch(e){
      return left(Failure(e.message));
    }
    catch(e){
      return left(Failure(e.toString()));
    }

  }
}