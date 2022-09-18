import 'package:flutter/material.dart';
import 'package:restaurant_app/app/models/restaurant_menu/restaurant_menu_response_model.dart';
import 'package:restaurant_app/app/ui/restaurant_menu/widgets/category_item_list_tile.dart';

class MenuCategory extends StatefulWidget {
  const MenuCategory({
    Key? key,
    required this.category,
  }) : super(key: key);

  final RestaurantMenuCategoryModel category;

  @override
  State<MenuCategory> createState() => _MenuCategoryState();
}

class _MenuCategoryState extends State<MenuCategory>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        reverseDuration: const Duration(milliseconds: 500),
        duration: const Duration(milliseconds: 500),
        lowerBound: 0.0,
        upperBound: 0.2);
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 70,
      ),
      child: ExpansionTile(
        backgroundColor: theme.tertiary,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16,),
        onExpansionChanged: (expanded) {
          if (expanded) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.category.categoryItems.length.toString(),style: TextStyle(fontSize: 18,color:Colors.grey.shade400,),),
            RotationTransition(
              turns: _animation,
              child: Icon(Icons.keyboard_arrow_right, size:40,key: UniqueKey(),color: Colors.grey.shade400,),
            )
          ],
        ),
        title: Text(
            widget.category.categoryName,
            style: const TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w500,)
        ),
        children: widget.category.categoryItems
            .map((e) => MenuCategoryItemTile(
          menuCategoryItemModel: e,
        ),).toList(),
      ),
    );
  }
}

