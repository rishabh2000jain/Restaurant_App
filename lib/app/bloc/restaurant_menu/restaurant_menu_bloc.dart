import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/app/api_response_wrapper.dart';
import 'package:restaurant_app/app/bloc/restaurant_menu/restaurant_menu_events.dart';
import 'package:restaurant_app/app/bloc/restaurant_menu/restaurant_menu_states.dart';
import 'package:restaurant_app/app/models/restaurant_menu/order_model.dart';
import 'package:restaurant_app/app/models/restaurant_menu/restaurant_menu_response_model.dart';
import 'package:restaurant_app/app/repository/restaurant_menu/restaurant_menu_repository.dart';
import 'package:restaurant_app/app/repository/restaurant_menu/restaurant_menu_repository_impl.dart';
import 'package:collection/collection.dart';

class RestaurantMenuBloc
    extends Bloc<RestaurantMenuEvents, RestaurantMenuStates> {
  static const int _kPopularItemsCount = 3;

  late RestaurantOrdersModel _orders;
  late RestaurantMenuRepository _restaurantMenuRepository;

  RestaurantOrderModel? _currentOrder;
  RestaurantMenuResponseModel? _restaurantMenuResponseModel;

  RestaurantMenuBloc(RestaurantMenuStates initialState) : super(initialState) {
    _orders = RestaurantOrdersModel([]);
    _restaurantMenuRepository = RestaurantMenuRepositoryImpl();
    on<AddItemInOrderEvent>(_addItemToOrder);
    on<RemoveItemFromOrderEvent>(_removeItemFromOrder);
    on<DeleteOrderSessionEvent>(_deleteOrderSession);
    on<PlaceOrderOrderEvent>(_placeOrder);
    on<GetRestaurantEvent>(_getRestaurantMenu);
    on<GetItemQuantityInOrderEvent>(_currentItemQuantityInOrder);
  }

  Future<void> _getRestaurantMenu(
      GetRestaurantEvent event, Emitter emit) async {
    emit(const GetRestaurantMenuState.loading(''));
    ApiResponseWrapper<RestaurantMenuResponseModel> apiResponseWrapper =
        await _restaurantMenuRepository.getRestaurantMenuList();
    if (apiResponseWrapper.hasData) {
      _restaurantMenuResponseModel = apiResponseWrapper.getData;
      emit(GetRestaurantMenuState<List<RestaurantMenuCategoryModel>>.complete(
          _mergePopularAndOtherCategories(_restaurantMenuResponseModel!)));
    } else {
      emit(GetRestaurantMenuState.error(apiResponseWrapper.getException,
          message: apiResponseWrapper.getException.toString()));
    }
  }

  void _createOrderSession() {
    _currentOrder ??= RestaurantOrderModel([]);
  }

  void _addItemToOrder(AddItemInOrderEvent event, Emitter emit) {
    if (_currentOrder == null) {
      _createOrderSession();
    }
    OrderItem orderItem = _currentOrder!.orderItems.firstWhere(
        (categoryItem) =>
            categoryItem.itemModel.categoryItemId ==
            event.itemModel.categoryItemId,
        orElse: () => OrderItem(itemModel: event.itemModel, quantity: 0));

    orderItem.quantity += 1;
    //If the ordered item is not present in the current order
    if (orderItem.quantity == 1) {
      _currentOrder!.orderItems.add(orderItem);
    }
    emit(AddItemInOrderState<OrderItem>.complete(orderItem));
    emit(UpdateCurrentCostState<num>.complete(_getUpdatedCost()));
  }

  void _removeItemFromOrder(RemoveItemFromOrderEvent event, Emitter emit) {
    if (_currentOrder == null) {
      return;
    }
    OrderItem orderItem = _currentOrder!.orderItems.firstWhere(
        (categoryItem) =>
            categoryItem.itemModel.categoryItemId ==
            event.itemModel.categoryItemId,
        orElse: () => OrderItem(itemModel: event.itemModel, quantity: 0));

    orderItem.quantity -= 1;
    //If the removed ordered item count is 0
    if (orderItem.quantity <= 0) {
      _currentOrder!.orderItems.remove(orderItem);
    }
    emit(AddItemInOrderState<OrderItem>.complete(orderItem));
    emit(UpdateCurrentCostState<num>.complete(_getUpdatedCost()));

    if (_currentOrder?.orderItems.isEmpty ?? false) {
      add(DeleteOrderSessionEvent());
    }
  }

  void _deleteOrderSession(DeleteOrderSessionEvent event, Emitter emit) {
    _currentOrder = RestaurantOrderModel([]);
    emit(const DeleteOrderSessionState.complete(null));
  }

  void _placeOrder(PlaceOrderOrderEvent event, Emitter emit) {
    if (_currentOrder == null) {
      return;
    }
    _updateBestSellerAndPopularItems();
    _orders.myOrders.add(_currentOrder!);
    emit(const PlaceOrderOrderState.complete(null));
    add(DeleteOrderSessionEvent());
  }

  void _currentItemQuantityInOrder(
      GetItemQuantityInOrderEvent event, Emitter emit) {
    final orderItem = _currentOrder?.orderItems.firstWhereOrNull(
        (element) => element.itemModel.categoryItemId == event.itemId);
    emit(GetItemQuantityInOrderState<OrderItem?>.complete(orderItem));
  }

  num _getUpdatedCost() {
    num currentCost = 0;
    //ignore:avoid_function_literals_in_foreach_calls
    _currentOrder?.orderItems.forEach((element) {
      currentCost += (element.quantity * element.itemModel.price);
    });
    return currentCost;
  }

  void _updatePopularItems() {
    if (_currentOrder == null) return;

    HeapPriorityQueue<OrderItem> priorityQueue = HeapPriorityQueue(
      (p0, p1) => p0.quantity.compareTo(p1.quantity),
    );

    for (var value in _currentOrder!.orderItems) {
      if (_orders.popularItemMap[value.itemModel.categoryItemId] == null) {
        _orders.popularItemMap[value.itemModel.categoryItemId] = value;
      } else {
        _orders.popularItemMap[value.itemModel.categoryItemId]!.quantity +=
            value.quantity;
      }
    }

    //ignore:avoid_function_literals_in_foreach_calls
    _orders.popularItemMap.values.forEach((orderItem) {
      priorityQueue.add(orderItem);
    });

    //remove totalItems - _POPULAR_ITEMS_COUNT from list so remaining are top _POPULAR_ITEMS_COUNT items
    while(priorityQueue.length > _kPopularItemsCount) {
      priorityQueue.removeFirst();
    }

    _orders.popularItemMap.clear();

    priorityQueue.toList().forEach((element) {
      _orders.popularItemMap[element.itemModel.categoryItemId] = element;
    });
  }

  void _updateBestSellerItem() {
    if (_orders.popularItemMap.isEmpty) {
      return;
    }
    _orders.bestSellerItemId =
        _orders.popularItemMap.values.last.itemModel.categoryItemId;
  }

  void _updateBestSellerAndPopularItems() {
    _updatePopularItems();
    _updateBestSellerItem();
  }

  List<RestaurantMenuCategoryModel> _mergePopularAndOtherCategories(
      RestaurantMenuResponseModel model) {
    List<RestaurantMenuCategoryModel> menu = [];

    RestaurantMenuCategoryModel popularCategory =
        RestaurantMenuCategoryModel([], 'Popular Items');
    if (_orders.popularItemMap.isNotEmpty) {
      _orders.popularItemMap.forEach((key, element) {
        popularCategory.categoryItems.add(element.itemModel);
        element.itemModel.bestSeller =
            element.itemModel.categoryItemId == _orders.bestSellerItemId;
      });
    }
    if (popularCategory.categoryItems.isNotEmpty) {
      menu.add(popularCategory);
    }
    model.restaurantMenuCategories
        .sort((cat1, cat2) => cat1.categoryName.compareTo(cat2.categoryName));
    menu.addAll(_restaurantMenuResponseModel!.restaurantMenuCategories);
    return menu;
  }
}
