import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/DropdownItem.dart';
import 'package:final_project/models/user.dart';
import 'package:final_project/providers/dropdown_provider.dart';
import 'package:final_project/providers/food_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryContext extends StatefulWidget {
  const HistoryContext({super.key});

  @override
  State<HistoryContext> createState() => _HistoryContextState();
}

var _isLoading = false;
var k=1;

List<String> shop = [
  "ทั้งหมด",
  "ชิกกี้ชิก",
  "ร้านก๋วยเตี๋ยวนายหนวด",
  "ร้านข้าวแกงปักษ์ใต้",
  "ร้านแม่น้องพันช์"
];
String selectedItem = 'ทั้งหมด';
var store = 'ทั้งหมด';

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;

class _HistoryContextState extends State<HistoryContext> {
  void initState() {
    loadData();

    super.initState();
  }

  loadData() async {
    setState(() {
      _isLoading = false;
    });
    try {
     // print('ch1');
      var tmp = Provider.of<FoodProvider>(context, listen: false);
      var docUser =
          FirebaseFirestore.instance.collection('users').doc(user!.uid);

      // access foodrate
      var foods = docUser.collection('foodsHistory');

      //set foodsHistory to 0
      for (var i = 0; i < tmp.foods.length - 1; i++) {
        print(i);
        tmp.foodsHistory[
            tmp.foods[i].sname + tmp.foods[i].fname + tmp.foods[i].meat] = 1;
      
      }

      //read data from firestore
      await foods.get().then(
            (snapshot) => snapshot.docs.forEach(
              (element) {
               
                tmp.foodsHistory[element.data()['sname']+element.data()['fname']+element.data()['meat']] = (tmp.foodsHistory[element.data()['sname']+element.data()['fname']+element.data()['meat']]! + 1);
                
               // print('ch');
              },
            ),
          );
          setState(() {
          _isLoading = true;
          });
    } catch (e) {
      print('kuykuykuy');
      print("error" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var fHistory = FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('foodsHistory');
    return _isLoading?Column(
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
                                  "History",
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
                                    onChanged: (item) async{
                                      print('----------------------');
                                      await loadData();
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
    FutureBuilder(future:  fHistory.orderBy('date', descending: true).get(),builder: ((context, snapshot) {
      return Consumer(
      builder: (context, UserModel userProvider, child) {
        if(snapshot.hasData){
          k=1;
          return ListView.builder(
          shrinkWrap: true, 
          primary: false,
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            
            var length = snapshot.data!.docs.length;
            var tmp = Provider.of<FoodProvider>(context, listen: false);
            //print('kuykuykuy');
            //print(snapshot.data!.docs[index].data()['sname']+snapshot.data!.docs[index].data()['fname']+snapshot.data!.docs[index].data()['meat']);
            tmp.foodsHistory[snapshot.data!.docs[index].data()['sname']+snapshot.data!.docs[index].data()['fname']+snapshot.data!.docs[index].data()['meat']]=tmp.foodsHistory[snapshot.data!.docs[index].data()['sname']+snapshot.data!.docs[index].data()['fname']+snapshot.data!.docs[index].data()['meat']]!-1;
            if(store == 'ทั้งหมด' || store == snapshot.data!.docs[index].data()['sname']) {
              return Card(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage("${tmp.foods[tmp.foods.indexWhere((element) => element.sname+element.fname+element.meat==snapshot.data!.docs[index].data()['sname']+
                          snapshot.data!.docs[index].data()['fname']+snapshot.data!.docs[index].data()['meat'])].img}"),
                ),
                // Widget((){}(),propreties)
                title: Text(() {
                 if(snapshot.data!.docs[index].data()['meat']=='-'){
                  return snapshot.data!.docs[index].data()['sname']+": "+snapshot.data!.docs[index].data()['fname']; 
                 }
                  return snapshot.data!.docs[index].data()['sname']+": "+snapshot.data!.docs[index].data()['fname']+snapshot.data!.docs[index].data()['meat'];
                }(), style: TextStyle(fontFamily: "Sriracha")),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(DateFormat("dd/MM/yy")
                        .format(snapshot.data!.docs[index].data()['date'].toDate())),
                      Text(DateFormat("KK:mm:ss a")
                    .format(snapshot.data!.docs[index].data()['date'].toDate())),
                    
                    Text((){
                      return "Counts: ${tmp.foodsHistory[snapshot.data!.docs[index].data()['sname']+snapshot.data!.docs[index].data()['fname']+snapshot.data!.docs[index].data()['meat']]}";}())
                  ],
                ),
              ),
            );
            }
            return Container(
                          width: 0,
                          height: 0,
                        );
            
          },
        );
      }
      else {
        return Center(child: Text('Loading...',style: TextStyle(fontSize: 20)),);
      }
        }
       
    );
  
    }),)]):Column(
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
                                  "History",
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
                                    onChanged: (item) async{
                                      print('----------------------');
                                      await loadData();
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
                      ))]);}
}
