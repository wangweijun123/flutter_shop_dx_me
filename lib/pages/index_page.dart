import 'package:flutter/material.dart';
import 'package:flutter_shop_dx_me/providers/current_index_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/string.dart';
import '../log/log_constanst.dart';
import 'category_page.dart';
import 'home_page.dart';

class IndexPage extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomTabs = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: KString.homeTitle, //首页
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.category),
      label: KString.categoryTitle, //分类
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart),
      label: KString.shoppingCartTitle, //购物车
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: KString.memberTitle, //会员中心
    ),
  ];

  final List<Widget> tabBodies = [
    HomePage(),
    CategoryPage(),
    HomePage(),
    CategoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // 屏幕适配
    ScreenUtil.init(context, designSize: const Size(750, 1334));
    //取到当前索引状态值
    var currentIndexProvider =
        Provider.of<CurrentIndexProvider>(context, listen: true);
    myPrint("build currentIndexProvider = ${currentIndexProvider.hashCode}");
    int currentIndex = currentIndexProvider.currentIndex;
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      bottomNavigationBar: BottomNavigationBar(
        // 需要加上type才正常展示table
        type: BottomNavigationBarType.fixed,
        items: bottomTabs,
        currentIndex: currentIndex,
        onTap: (index) {
          var currentIndexProvider =
              Provider.of<CurrentIndexProvider>(context, listen: false);
          myPrint(
              "onTap currentIndexProvider = ${currentIndexProvider.hashCode}");
          currentIndexProvider.changeIndex(index);
        },
      ),
      body: IndexedStack(
        index: currentIndex,
        children: tabBodies,
      ),
    );
  }
}
