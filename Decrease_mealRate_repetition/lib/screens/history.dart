import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'components/body.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<String> shop = ['All', 'Chickychic', 'yalamai', 'noodle'];
  String? selectedItem = 'Chickychic';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppbar(),
        body:
            Body() /*Column(
        children: [
          SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: ((context, index) {
                  return Container(
                    height: 10,
                    width: 10,
                    color: Colors.amber,
                  );
                }),
              ))
        ],
      ),*/
        );
  }

  AppBar buildAppbar() {
    return AppBar(
      backgroundColor: Colors.orange,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop((context));
        },
        icon: Icon(
          Icons.arrow_back,
        ),
        iconSize: 24,
        splashRadius: 16.0,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
    );
  }
}
