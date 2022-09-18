
import 'package:equatable/equatable.dart';

/// Generic class for the states
abstract class ApiState<T> extends Equatable {
  final Status status;
  final T? data;
  final dynamic message;
  final Exception? error;

  const ApiState.loading(this.message, {this.data, this.error})
      : status = Status.loading;

  const ApiState.completed(this.data, {this.message, this.error})
      : status = Status.completed;

  const ApiState.error(this.error, {this.data, this.message}) : status = Status.error;

  @override
  String toString() {
    return 'Status : $status \n Message : $message \n Data : $data';
  }
}

enum Status {
  loading,
  completed,
  error,
}
