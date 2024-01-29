import 'package:flutter/material.dart';
import 'screens/components/dropdown.dart';

// ignore: non_constant_identifier_names
Container HeaderWithDropDown(Size size, BuildContext context, String string) {
  return Container(
      margin: const EdgeInsets.only(bottom: 10),
      // cover 20% of total height
      height: size.height * 0.2,
      child: Stack(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.only(left: 35, right: 35, bottom: 36 + 15),
            height: size.height * 0.2 - 27,
            decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36))),
            child: Row(
              children: <Widget>[
                Text(
                  string,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 30,
                      fontFamily: 'Sriracha',
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          //Positioned(bottom: 0, left: 0, right: 0, child: DropDownList())
        ],
      ));
}
