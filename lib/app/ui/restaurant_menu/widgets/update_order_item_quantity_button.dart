import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/app/bloc/restaurant_menu/restaurant_menu_bloc.dart';
import 'package:restaurant_app/app/bloc/restaurant_menu/restaurant_menu_events.dart';
import 'package:restaurant_app/app/bloc/restaurant_menu/restaurant_menu_states.dart';
import 'package:restaurant_app/app/models/restaurant_menu/order_model.dart';
import 'package:restaurant_app/app/models/restaurant_menu/restaurant_menu_response_model.dart';
import 'package:restaurant_app/resources/strings.dart';

class UpdateOrderItemQuantityButton extends StatefulWidget {
  const UpdateOrderItemQuantityButton({required this.inStock,required this.menuCategoryItemModel, Key? key})
      : super(key: key);
  final RestaurantMenuCategoryItemModel menuCategoryItemModel;
  final bool inStock;
  @override
  State<UpdateOrderItemQuantityButton> createState() => _UpdateOrderItemQuantityButtonState();
}

class _UpdateOrderItemQuantityButtonState extends State<UpdateOrderItemQuantityButton> {
  late RestaurantMenuBloc _restaurantMenuBloc;

  @override
  void initState() {
    _restaurantMenuBloc = BlocProvider.of<RestaurantMenuBloc>(context);
    _restaurantMenuBloc.add(GetItemQuantityInOrderEvent(widget.menuCategoryItemModel.categoryItemId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 120,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: widget.inStock?Theme.of(context).primaryColor:Colors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(16),),),
      child: BlocBuilder<RestaurantMenuBloc, RestaurantMenuStates>(
        buildWhen: (prevState,currState){
          if(currState is RestaurantMenuInitialState || currState is PlaceOrderOrderState){
            return true;
          }else if(currState is GetItemQuantityInOrderState && currState.data!=null && (currState.data as OrderItem).itemModel.categoryItemId == widget.menuCategoryItemModel.categoryItemId){
            return true;
          }
          return (currState is AddItemInOrderState || currState is RemoveItemFromOrderState) && (currState.data as OrderItem).itemModel.categoryItemId == widget.menuCategoryItemModel.categoryItemId;
        },
        builder: (context, state) {
          OrderItem? orderItem;
          if(state is AddItemInOrderState || state is RemoveItemFromOrderState || state is GetItemQuantityInOrderState){
            orderItem = (state.data as OrderItem?);
          }
          return _getButton(orderItem?.quantity??0);
        },
      ),
    );
  }

  Widget _getButton(int quantity){
    return AnimatedSwitcher(
      switchInCurve: Curves.linear,
      switchOutCurve: Curves.linear,
      duration: const Duration(milliseconds: 150),
      transitionBuilder: (Widget child,Animation<double> animation){
        return ScaleTransition(scale: animation,child: child,);
      },
      child:quantity<1 || !widget.inStock ?_getAddButton():_getUpdateOrderItemButton(context,quantity),
    );
  }

  Widget _getAddButton() {
    return SizedBox.expand(
      child: InkWell(
        key: UniqueKey(),
        onTap:  widget.inStock?(){
          _restaurantMenuBloc.add(AddItemInOrderEvent(widget.menuCategoryItemModel));
        }:null, child:  Center(child: Text(AppStrings.kAdd,style: TextStyle(color: widget.inStock?Theme.of(context).primaryColor:Colors.grey,fontSize: 20,fontWeight: FontWeight.w800,),textAlign: TextAlign.center,)),),
    );
  }

  Widget _getUpdateOrderItemButton(BuildContext context,int quantity) {
    return Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: () {
                _restaurantMenuBloc.add(RemoveItemFromOrderEvent(widget.menuCategoryItemModel));
              },
              child: Icon(Icons.remove,
                  color: Theme.of(context).primaryColor, size: 30),),
          Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle),
              child: Text(
                '$quantity',
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w900),
              )),
          InkWell(
              onTap: () {
                _restaurantMenuBloc.add(AddItemInOrderEvent(widget.menuCategoryItemModel));
              },
              child: Icon(Icons.add,
                  color: Theme.of(context).primaryColor, size: 30),),
        ],
      ),
    );
  }
}