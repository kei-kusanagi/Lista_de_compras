import 'package:flutter/material.dart';
import 'package:lista_de_compras/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Compras',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      // home: HomeScreen(),
      home: MyHomePage(),
    );
  }
}
