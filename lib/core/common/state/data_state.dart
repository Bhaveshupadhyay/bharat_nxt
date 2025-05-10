import 'package:bharat_nxt/models/failure.dart';

sealed class DataState{}

class DataInitial extends DataState{}
class DataLoading extends DataState{}
class DataLoaded<T> extends DataState{
  final T data;

  DataLoaded({required this.data});
}
class DataLoadFailed extends DataState{
  final Failure failure;
  DataLoadFailed({required this.failure});
}