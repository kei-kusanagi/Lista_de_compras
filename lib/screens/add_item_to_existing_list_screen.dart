import 'package:flutter/material.dart';
import 'package:lista_de_compras/screens/item_list_screen.dart';

class AddItemToExistingListScreen extends StatefulWidget {
  final String listName;
  final String storeName;

  const AddItemToExistingListScreen(
      {Key? key, required this.listName, required this.storeName})
      : super(key: key);

  @override
  _AddItemToExistingListScreenState createState() =>
      _AddItemToExistingListScreenState();
}

class _AddItemToExistingListScreenState
    extends State<AddItemToExistingListScreen> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController pricePerUnitController = TextEditingController();
  final TextEditingController unitsController = TextEditingController();
  bool isChecked = false;

  @override
  void dispose() {
    itemNameController.dispose();
    pricePerUnitController.dispose();
    unitsController.dispose();
    super.dispose();
  }

  void _addItemToList() {
    String itemName = itemNameController.text;
    double pricePerUnit = double.parse(pricePerUnitController.text);
    int units = int.parse(unitsController.text);
    double totalPrice = pricePerUnit * units;

    Navigator.pop(
      context,
      {
        'itemName': itemName,
        'pricePerUnit': pricePerUnit,
        'units': units,
        'totalPrice': totalPrice,
        'isChecked': isChecked,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Artículo a la Lista'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: itemNameController,
              decoration:
                  const InputDecoration(labelText: 'Nombre del Artículo'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pricePerUnitController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio por Unidad'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: unitsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Unidades'),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Check'),
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value ?? false;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addItemToList,
              child: const Text('Guardar Artículo'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemCartScreen()),
                );
              },
              child: Text('Ver lista'),
            ),
          ],
        ),
      ),
    );
  }
}
