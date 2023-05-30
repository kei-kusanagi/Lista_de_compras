import 'package:flutter/material.dart';

class ItemCartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('lista'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          //aqui va la lista de articulos guardados
        ],
      ),
    );
  }
}
