import 'package:flutter/material.dart';

class Favourite extends StatelessWidget {
  const Favourite({
    Key? key,
    required this.sname,
    required this.fname,
    required this.press,
    required this.img,
  }) : super(key: key);

  final Function press;
  final String sname;
  final String fname;
  final String img;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: size.width * 0.4,
          child: Column(children: <Widget>[
            Container(
              height: size.height * 0.15,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(img),
                      fit: BoxFit.fill),
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
            ),
            Container(
              width: size.width * 0.4,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 8,
                      color: Colors.black.withOpacity(0.2))
                ],
              ),
              child: SizedBox(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: fname.toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .button
                            ?.copyWith(fontFamily: "Sriracha"),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ])),
    );
  }
}
