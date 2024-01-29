import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/menu_page.dart';
import 'package:final_project/providers/dropdown_provider.dart';
import 'package:final_project/providers/food_form_provider.dart';
import 'package:final_project/providers/food_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/DropdownItem.dart';
import 'models/Food.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class CheckBoxState {
  final String title;
  String sname;
  int meatCount;
  bool value;
  bool isVisible = false;
  bool click = true;

  CheckBoxState({
    required this.sname,
    required this.title,
    required this.meatCount,
    this.value = false,
  });

  @override
  String toString() => "title:{$title},value:{$value},";
}

class _FormPageState extends State<FormPage> {
  // clearForm() async {
  //   final FirebaseAuth auth = FirebaseAuth.instance;
  //   final User? user = auth.currentUser;
  //   await FirebaseFirestore.instance
  //     .collection('users')
  //         .doc(user!.uid)
  //         .collection('foodsForm')
  //         .snapshots()
  //         .forEach((querySnapshot) {
  //       for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
  //         docSnapshot.reference.delete();
  //       }
  //     });
  // }

  Future<void> clearForm() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    var collection = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('foodsForm');

    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      var foods = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('foodsRate')
          .where('name', isEqualTo: doc['sname'] + doc['fname'] + doc['meat']);
      foods.get().then((ele) {
        var obj = ele.docs[0];
        obj.reference.update({'rate': ele.docs[0]['rate'] - 19});
        obj.reference.update({'updatedForm': false});
      });

