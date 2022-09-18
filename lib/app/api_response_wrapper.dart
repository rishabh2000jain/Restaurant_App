
import 'package:equatable/equatable.dart';

///Wrap the API response model with this class to have efficient error handling.
///
//ignore: must_be_immutable
class ApiResponseWrapper<T> extends Equatable {
  Exception? _exception;
  T? _data;


  void setException(Exception? exception) {
    _exception = exception;
  }



  ApiResponseWrapper({T? data, Exception? error})
      : _data = data,
        _exception = error;

  void setData(T data) {
    _data = data;
  }

  T? get getData => _data;

  Exception? get getException => _exception;



  bool get hasException => _exception != null;

  bool get hasData => _data != null;

  @override
  List<Object?> get props => [_data, _exception];
}
