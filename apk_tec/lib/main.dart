import 'package:apk_tec/src/pages/home_page.dart';
import 'package:apk_tec/src/pages/login_page.dart';
import 'package:apk_tec/src/pages/tabs_page.dart';
import 'package:apk_tec/src/theme/tema.dart';
import 'package:flutter/material.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      theme: miTema,
      initialRoute: 'login',
      routes: {
        'login': (BuildContext context)=>LoginPage(),
        'home': (BuildContext context)=>HomePage(),
        'tabs': (BuildContext context)=>TabsPage()
      },
    );  
  }
}