      await doc.reference.delete();
    }
  }

  bool isLoading = true;

  List<String> shop = [
    "ชิกกี้ชิก",
    "ร้านก๋วยเตี๋ยวนายหนวด",
    "ร้านข้าวแกงปักษ์ใต้",
    "ร้านแม่น้องพันช์"
  ];
  String selectedItem = 'ชิกกี้ชิก';

  static List<CheckBoxState> allNotifications = [];
  static List<CheckBoxState> notifications = [];

  var cntMeat = 0;
  var cntMenu = 0;
  var tmp = 0;
  var tmpCntMenu = 0;
  var st = 0;
  var sum = 0;
  var foodsum = 0;

  bool clicked = false;

  //point for add meat
  var run = -1;
  var ch = 1;
  @override
  Widget build(BuildContext context) =>
      Consumer(builder: (context, FoodProvider foodProvider, child) {
        final FirebaseAuth auth = FirebaseAuth.instance;
        final User? user = auth.currentUser;
        return isLoading
            ? Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.orange,
                  elevation: 0,
                  //automaticallyImplyLeading: false,
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    print(foodProvider.foods[1]);
                    await clearForm();
                    setState(() {
                      isLoading = false;
                    });
                    if (clicked == false) {
                      clicked = true;
                      var start = 0;
                      var mapProvider =
                          Provider.of<FoodProvider>(context, listen: false);
                      var provider =
                          Provider.of<FoodForm>(context, listen: false);

                      mapProvider.foodsRate.clear();
                      for (var i = 0; i < foodProvider.foods.length - 1; i++) {
                        String fill = foodProvider.foods[i].sname +
                            foodProvider.foods[i].fname +
                            foodProvider.foods[i].meat;
                        // print(fill);
                        mapProvider.foodsRate[fill] = 1;
                        //print(mapProvider.foodsRate);
                      }

                      for (var idxMenu = 0;
                          idxMenu < allNotifications.length;
                          idxMenu++) {
                        if (allNotifications[idxMenu].meatCount + start <
                            allNotifications.length) {
                          for (var idxMeat = start;
                              idxMeat <
                                  allNotifications[idxMenu].meatCount + start;
                              idxMeat++) {
                            if (notifications[idxMeat].value == true) {
                              foodsum += 199;
                              await createFoodForm(
                                  uid: user!.uid,
                                  sname: foodProvider.foods[idxMeat].sname,
                                  fname: foodProvider.foods[idxMeat].fname,
                                  meat: foodProvider.foods[idxMeat].meat,
                                  index: idxMeat);

                              Food foodData = Food(
                                  sname: allNotifications[idxMenu].sname,
                                  fname: allNotifications[idxMenu].title,
                                  meat: notifications[idxMeat].title,
                                  date: DateTime.now());

                              provider.addFoodForm(foodData);
                              mapProvider.foodsRate[foodData.sname +
                                  foodData.fname +
                                  foodData.meat] = 20;

                              String fill = foodProvider.foods[idxMeat].sname +
                                  foodProvider.foods[idxMeat].fname +
                                  foodProvider.foods[idxMeat].meat;
                              // print(fill);

                              final docUser = FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .collection('foodsRate')
                                  .doc('${idxMeat}');

                              /*await createFoodForm(uid: user.uid, sname: foodProvider.foods[idxMeat].sname, fname:  foodProvider.foods[idxMeat].fname, meat: foodProvider.foods[idxMeat].meat, index: idxMeat);*/

                              var food = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .collection('foodsRate')
                                  .where('name', isEqualTo: fill)
                                  .get();

                              DocumentReference documentReference = docUser;

                              documentReference.get().then(
                                (datasnapshot) async {
                                  if (datasnapshot.exists) {
                                    if (food.docs[0]['updatedForm'] == false) {
                                      await docUser.update(
                                        {
                                          'rate': food.docs[0]['rate'] + 199,
                                          'allergic': false,
                                          'updatedForm': true
                                        },
                                      );
                                    }
                                  } else {
                                    await createUser(
                                        uid: user.uid,
                                        name: fill,
                                        rate: 200,
                                        index: idxMeat);
                                  }
                                },
                              );

                              // createUser(uid: user!.uid, name: fill, rate: 20, index: idxMeat);
                              //print(mapProvider.foodsRate);
                            }
                            //test.add(foodData); add filed formvalue;
                          }
                        }

                        start += allNotifications[idxMenu].meatCount;
                      }

                      // print(mapProvider.foodsRate);
                      mapProvider.size = mapProvider.foodsRate.length + sum;
                      var collection =
                          FirebaseFirestore.instance.collection('users');
                      var userVal = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user!.uid);
                      var value;
                      var docSnapshot = await collection.doc(user.uid).get();
                      if (docSnapshot.exists) {
                        Map<String, dynamic>? data = docSnapshot.data();
                        value = data?['valuedForm'];
                        //sum += value as int; // <-- The value you want to retrieve.
                        userVal.update({'valuedForm': foodsum});
                        print("hihihihiihihhih");
                        print(foodsum);
                        // Call setState if needed.
                      }

                      final docUser = FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid);
                      await docUser.update({'formPage': false});

                      foodsum = 0;

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const MenuPage();
                          },
                        ),
                      );
                    }
                  },
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.check),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                    MediaQuery.of(context).size.height * 0.2 -
                                        27,
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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 54),
                                    height: 36,
                                    //color: Colors.white,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0, 10),
                                              blurRadius: 3,
                                              color: Colors.black
                                                  .withOpacity(0.1)),
                                        ]),
                                    child: DropdownButton<String>(
                                        dropdownColor: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        underline: DropdownButtonHideUnderline(
                                            child: Container()),
                                        isExpanded: true,
                                        value: selectedItem,
                                        items: shop
                                            .map((item) =>
                                                DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Center(
                                                      child: Text(item,
                                                          style: TextStyle(
                                                            fontSize: 24,
                                                            fontFamily:
                                                                'Sriracha',
                                                          ))),
                                                ))
                                            .toList(),
                                        onChanged: (item) {
                                          cntMenu = 0;
                                          print('----------------------');
                                          setState(() {
                                            // print("");
                                            var dropdownProvider =
                                                Provider.of<DropdownProvider>(
                                                    context,
                                                    listen: false);

                                            dropdownProvider.removeDropdown();

                                            selectedItem = item!;
                                            // print(selectedItem);
                                            dropdownProvider.addDropdown(
                                                DropdownItem(
                                                    selectedItem: item));
                                            // print(dropdownProvider.selectedItem);
                                          });
                                        }),
                                  ))
                            ],
                          )),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: foodProvider.foods.length,
                          itemBuilder: (context, int index) {
                            var len = foodProvider.foods.length;
                            var dropdownProvider =
                                Provider.of<DropdownProvider>(context,
                                    listen: false);
                            //print(len);

                            cntMeat++;
                            //print(allNotifications[10]);
                            if (index < len - 1 &&
                                (foodProvider.foods[index].fname !=
                                    foodProvider.foods[index + 1].fname)) {
                              //x = a[i-1];
                              Food data = foodProvider.foods[index];
                              cntMenu++;
                              //notifications.clear();
                              allNotifications.add(CheckBoxState(
                                  title: foodProvider.foods[index].fname,
                                  sname: foodProvider.foods[index].sname,
                                  meatCount: cntMeat));

                              //add meat for each menu
                              for (var i = run + 1; i <= run + cntMeat; i++) {
                                ch = 1;
                                if (i < len) {
                                  ch = 0;
                                  notifications.add(CheckBoxState(
                                      title: foodProvider.foods[i].meat,
                                      sname: foodProvider.foods[i].sname,
                                      meatCount: 1));
                                  //print(i);
                                }
                              }
                              //set start point to add mean for each menu
                              if (ch == 0) {
                                ch = 1;
                                run = index;
                              }

                              tmp = cntMeat;
                              cntMeat = 0;
                              //print("kuy"+(index-tmp+1).toString());
                              //print(index);
                              st = index;

                              if (index - tmp + 1 < 0) index++;
                              if (dropdownProvider
                                      .selectedItem[0].selectedItem ==
                                  data.sname) {
                                //print("object");
                                //print(cntMenu-1);
                                return buildMenuCheckbox(data.fname,
                                    index - tmp + 1, st + 1, cntMenu - 1);
                              }
                              return SizedBox.shrink();
                            }
                            return SizedBox.shrink();
                          })
                    ],
                  ),
                ))
            : Scaffold(
                backgroundColor: Colors.orange,
                body: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Loading Data', style: TextStyle(fontSize: 20)),
                        SizedBox(
                          height: 20,
                        ),
                        CircularProgressIndicator(
                          color: Colors.black,
                          backgroundColor: Colors.grey,
                        )
                      ]),
                ));
        ;
      });

  Widget buildSingleCheckbox(CheckBoxState checkbox) => CheckboxListTile(
        contentPadding: const EdgeInsets.only(left: 40),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Colors.orange,
        value: checkbox.value,
        title: Text(
          checkbox.title,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'Sriracha',
            color: Colors.black,
          ),
        ),
        onChanged: (value) => setState(() {
          if (value == true) {
            sum += 199;
          } else {
            sum -= 199;
          }
          print('this is sum');
          print(sum);
          cntMenu = 0;
          checkbox.value = value!;
        }),
      );

  Widget buildGroupCheckbox(int idx, int start, int end) => Checkbox(
        activeColor: Colors.orange,
        value: allNotifications[idx].value,
        onChanged: (bool? value) {
          if (value == null) return;
          setState(() {
            cntMenu = 0;
            /*print(allNotifications[idx].value);
            print(idx);
            print(value);*/
            // ignore: avoid_function_literals_in_foreach_calls
            //print("kuy2 " + (stidx.toString()) + " " + (endidx.toString()));
            allNotifications[idx].value = value;
            notifications.getRange(start, end).forEach((notification) {
              if (value == true) {
                sum += 199;
              } else {
                sum -= 199;
              }
              print('this is sum');
              print(sum);
              notification.value = value;
            });
          });
        },
      );

  Widget buildMultipleCheckbox(int start, int end) => Column(
        children: [
          if (end - start > 1)
            ...notifications
                .getRange(start, end)
                .map(buildSingleCheckbox)
                .toList(),
        ],
      );

  Widget buildMenuCheckbox(String string, int start, int end, int menuIdx) =>
      Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20),
              ),
              buildGroupCheckbox(menuIdx, start, end),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(
                  () {
                    cntMenu = 0;
                    allNotifications[menuIdx].isVisible =
                        !allNotifications[menuIdx].isVisible;
                    allNotifications[menuIdx].click =
                        !allNotifications[menuIdx].click;
                  },
                ),
                child: Row(
                  children: [
                    Text(
                      string,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Sriracha',
                        color: Colors.black,
                      ),
                    ),
                    /*if(allNotifications[menuIdx].meatCount>1){
                      Icon((allNotifications[menuIdx].click == false)
                        ? Icons.add
                        : Icons.remove),
                      };*/
                    Icon(() {
                      if (allNotifications[menuIdx].meatCount > 1) {
                        if (allNotifications[menuIdx].click == false) {
                          return Icons.remove;
                        } else {
                          return Icons.add;
                        }
                      }
                    }())
                  ],
                ),
              ),
            ],
          ),
          Visibility(
            visible: allNotifications[menuIdx].isVisible,
            child: buildMultipleCheckbox(start, end),
          ),
        ],
      );

  Future createUser(
      {required String uid,
      required String name,
      required int rate,
      required int index}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(uid);

    final jsonFoodsrate = {
      'name': name,
      'rate': rate,
      'allergic': false,
      'updatedForm': true,
    };

    await docUser.collection('foodsRate').doc("${index}").set(jsonFoodsrate);
  }

  Future createFoodForm(
      {required String uid,
      required String sname,
      required String fname,
      required String meat,
      required int index}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(uid);

    final json = {'sname': sname, 'fname': fname, 'meat': meat};

    await docUser.collection('foodsForm').doc("${index}").set(json);
  }

  /*void toggleGroupCheckbox(bool value,int start,int end) {
    

    setState(() {
      allNotifications.value = value;
      // ignore: avoid_function_literals_in_foreach_calls
      print("kuy2 "+(stidx.toString())+" "+(endidx.toString()));
      notifications.getRange(start,end).forEach((notification) => notification.value = value);
    });
  }*/
}
