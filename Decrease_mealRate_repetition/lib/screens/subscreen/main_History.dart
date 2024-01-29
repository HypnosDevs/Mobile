import 'package:flutter/material.dart';

import 'subcomponents/main_body_History.dart';
import 'subcomponents/main_body_HistoryContext.dart';

class AllHistory extends StatelessWidget {
  const AllHistory({super.key});

  @override
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
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [HistoryContext()],
        ),
      ),
    );
  }
}
