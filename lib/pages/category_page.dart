import 'package:flutter/material.dart';

import '../log/log_constanst.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  void initState() {
    // TODO: implement initState
    super.initState();
    myPrint('购物车刷新了...');
  }

  @override
  Widget build(BuildContext context) {
    return Text("分类");
  }
}
