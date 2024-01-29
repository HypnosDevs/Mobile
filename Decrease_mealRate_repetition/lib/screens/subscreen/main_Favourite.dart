import 'package:final_project/form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:final_project/screens/subscreen/subcomponents/main_body_Favourite.dart';
import 'package:final_project/screens/subscreen/subcomponents/main_body_context.dart';

class AllFavourite extends StatelessWidget {
  const AllFavourite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.orange,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
              iconSize: 24,
              splashRadius: 16.0,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            )),floatingActionButton: FloatingActionButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const FormPage();
                    },
                  ),
                );
              },
              backgroundColor: Colors.orange,
              child: const Icon(Icons.edit),
            ),
        body: SingleChildScrollView(
          child: Column(
            children: [RatingContext()],
          ),
        ));
  }
}
