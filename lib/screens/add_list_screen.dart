import 'package:flutter/material.dart';
import 'package:lista_de_compras/screens/add_item_to_existing_list_screen.dart';

class AddItemScreen extends StatelessWidget {
  AddItemScreen({Key? key}) : super(key: key);

  final TextEditingController listNameController = TextEditingController();
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController unitsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar lista'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Nombre de la lista'),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Nombre de la tienda (opcional)'),
            ),
            const SizedBox(height: 16),
            Text(
              'Fecha: ${DateTime.now().toString()}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Guardar Lista de compras',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String listName = listNameController.text;
                String storeName = storeNameController.text;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddItemToExistingListScreen(
                      listName: listName,
                      storeName: storeName,
                    ),
                  ),
                );
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
