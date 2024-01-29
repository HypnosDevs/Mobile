import 'package:flutter/material.dart';

import '../../components/dropdown.dart';

class HistoryBar extends StatelessWidget {
  const HistoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.only(bottom: 20 * 2.5),
        // cover 20% of total height
        height: size.height * 0.2,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 35, right: 35, bottom: 36 + 15),
              height: size.height * 0.2 - 27,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36))),
              child: Row(
                children: <Widget>[
                  Text(
                    "History",
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontFamily: "Sriracha",
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Positioned(bottom: 0, left: 0, right: 0, child: DropDownList())
          ],
        ));
  }
}
