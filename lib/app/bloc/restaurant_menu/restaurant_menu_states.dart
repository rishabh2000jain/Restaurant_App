import 'package:restaurant_app/app/bloc/bloc_common_state.dart';

abstract class RestaurantMenuStates<T> extends ApiState<T> {
  const RestaurantMenuStates.loading(String message,
      {T? data, Exception? error})
      : super.loading(message, error: error, data: data);

  const RestaurantMenuStates.completed(T? data,
      {Exception? error, String? message})
      : super.completed(data, message: message, error: error);

  const RestaurantMenuStates.error(Exception? error, {String? message, T? data})
      : super.error(error, data: data, message: message);
}

class RestaurantMenuInitialState<T> extends RestaurantMenuStates<T> {
  const RestaurantMenuInitialState.completed(T? data,
      {Exception? error, String? message})
      : super.completed(data, message: message, error: error);

  @override
  List<Object?> get props => [status, data, error, message];
}

class GetRestaurantMenuState<T> extends RestaurantMenuStates<T> {
  const GetRestaurantMenuState.loading(String message,
      {T? data, Exception? error})
      : super.loading(message, error: error, data: data);

  const GetRestaurantMenuState.complete(T data,
      {Exception? error, String? message})
      : super.completed(data, message: message, error: error);

  const GetRestaurantMenuState.error(Exception? error,
      {String? message, T? data})
      : super.error(error, data: data, message: message);

  @override
  List<Object?> get props => [status, data, error, message];
}

class AddItemInOrderState<T> extends RestaurantMenuStates<T> {
  const AddItemInOrderState.loading(String message, {T? data, Exception? error})
      : super.loading(message, error: error, data: data);

  const AddItemInOrderState.complete(T data,
      {Exception? error, String? message})
      : super.completed(data, message: message, error: error);

  const AddItemInOrderState.error(Exception? error, {String? message, T? data})
      : super.error(error, data: data, message: message);

  @override
  List<Object?> get props => [status, data, error, message];
}

class RemoveItemFromOrderState<T> extends RestaurantMenuStates<T> {
  const RemoveItemFromOrderState.loading(String message,
      {T? data, Exception? error})
      : super.loading(message, error: error, data: data);

  const RemoveItemFromOrderState.complete(T data,
      {Exception? error, String? message})
      : super.completed(data, message: message, error: error);

  const RemoveItemFromOrderState.error(Exception? error,
      {String? message, T? data})
      : super.error(error, data: data, message: message);

  @override
  List<Object?> get props => [status, data, error, message];
}

class PlaceOrderOrderState<T> extends RestaurantMenuStates<T> {
  const PlaceOrderOrderState.loading(String message,
      {T? data, Exception? error})
      : super.loading(message, error: error, data: data);

  const PlaceOrderOrderState.complete(T data,
      {Exception? error, String? message})
      : super.completed(data, message: message, error: error);

  const PlaceOrderOrderState.error(Exception? error, {String? message, T? data})
      : super.error(error, data: data, message: message);

  @override
  List<Object?> get props => [status, data, error, message];
}

class DeleteOrderSessionState<T> extends RestaurantMenuStates<T> {
  const DeleteOrderSessionState.loading(String message,
      {T? data, Exception? error})
      : super.loading(message, error: error, data: data);

  const DeleteOrderSessionState.complete(T? data,
      {Exception? error, String? message})
      : super.completed(data, message: message, error: error);

  const DeleteOrderSessionState.error(Exception? error,
      {String? message, T? data})
      : super.error(error, data: data, message: message);

  @override
  List<Object?> get props => [status, data, error, message];
}

class UpdateCurrentCostState<T> extends RestaurantMenuStates<T> {
  const UpdateCurrentCostState.complete(T data,
      {Exception? error, String? message})
      : super.completed(data, message: message, error: error);

  @override
  List<Object?> get props => [status, data];
}

class GetItemQuantityInOrderState<T> extends RestaurantMenuStates<T> {
  const GetItemQuantityInOrderState.complete(T data,
      {Exception? error, String? message})
      : super.completed(data, message: message, error: error);

  @override
  List<Object?> get props => [status, data];
}
