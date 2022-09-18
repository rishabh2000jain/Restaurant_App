import 'package:restaurant_app/app/models/restaurant_menu/restaurant_menu_response_model.dart';

class RestaurantOrdersModel {
  int? bestSellerItemId;
  Map<int, OrderItem> popularItemMap = {};
  List<RestaurantOrderModel> myOrders;

  RestaurantOrdersModel(this.myOrders, {this.bestSellerItemId});
}

class RestaurantOrderModel {
  List<OrderItem> orderItems;

  RestaurantOrderModel(this.orderItems);
}

class OrderItem {
  int quantity;
  RestaurantMenuCategoryItemModel itemModel;

  OrderItem({required this.itemModel, required this.quantity});
}
