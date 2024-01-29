import 'package:final_project/models/DropdownItem.dart';
import 'package:final_project/providers/dropdown_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

var store = '8;p';

class DropDownList extends StatefulWidget {
  const DropDownList({super.key});

  
  @override
  State<DropDownList> createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
  List<String> shop = ["ทั้งหมด", "ชิกกี้ชิก", "ร้านก๋วยเตี๋ยวนายหนวด", "ร้านข้าวแกงปักษ์ใต้"];
  String selectedItem = 'ทั้งหมด';
  /*void initState() {
    var dropdownProvider = Provider.of<DropdownProvider>(context, listen: false);
    //dropdownProvider.addDropdown(DropdownItem(selectedItem: selectedItem));
    super.initState();
  }*/
  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 54),
      height: 36,
      //color: Colors.white,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 10),
                blurRadius: 3,
                color: Colors.black.withOpacity(0.1)),
          ]),
      child: DropdownButton<String>(
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(20),
          underline: DropdownButtonHideUnderline(child: Container()),
          isExpanded: true,
          value: selectedItem,
          items: shop
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Center(
                        child: Text(item,
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Sriracha',
                            ))),
                  ))
              .toList(),
          onChanged: (item) {

            setState(() { 
            store = item!;
            print(item);
            var dropdownProvider = Provider.of<DropdownProvider>(context, listen: false);
          
              dropdownProvider.removeDropdown();


              selectedItem = item;
             // print(selectedItem);
            dropdownProvider.addDropdown(DropdownItem(selectedItem: item));
           // print(dropdownProvider.selectedItem);
              });
          }),
    );
  }
}
