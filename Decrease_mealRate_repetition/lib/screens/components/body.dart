import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/DropdownItem.dart';
import 'package:final_project/models/Food.dart';
import 'package:final_project/models/user.dart';
import 'package:final_project/providers/dropdown_provider.dart';
import 'package:final_project/providers/food_form_provider.dart';
import 'package:final_project/random_page.dart';
import 'package:final_project/screens/components/title_with_button.dart';
import 'package:final_project/screens/components/title_with_button_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_project/screens/components/dropdown.dart';

import '../../providers/food_provider.dart';
import 'favourite.dart';
import 'header_with_dropdwon.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;

List<String> shop = ["ทั้งหมด", "ชิกกี้ชิก", "ร้านก๋วยเตี๋ยวนายหนวด", "ร้านข้าวแกงปักษ์ใต้", "ร้านแม่น้องพันช์"];
String selectedItem = 'ทั้งหมด';

var foods = FirebaseFirestore.instance
    .collection('users')
    .doc(user!.uid)
    .collection('foodsRate');
var _isLoading = false;
var store = 'ทั้งหมด';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  void test() {}

  @override
  void initState() {
    context.read<FoodForm>().test();
    loadData();
    super.initState();
  }

  loadData() async {
    setState(() {
      _isLoading = false;
    });
    try {
      var tmp = Provider.of<FoodForm>(context, listen: false);

      //read data from firestore
      await foods.get().then(
            (snapshot) => snapshot.docs.forEach(
              (element) {
                Food data = Food(sname: element.data()['sname'],fname: element.data()['fname'],meat: element.data()['meat'],date: element.data()['date']);
                tmp.addFoodForm(data);
              },
            ),
          );

      setState(() {
        _isLoading = true;
      });
    } catch (e) {
      print("error" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Iterable<String> str;
    var foodForm = FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('foodsForm');
    var foodHistory = FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('foodsHistory');
    //scrolling smalldevice
    return FutureBuilder(future: Future.wait([foodForm.get(),foodHistory.orderBy('date', descending: true).get()]),builder:(_, snapshot) {
      if(snapshot.hasData){
        return SingleChildScrollView(
      child: Consumer2(
        builder:
            (context, FoodForm foodProvider, UserModel userProvider, child) {
          return Column(
            children: <Widget>[
              //HeaderWithDropDown(size, context),


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
                                  "ประวัติอาหาร",
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


              TiltleWIthButton(
                title: "Your Favourite",
              ),
              //cover 40% of total width
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: size.height * 0.25,
                child: ListView.builder(
                  
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data![0].docs.length,
                    itemBuilder: (context, index) {
                      var tmp = Provider.of<FoodProvider>(context, listen: false);
                      if(store == 'ทั้งหมด' || store == snapshot.data![0].docs[index].data()['sname']) {        
                        if(snapshot.data![0].docs[index].data()['meat'] == '-') {
                          return Favourite(
                          sname: snapshot.data![0].docs[index].data()['sname'],
                          fname: snapshot.data![0].docs[index].data()['fname'],
                          img:  tmp.foods[tmp.foods.indexWhere((element) => element.sname+element.fname+element.meat==snapshot.data![0].docs[index].data()['sname']+
                          snapshot.data![0].docs[index].data()['fname']+snapshot.data![0].docs[index].data()['meat'])].img,
                          press: () {});
                        }          
                        return Favourite(
                          
                          sname: snapshot.data![0].docs[index].data()['sname'],
                          fname: snapshot.data![0].docs[index].data()['fname']+snapshot.data![0].docs[index].data()['meat'],
                          img:  tmp.foods[tmp.foods.indexWhere((element) => element.sname+element.fname+element.meat==snapshot.data![0].docs[index].data()['sname']+
                          snapshot.data![0].docs[index].data()['fname']+snapshot.data![0].docs[index].data()['meat'])].img,
                          press: () {});
                      }
                      return Container(width: 0,height: 0,);
                    }),
              ),
              TiltleWithButtonHistory(
                title: "Your History",
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: size.height * 0.25,
                child: ListView.builder(
                    
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data![1].docs.length,
                    itemBuilder: (context, index) {
                      var tmp = Provider.of<FoodProvider>(context, listen: false);
                      if(store == 'ทั้งหมด' || store == snapshot.data![1].docs[index].data()['sname']) {
                        if(snapshot.data![1].docs[index].data()['meat'] == '-') {
                          return Favourite(
                          sname: snapshot.data![1].docs[index].data()['sname'],
                          fname: snapshot.data![1].docs[index].data()['fname'],
                          img:  tmp.foods[tmp.foods.indexWhere((element) => element.sname+element.fname+element.meat==snapshot.data![1].docs[index].data()['sname']+
                          snapshot.data![1].docs[index].data()['fname']+snapshot.data![1].docs[index].data()['meat'])].img,
                          press: () {});
                        }
                        print(snapshot.data![1].docs[index].data()['sname']+
                          snapshot.data![1].docs[index].data()['fname']+snapshot.data![1].docs[index].data()['meat']);
                        print(tmp.foods.indexWhere((element) => element.sname+element.fname+element.meat==snapshot.data![1].docs[index].data()['sname']+
                          snapshot.data![1].docs[index].data()['fname']+snapshot.data![1].docs[index].data()['meat']));
                      return Favourite(
                          sname: snapshot.data![1].docs[index].data()['sname'],
                          fname: snapshot.data![1].docs[index].data()['fname']+snapshot.data![1].docs[index].data()['meat'],
                          img:  tmp.foods[tmp.foods.indexWhere((element) => element.sname+element.fname+element.meat==snapshot.data![1].docs[index].data()['sname']+
                          snapshot.data![1].docs[index].data()['fname']+snapshot.data![1].docs[index].data()['meat'])].img,
                          press: () {});
                      }
                      return Container(width: 0,height: 0,);
                    }),
              ),
            ],
          );
        },
      ),
    );
      }
      else{
        return Scaffold( backgroundColor: Colors.orange,body:Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [Text('Loading Data',style: TextStyle(fontSize: 20),),SizedBox(height: 20,),CircularProgressIndicator(color: Colors.black,backgroundColor: Colors.grey,)]),));
      }
    }, );
    
  }
}

//getdata

void test() {}



/*
 List<String> shop = ['All', 'Chickychic', 'yalamai', 'noodle'];
  String? selectedItem = 'Chickychic';

child: DropdownButton<String>(
              value: selectedItem,
              items: shop
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: TextStyle(fontSize: 24)),
                      ))
                  .toList(),
              onChanged: (item) => setState(() => selectedItem = item)),
              */

/*
Container(
                      margin: EdgeInsets.symmetric(horizontal: 54),
                      height: 36,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 10),
                                blurRadius: 5,
                                color: Colors.black.withOpacity(0.1)),
                          ]),
                    )
*/