import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_page_menu/flutter_page_menu.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new CupertinoApp(
      title: 'Flutter Page Menu',
      color: Color(0xffffffff),
      home: new PageMenu(
        tabTitles:['TabA','TabBBB','TabC'],
        barHeight: 64.0,
        tabViews: <Widget>[
          Center(
            child:Text('TabA')
          ),
          Center(
            child:Text('TabBBB')
          ),
          Center(
            child:Text('TabC')
          )
        ],
      )
    );
  }
}