import 'package:final_project/random_page.dart';
import 'package:final_project/screens/history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'กินอะไรดี',
              style: TextStyle(
                fontSize: 60,
                fontFamily: 'Sriracha',
                color: Colors.white,
              ),
            ),
            Image.asset(
              'assets/images/tom_yum_kung.png',
              width: 200,
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const RandomPage();
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.only(
                    top: 15, bottom: 15, left: 30, right: 30),
                backgroundColor: Colors.yellow[700],
              ),
              child: const Text(
                'สุ่มอาหาร',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Sriracha',
                  color: Colors.white,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const History();
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.only(
                    top: 15, bottom: 15, left: 30, right: 30),
                backgroundColor: Colors.yellow[700],
              ),
              child: const Text(
                'ประวัติอาหาร',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Sriracha',
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.only(
                    top: 15, bottom: 15, left: 30, right: 30),
                backgroundColor: Colors.yellow[700],
              ),
              icon: Icon(Icons.arrow_back, size: 30),
              label: Text(
                '  ออกจากระบบ',
                style: TextStyle(fontSize: 30, fontFamily: 'Sriracha'),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                /*  Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                        void toggle() => setState(() => isLogin = !isLogin);
                      return LoginWidget(onClickedSignUp: toggle);
                    },
                  ),
                );*/
              },
            ),
          ],
        ),
      ),
    );
  }
}
