import 'dart:io';
import 'dart:math';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/header_with_dropdown.dart';
import 'package:final_project/menu_page.dart';
import 'package:final_project/models/Food.dart';
import 'package:final_project/models/user.dart';
import 'package:final_project/providers/food_form_provider.dart';
import 'package:final_project/providers/food_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RandomPage extends StatefulWidget {
  const RandomPage({super.key});

  @override
  State<RandomPage> createState() => _RandomPageState();
}

var _isLoading = false;

var state = 0;
var qs = 0.0;

var valuedForm = 0;
var valuedChoose = 0;
var valuedNotChoose = 0;
var valuedAllergic = 0;

bool ch = false;

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;

class _RandomPageState extends State<RandomPage> {
  Food data = Food(sname: "", fname: "", meat: "", date: DateTime.now());

  void initState() {
    loadData();

    super.initState();
  }

  loadData() async {
    setState(() {
      _isLoading = false;
    });
    try {
      var tmp = Provider.of<FoodProvider>(context, listen: false);
      var docUser =
          FirebaseFirestore.instance.collection('users').doc(user!.uid);

      await docUser.get().then(
        (value) {
          valuedForm = value['valuedForm'];
          valuedChoose = value['valuedChoose'];
          valuedNotChoose = value['valuedNotChoose'];
          valuedAllergic = value['valuedAllergic'];
        },
      );
      // ***** valued = 0  *****
      var randomnumber = (Random().nextInt(
          (valuedChoose + valuedNotChoose + 1) *
                  (tmp.foods.length - 1 - valuedAllergic) -
              (valuedChoose * 4 + valuedNotChoose * 6) +
              valuedForm));
      // access foodrate
      var foods = docUser.collection('foodsRate');

      //set foodsRate and foodsAllergic to default (1,false)
      for (var i = 0; i < tmp.foods.length - 1; i++) {
        tmp.foodsRate[
            tmp.foods[i].sname + tmp.foods[i].fname + tmp.foods[i].meat] = 1;
        tmp.foodsAllergic[tmp.foods[i].sname +
            tmp.foods[i].fname +
            tmp.foods[i].meat] = false;
      }

      //read data from firestore
      await foods.get().then(
            (snapshot) => snapshot.docs.forEach(
              (element) {
                tmp.foodsRate[element.data()['name']] = element.data()['rate'];
                tmp.foodsAllergic[element.data()['name']] =
                    element.data()['allergic'];
              },
            ),
          );

      //random first food (quicksum)
      print(tmp.foods.length);
      for (var i = 0, qs = 0; i < tmp.foods.length - 1; i++) {
        String fill =
            tmp.foods[i].sname + tmp.foods[i].fname + tmp.foods[i].meat;
        if (tmp.foodsAllergic[fill] == false) {
          qs += tmp.foodsRate[fill] as int;
          qs += valuedChoose;
          qs += valuedNotChoose;
          if (qs > randomnumber) {
            state = i;
            data = tmp.foods[i];
            print('ตรงนี้');
            print(tmp.foods[i].sname + tmp.foods[i].fname + tmp.foods[i].meat);
            break;
          }
        }
      }

      setState(() {
        _isLoading = true;
      });
    } catch (e) {
      print("error" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var tmp = Provider.of<FoodProvider>(context, listen: false);

    return Consumer2(builder:
        (context, FoodProvider foodProvider, UserModel userProvider, child) {
      return _isLoading
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.orange,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop((context));
                  },
                  // ignore: prefer_const_constructors
                  icon: Icon(
                    Icons.arrow_back,
                  ),
                  iconSize: 24,
                  splashRadius: 16.0,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ),
              body: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(225, 193, 193, 193),
                  Colors.white,
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: Center(
                  child: Column(
                    children: [
                      HeaderWithDropDown(
                          MediaQuery.of(context).size, context, 'สุ่มอาหาร'),
                      Image.asset(
                        () {
                          // ignore: unrelated_type_equality_checks
                          if (data.img != Null) {
                            return data.img;
                          } else {
                            print("ระเบิด");
                            print(state);
                            return 'assets/images/สปาเก็ตตี้ผัดขี้เมา.png';
                          }
                        }(),
                        width: 300,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        width: double.infinity,
                        height: 30,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data.sname,
                              // ignore: prefer_const_constructors
                              style: TextStyle(
                                  shadows: const [
                                    Shadow(
                                      offset: Offset(0, -5),
                                    ),
                                  ],
                                  color: Colors.transparent,
                                  fontSize: 25,
                                  fontFamily: 'Sriracha',
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.black),
                            ),
                          ]),
                      // SizedBox(
                      //   width: double.infinity,
                      //   height: 20,
                      // ),
                      Text(
                        () {
                          if (data.meat == "-") {
                            return data.fname;
                          } else {
                            return data.fname + data.meat;
                          }
                        }(),
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Sriracha',
                        ),
                      ),
                      // ignore: prefer_const_constructors
                      SizedBox(
                        width: double.infinity,
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                // history part
                                // ------------------------------------------------
                                var users = Provider.of<UserModel>(context,
                                    listen: false);
                                data.date = DateTime.now();

                                users.addUser(data);
                                // ------------------------------------------------

                                // update valuedChoose
                                var docUser = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user!.uid)
                                    .get()
                                    .then((value) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user!.uid)
                                      .update({
                                    'valuedChoose': value['valuedChoose'] + 1
                                  });
                                });

                                String fill = foodProvider.foods[state].sname +
                                    foodProvider.foods[state].fname +
                                    foodProvider.foods[state].meat;

                                final food = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user!.uid)
                                    .collection('foodsRate')
                                    .doc('$state');

                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user!.uid)
                                    .collection('foodsHistory')
                                    .doc('${valuedChoose + 1}')
                                    .set({
                                  'sname': foodProvider.foods[state].sname,
                                  'fname': foodProvider.foods[state].fname,
                                  'meat': foodProvider.foods[state].meat,
                                  'date': DateTime.now(),
                                });

                                // update food rate / add food document
                                DocumentReference documentReference =
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user!.uid)
                                        .collection('foodsRate')
                                        .doc('$state');
                                documentReference.get().then(
                                  (datasnapshot) async {
                                    if (datasnapshot.exists) {
                                      //print('mee');
                                      int rate = await readData(fill);

                                      food.update({'rate': rate - 20});
                                    } else {
                                      //print("mai mee");
                                      createUser(
                                          uid: user!.uid,
                                          name: fill,
                                          rate: -19,
                                          index: state,
                                          allergic: false);
                                    }
                                  },
                                );

                                Navigator.pop(context);
                              },
                              // ignore: prefer_const_constructors
                              icon: Icon(
                                Icons.check,
                                size: 30,
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
                                backgroundColor: Colors.yellow[700],
                              ),
                              label: const Text(
                                'เลือก',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Sriracha',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                // update valuedNotChoose
                                var docUser = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user!.uid);

                                docUser.get().then((value) async {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user!.uid)
                                      .update({
                                    'valuedNotChoose':
                                        value['valuedNotChoose'] + 1
                                  });
                                  valuedForm = value['valuedForm'];
                                  valuedChoose = value['valuedChoose'];
                                  valuedNotChoose = value['valuedNotChoose'];
                                  valuedAllergic = value['valuedAllergic'];
                                });

                                String fill = foodProvider.foods[state].sname +
                                    foodProvider.foods[state].fname +
                                    foodProvider.foods[state].meat;

                                final food = docUser
                                    .collection('foodsRate')
                                    .doc('${state}');

                                // update food rate / add food document
                                DocumentReference documentReference =
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user!.uid)
                                        .collection('foodsRate')
                                        .doc('${state}');
                                documentReference.get().then(
                                  (datasnapshot) async {
                                    if (datasnapshot.exists) {
                                      //print('mee');

                                      int rate = await readData(fill);

                                      food.update({'rate': rate - 60});
                                    } else {
                                      //print("mai mee");
                                      createUser(
                                          uid: user!.uid,
                                          name: fill,
                                          rate: -59,
                                          index: state,
                                          allergic: false);
                                    }
                                  },
                                );

                                var foods = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user!.uid)
                                    .collection('foodsRate');

                                //set foodsRate and foodsAllergic to default (1,false)
                                for (var i = 0; i < tmp.foods.length - 1; i++) {
                                  tmp.foodsRate[tmp.foods[i].sname +
                                      tmp.foods[i].fname +
                                      tmp.foods[i].meat] = 1;
                                  tmp.foodsAllergic[tmp.foods[i].sname +
                                      tmp.foods[i].fname +
                                      tmp.foods[i].meat] = false;
                                }

                                //read data from firestore
                                await foods.get().then((snapshot) =>
                                    snapshot.docs.forEach((element) {
                                      tmp.foodsRate[element.data()['name']] =
                                          element.data()['rate'];
                                      tmp.foodsAllergic[
                                              element.data()['name']] =
                                          element.data()['allergic'];
                                    }));

                                // random food (quicksum)
                                setState(() {
                                  qs = 0.0;
                                  state = 0;
                                  var randomnumber = (Random().nextInt(
                                      (valuedChoose + valuedNotChoose + 1) *
                                              (tmp.foods.length -
                                                  1 -
                                                  valuedAllergic) -
                                          (valuedChoose * 4 +
                                              valuedNotChoose * 6) +
                                          valuedForm));
                                  for (var i = 0, qs = 0;
                                      i < tmp.foods.length - 1;
                                      i++) {
                                    if (tmp.foodsAllergic[tmp.foods[i].sname +
                                            tmp.foods[i].fname +
                                            tmp.foods[i].meat] ==
                                        false) {
                                      qs += tmp.foodsRate[tmp.foods[i].sname +
                                          tmp.foods[i].fname +
                                          tmp.foods[i].meat] as int;
                                      qs += valuedChoose;
                                      qs += valuedNotChoose;

                                      if (qs > randomnumber) {
                                        state = i;
                                        data = tmp.foods[i];
                                        print('ตรงนี้');
                                        print(tmp.foods[i].sname +
                                            tmp.foods[i].fname +
                                            tmp.foods[i].meat);
                                        break;
                                      }
                                    }
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.restart_alt,
                                size: 30,
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                backgroundColor: Colors.yellow[700],
                              ),
                              label: const Text(
                                'ไม่เลือก',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Sriracha',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            var fmap = data.sname + data.fname + data.meat;

                            if (tmp.foodsRate[fmap] != null)
                              tmp.size -= tmp.foodsRate[fmap]!;

                            tmp.foodsRate.remove(fmap);

                            for (var i = 0; i < tmp.foods.length - 1; i++) {
                              if (tmp.foods[i].sname == data.sname &&
                                  tmp.foods[i].fname == data.fname &&
                                  tmp.foods[i].meat == data.meat) {
                                state = i;
                              }
                            }

                            String fill = foodProvider.foods[state].sname +
                                foodProvider.foods[state].fname +
                                foodProvider.foods[state].meat;

                            final docUser = FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid)
                                .collection('foodsRate')
                                .doc('${state}');

                            DocumentReference documentReference =
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user!.uid)
                                    .collection('foodsRate')
                                    .doc('${state}');

                            documentReference.get().then(
                              (datasnapshot) async {
                                if (datasnapshot.exists) {
                                  //print('mee');
                                  int rate = await readData(fill);
                                  docUser.update(
                                    {
                                      'allergic': true,
                                    },
                                  );
                                } else {
                                  //print("mai mee");
                                  createUser(
                                      uid: user!.uid,
                                      name: fill,
                                      rate: 1,
                                      index: state,
                                      allergic: true);
                                }
                              },
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.only(left: 35, right: 35),
                            backgroundColor: Colors.yellow[700],
                          ),
                          icon: Icon(
                            Icons.close,
                            size: 30,
                          ),
                          label: const Text(
                            'ฉันแพ้อาหารชนิดนี้',
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Sriracha',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Scaffold(
              backgroundColor: Colors.orange,
              body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Loading Data',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CircularProgressIndicator(
                        color: Colors.black,
                        backgroundColor: Colors.grey,
                      )
                    ]),
              ));
    });
  }

  Future createUser(
      {required String uid,
      required String name,
      required int rate,
      required int index,
      required bool allergic}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(uid);

    final json = {
      'name': name,
      'rate': rate,
      'allergic': allergic,
    };

    await docUser.collection('foodsRate').doc("${index}").set(json);
  }

  Future<int> readData(String name) async {
    try {
      var food = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('foodsRate')
          .where('name', isEqualTo: name)
          .get();
      return food.docs[0]['rate'];
    } on FirebaseException catch (e) {
      print(e);
      return 0;
    } catch (error) {
      print(error);
      return 0;
    }
  }
}

void valued() {
  var docUser = FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .get() as Map<String, dynamic>;
  valuedForm = docUser['valuedForm'];
  valuedChoose = docUser['valuedChoose'];
  valuedNotChoose = docUser['valuedNotChoose'];
  valuedAllergic = docUser['valuedAllergic'];
}

Future<void> nullCheck(int i) async {
  DocumentSnapshot<Map<String, dynamic>> document = await FirebaseFirestore
      .instance
      .collection('users')
      .doc(user!.uid)
      .collection('foodsRate')
      .doc('${i}')
      .get();
  if (document.exists) {
    ch = true;
  } else {
    ch = false;
  }
}

/*
val = choosenum;
random = tmp.size*(val+1);
qs = ...+val

เลือก
update choosenum

ไม่เลือก
qs = ...+tmp.size*(val+1);

แพ้อาหาร
update choosenum
val--;


*/
