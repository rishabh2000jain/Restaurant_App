import 'package:restaurant_app/app/models/restaurant_menu/restaurant_menu_response_model.dart';

abstract class RestaurantMenuEvents {}

class GetRestaurantEvent extends RestaurantMenuEvents {}

class AddItemInOrderEvent extends RestaurantMenuEvents {
  RestaurantMenuCategoryItemModel itemModel;

  AddItemInOrderEvent(this.itemModel);
}

class RemoveItemFromOrderEvent extends RestaurantMenuEvents {
  RestaurantMenuCategoryItemModel itemModel;

  RemoveItemFromOrderEvent(this.itemModel);
}

class PlaceOrderOrderEvent extends RestaurantMenuEvents {
  PlaceOrderOrderEvent();
}

class GetItemQuantityInOrderEvent extends RestaurantMenuEvents {
  int itemId;

  GetItemQuantityInOrderEvent(this.itemId);
}

class DeleteOrderSessionEvent extends RestaurantMenuEvents {
  DeleteOrderSessionEvent();
}
