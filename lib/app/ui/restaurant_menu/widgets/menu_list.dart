import 'package:flutter/material.dart';
import 'package:restaurant_app/app/models/restaurant_menu/restaurant_menu_response_model.dart';
import 'package:restaurant_app/app/ui/restaurant_menu/widgets/menu_category_list_tile.dart';

class MenuList extends StatelessWidget {
  const MenuList({required this.menuCategory, Key? key}) : super(key: key);
  final List<RestaurantMenuCategoryModel> menuCategory;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: UniqueKey(),
      separatorBuilder: (BuildContext context, int index){
        return const Divider(thickness: 3,height: 0,);
      },
      itemCount: menuCategory.length,
      itemBuilder: (BuildContext context, int index) {
        return MenuCategory(
          category: menuCategory[index],
        );
      },
    );
  }
}