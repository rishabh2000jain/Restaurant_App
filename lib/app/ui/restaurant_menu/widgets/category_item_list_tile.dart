import 'package:flutter/material.dart';
import 'package:restaurant_app/app/models/restaurant_menu/restaurant_menu_response_model.dart';
import 'package:restaurant_app/app/ui/restaurant_menu/widgets/update_order_item_quantity_button.dart';
import 'package:restaurant_app/resources/strings.dart';

class MenuCategoryItemTile extends StatelessWidget {
  const MenuCategoryItemTile({required this.menuCategoryItemModel, Key? key})
      : super(key: key);
  final RestaurantMenuCategoryItemModel menuCategoryItemModel;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
      height: 120,
      width: size.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    menuCategoryItemModel.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  if (menuCategoryItemModel.bestSeller) ...[
                    const SizedBox(
                      width: 10,
                    ),
                    Chip(
                      label: Text(
                        AppStrings.kBestSeller,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                  if (!menuCategoryItemModel.inStocks) ...[
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                        AppStrings.kOutOfStock,
                        style: TextStyle(
                            color:Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                  ],
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text('\$ ${menuCategoryItemModel.price.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.grey, fontSize: 18)),
            ],
          ),
          UpdateOrderItemQuantityButton(
            key: UniqueKey(),
            inStock: menuCategoryItemModel.inStocks,
            menuCategoryItemModel: menuCategoryItemModel,
          )
        ],
      ),
    );
  }
}
