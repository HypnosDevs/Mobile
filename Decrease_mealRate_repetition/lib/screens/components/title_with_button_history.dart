import 'package:flutter/material.dart';
import 'package:final_project/screens/subscreen/main_History.dart';
import 'package:final_project/screens/subscreen/subcomponents/main_body_Favourite.dart';

import '../subscreen/main_Favourite.dart';
import '../subscreen/subcomponents/main_body_History.dart';

class TiltleWithButtonHistory extends StatelessWidget {
  const TiltleWithButtonHistory({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Title(text: title),
          Spacer(),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                textStyle: TextStyle(fontSize: 20),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20)),
                primary: Colors.amber,
                side: BorderSide(width: 1, color: Colors.amber)),
            child: Text(
              "More",
              style: TextStyle(fontFamily: "Sriracha"),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AllHistory()),
              );
            },
          )
        ],
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20 / 4 - 5),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Sriracha"),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(right: 20 / 4),
              height: 7,
              color: Colors.amber.withOpacity(0.2),
            ),
          )
        ],
      ),
    );
  }
}
