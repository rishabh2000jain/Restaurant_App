class RestaurantMenuResponseModel{

  List<RestaurantMenuCategoryModel> restaurantMenuCategories;

  RestaurantMenuResponseModel(this.restaurantMenuCategories);

  factory RestaurantMenuResponseModel.fromJson(Map<String,dynamic> json){
    List<RestaurantMenuCategoryModel> categories = [];
    json.forEach((key, value) {
      categories.add(RestaurantMenuCategoryModel.fromJson({key:value}));
    });
    return RestaurantMenuResponseModel(categories);
  }

  Map<String,dynamic> toJson() {
    Map<String,dynamic> restaurantMenu = {};
    for (var element in restaurantMenuCategories) {
      restaurantMenu[element.categoryName] = element.categoryItems;
    }
    return restaurantMenu;
  }

}


class RestaurantMenuCategoryModel{
  String categoryName;
  List<RestaurantMenuCategoryItemModel> categoryItems;

  RestaurantMenuCategoryModel(this.categoryItems,this.categoryName);

 factory RestaurantMenuCategoryModel.fromJson(Map<String,dynamic> json){
   List<RestaurantMenuCategoryItemModel> items = [];
   String name = json.keys.first;
   List<dynamic> itemsJson = json.values.first;
   for (var element in itemsJson) {
     items.add(RestaurantMenuCategoryItemModel.fromJson(element));
   }
   return RestaurantMenuCategoryModel(items,name);
  }

  Map<String,dynamic> toJson() => {categoryName:categoryItems};

}

class RestaurantMenuCategoryItemModel{
  int categoryItemId;
  String name;
  num price;
  bool inStocks;
  bool bestSeller;

  RestaurantMenuCategoryItemModel(this.categoryItemId,this.name,this.price,this.inStocks,[this.bestSeller=false]);

  factory RestaurantMenuCategoryItemModel.fromJson(Map<String,dynamic> json){
    return RestaurantMenuCategoryItemModel(json['id'],json['name'],json['price'],json['instock']);
  }

 Map<String,dynamic> toJson(){
    return {
      'id':categoryItemId,
      'name':name,
      'price':price,
      'instock':inStocks,
    };
  }

}