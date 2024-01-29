import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/DropdownItem.dart';
import 'package:final_project/providers/dropdown_provider.dart';
import 'package:final_project/providers/food_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;

List<String> shop = [
  "ทั้งหมด",
  "ชิกกี้ชิก",
  "ร้านก๋วยเตี๋ยวนายหนวด",
  "ร้านข้าวแกงปักษ์ใต้",
  "ร้านแม่น้องพันช์"
];
String selectedItem = 'ทั้งหมด';

var store = 'ทั้งหมด';

class RatingContext extends StatefulWidget {
  const RatingContext({super.key});

  @override
  State<RatingContext> createState() => _RatingContextState();
}

class _RatingContextState extends State<RatingContext> {
  @override
  Widget build(BuildContext context) {
    var foodForm = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('foodsForm');
    return Column(
          children: <Widget>[
                          Container(
                      margin: EdgeInsets.only(bottom: 20 * 2.5),
                      // cover 20% of total height
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                left: 35, right: 35, bottom: 36 + 15),
                            height:
                                MediaQuery.of(context).size.height * 0.2 - 27,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(36),
                                    bottomRight: Radius.circular(36))),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Form",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(
                                          fontFamily: "Sriracha",
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
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
                                    underline: DropdownButtonHideUnderline(
                                        child: Container()),
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
                                      print('----------------------');
                                      setState(() {
                                        store = item!;
                                        // print("");
                                        var dropdownProvider =
                                            Provider.of<DropdownProvider>(
                                                context,
                                                listen: false);

                                        dropdownProvider.removeDropdown();

                                        selectedItem = item;
                                        // print(selectedItem);
                                        dropdownProvider.addDropdown(
                                            DropdownItem(selectedItem: item));
                                        // print(dropdownProvider.selectedItem);
                                      });
                                    }),
                              ))
                        ],
                      )),
 FutureBuilder(
              future: foodForm.get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: 500,
                    width: double.infinity,
                    child: ListView.builder(
                      primary: false,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var tmp = Provider.of<FoodProvider>(context, listen: false);
                        if (store == 'ทั้งหมด' ||
                            store ==
                                snapshot.data!.docs[index].data()['sname']) {
                          if (snapshot.data!.docs[index].data()['meat'] ==
                              '-') {
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 28,
                                  backgroundImage:
                                      AssetImage("${tmp.foods[tmp.foods.indexWhere((element) => element.sname+element.fname+element.meat==snapshot.data!.docs[index].data()['sname']+
                          snapshot.data!.docs[index].data()['fname']+snapshot.data!.docs[index].data()['meat'])].img}"),
                                ),
                                title: Text(
                                  snapshot.data!.docs[index].data()['sname'],
                                  style: TextStyle(fontFamily: "Sriracha"),
                                ),
                                subtitle: Text(
                                  snapshot.data!.docs[index].data()['fname'],
                                  style: TextStyle(fontFamily: "Sriracha"),
                                ),
                              ),
                            );
                          }
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 28,
                                backgroundImage:
                                    AssetImage("${tmp.foods[tmp.foods.indexWhere((element) => element.sname+element.fname+element.meat==snapshot.data!.docs[index].data()['sname']+
                          snapshot.data!.docs[index].data()['fname']+snapshot.data!.docs[index].data()['meat'])].img}"),
                              ),
                              title: Text(
                                snapshot.data!.docs[index].data()['sname'],
                                style: TextStyle(fontFamily: "Sriracha"),
                              ),
                              subtitle: Text(
                                snapshot.data!.docs[index].data()['fname'] +
                                    snapshot.data!.docs[index].data()['meat'],
                                style: TextStyle(fontFamily: "Sriracha"),
                              ),
                            ),
                          );
                        }
                        return Container(
                          width: 0,
                          height: 0,
                        );
                      },
                    ),
                  );
                } else {
                  return Center(child: Text('Loading...',style: TextStyle(fontSize: 20)),); //Scaffold( backgroundColor: Colors.orange,body:Container(height: 20,child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [Text('Loading Data'),SizedBox(height: 20,),CircularProgressIndicator(color: Colors.black,backgroundColor: Colors.grey,)]),)));
                }
              },
            ),
          ],
        );
  }
}
