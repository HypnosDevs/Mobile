import 'package:final_project/models/Food.dart';
import 'package:flutter/cupertino.dart';

class FoodForm extends ChangeNotifier {
  List<Food> foodform = [];

  List<Food> display() {
    return foodform;
  }

  void addFoodForm(Food food) {
    foodform.add(food);
    notifyListeners();
  }

  void test() {
    print(foodform.length);
  }
}
