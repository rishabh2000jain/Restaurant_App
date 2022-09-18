import 'dart:convert';

import 'package:restaurant_app/app/api_response_wrapper.dart';
import 'package:restaurant_app/app/models/restaurant_menu/restaurant_menu_response_model.dart';
import 'package:restaurant_app/app/repository/restaurant_menu/restaurant_menu_repository.dart';
import 'package:flutter/services.dart' show rootBundle;
class RestaurantMenuRepositoryImpl extends RestaurantMenuRepository{
  @override
  Future<ApiResponseWrapper<RestaurantMenuResponseModel>> getRestaurantMenuList() async{
    ApiResponseWrapper<RestaurantMenuResponseModel> responseWrapper = ApiResponseWrapper();
    try{
      final data = await rootBundle.loadString('assets/data/restaurant_menu.json');
      final responseModel =  RestaurantMenuResponseModel.fromJson(jsonDecode(data));
      responseWrapper.setData(responseModel);
    }on Exception catch(error){
      responseWrapper.setException(error);
    }
    return responseWrapper;
  }
}