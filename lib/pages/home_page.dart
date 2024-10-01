import 'package:flutter/material.dart';
import 'package:flutter_shop_dx_me/log/log_constanst.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myPrint('首页刷新了...');
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("1111"));
  }
}
