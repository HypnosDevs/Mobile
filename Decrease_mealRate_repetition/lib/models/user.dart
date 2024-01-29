import 'package:flutter/cupertino.dart';

import 'Food.dart';

class UserModel extends ChangeNotifier {
  List<Food> Users = [];

  void addUser(Food data) {
    Users.insert(0,data);
    notifyListeners();
  }
}
