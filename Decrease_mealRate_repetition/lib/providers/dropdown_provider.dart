import 'package:final_project/models/DropdownItem.dart';
import 'package:flutter/cupertino.dart';

class DropdownProvider extends ChangeNotifier {
  List<DropdownItem> selectedItem = [
    DropdownItem(selectedItem: "ชิกกี้ชิก")
  ];

  void addDropdown(DropdownItem item) {
    selectedItem.insert(0,item);
    notifyListeners();
  }

  void removeDropdown() {
    selectedItem.remove(0);
    notifyListeners();
  }
}