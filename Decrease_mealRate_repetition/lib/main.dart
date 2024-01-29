import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/auth_page.dart';
import 'package:final_project/form_page.dart';
import 'package:final_project/menu_page.dart';
import 'package:final_project/models/user.dart';
import 'package:final_project/providers/dropdown_provider.dart';
import 'package:final_project/providers/food_form_provider.dart';
import 'package:final_project/providers/food_provider.dart';
import 'package:final_project/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  void test(BuildContext context) {
    context.read();
  }

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) {
            return FoodProvider();
          }),
          ChangeNotifierProvider(create: (context) {
            return FoodForm();
          }),
          ChangeNotifierProvider(create: (context) {
            return UserModel();
          }),
          ChangeNotifierProvider(create: (context) {
            return DropdownProvider();
          })
        ],
        child: MaterialApp(
          scaffoldMessengerKey: Utils.messengerKey,
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          //theme: ThemeData(primarySwatch: Colors.deepOrange),
          home: Scaffold(
              body: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    var value;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Something went wrong!'));
                    } else if (snapshot.hasData) {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final User? user = auth.currentUser;

                      CollectionReference users =
                          FirebaseFirestore.instance.collection('users');

                      return FutureBuilder<DocumentSnapshot>(
                        future: users.doc(user!.uid).get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text("Something went wrong");
                          }

                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return Text("Document does not exist");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            if (data['formPage'] == true) {
                              return FormPage();
                            } else {
                              return MenuPage();
                            }
                          }
                          return Scaffold(
                            backgroundColor: Colors.orange,
                          );
                        },
                      );
                    } else {
                      return AuthPage();
                    }
                  })),
        ));
  }
  //  Future<bool> formVal() async {
  //   var  documentReference = FirebaseFirestore.instance.collection('users').doc(user?.uid);
  //   bool val = true;

  //   await documentReference.get().then((snapshot) {

  //     val = snapshot.data()![user!.uid]['formPage'];
  //   });
  //   print('form validate');
  //   print(val);
  //   return val;
  //   }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return const FormPage();
    /*appBar: AppBar(
        title: const Text('Flutter'),
      ),*/
    /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Floating Action Button');
        },
        child: const Icon(Icons.add),
      ),*/
    /*bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),*/
  }
}
