import 'package:restaurant_app/app/api_response_wrapper.dart';
import 'package:restaurant_app/app/models/restaurant_menu/restaurant_menu_response_model.dart';

abstract class RestaurantMenuRepository{
  Future<ApiResponseWrapper<RestaurantMenuResponseModel>> getRestaurantMenuList();
}