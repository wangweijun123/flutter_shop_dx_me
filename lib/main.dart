import 'package:flutter/material.dart';
import 'package:flutter_shop_dx_me/pages/index_page.dart';
import 'package:flutter_shop_dx_me/providers/current_index_provider.dart';
import 'package:provider/provider.dart';

import 'config/color.dart';
import 'config/string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Failed assertion: line 71 pos 16: 'children.isNotEmpty': is not true.
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentIndexProvider()),
      ],
      child: Container(
        child: MaterialApp(
          title: KString.mainTitle,
          //Flutter女装商城
          debugShowCheckedModeBanner: false,
          // onGenerateRoute: Application.router.generator,
          //定制主题
          theme: ThemeData(
            primaryColor: KColor.primaryColor,
          ),
          // home: Text("xxxxx"),
          home: IndexPage(),
        ),
      ),
    );
  }
}
