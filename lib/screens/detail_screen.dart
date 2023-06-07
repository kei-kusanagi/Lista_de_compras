import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var currencyFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}?$'));

class DetailScreen extends StatefulWidget {
  final String nombre;
  final List<Map<String, dynamic>> objetos;

  DetailScreen({required this.nombre, required this.objetos});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TextEditingController productoController = TextEditingController();
  TextEditingController valorUnitarioController = TextEditingController();
  TextEditingController unidadesController = TextEditingController();

  List<Map<String, dynamic>> get objetos => widget.objetos;

  double getTotalValor() {
    double total = 0;
    for (final objeto in objetos) {
      total += objeto['valor'] as double;
    }
    return total;
  }

  void agregarObjeto() {
    setState(() {
      final nuevoObjeto = {
        'producto': productoController.text,
        'valor unitario': valorUnitarioController.text,
        'unidades': int.tryParse(unidadesController.text) ?? 1,
        'valor': 0,
        'check': false,
      };

      nuevoObjeto['valor'] =
          double.parse(nuevoObjeto['valor unitario'] as String) *
              (nuevoObjeto['unidades'] as num);

      objetos.add(nuevoObjeto);

      productoController.clear();
      valorUnitarioController.clear();
      unidadesController.clear();
    });
  }

  void aumentarCantidad(int index) {
    setState(() {
      objetos[index]['unidades']++;
      objetos[index]['valor'] =
          double.parse(objetos[index]['valor unitario'] as String) *
              (objetos[index]['unidades'] as num);
    });
  }

  void reducirCantidad(int index) {
    setState(() {
      if (objetos[index]['unidades'] > 0) {
        objetos[index]['unidades']--;
        objetos[index]['valor'] =
            double.parse(objetos[index]['valor unitario'] as String) *
                (objetos[index]['unidades'] as num);
        if (objetos[index]['unidades'] == 0) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Eliminar elemento'),
              content: const Text('¿Desea eliminar este elemento?'),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      objetos.removeAt(index);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Aceptar'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      objetos[index]['unidades'] = 1;
                      objetos[index]['valor'] = double.parse(
                              objetos[index]['valor unitario'] as String) *
                          (objetos[index]['unidades'] as num);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: productoController,
              decoration: const InputDecoration(labelText: 'Producto'),
            ),
            TextField(
              controller: valorUnitarioController,
              decoration: const InputDecoration(
                  labelText: 'Valor unitario',
                  prefixText: '\$ ',
                  hintText: '00.00'),
              inputFormatters: [currencyFormatter],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      int unidades = int.tryParse(unidadesController.text) ?? 0;
                      unidades = unidades > 0 ? unidades - 1 : 0;
                      unidadesController.text = unidades.toString();
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: unidadesController,
                    decoration: const InputDecoration(
                        labelText: 'Unidades', hintText: '1'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      int unidades = int.tryParse(unidadesController.text) ?? 0;
                      unidades = unidades + 1;
                      unidadesController.text = unidades.toString();
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: agregarObjeto,
              child: const Text('Agregar producto'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: objetos.length,
                itemBuilder: (context, index) {
                  final objeto = objetos[index];

                  return Dismissible(
                    key: Key(objeto['producto']),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Eliminar elemento'),
                          content: const Text('¿Desea eliminar este elemento?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text('Aceptar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text('Cancelar'),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) {
                      setState(() {
                        objetos.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Producto eliminado')),
                      );
                    },
                    child: ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => reducirCantidad(index),
                          ),
                          Text(objeto['unidades'].toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => aumentarCantidad(index),
                          ),
                        ],
                      ),
                      title: Text(objeto['producto']),
                      subtitle: Text('Valor: ${objeto['valor']}'),
                      trailing: Checkbox(
                        value: objeto['check'],
                        onChanged: (value) {
                          setState(() {
                            objeto['check'] = value;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TOTAL',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  '\$${getTotalValor().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).cardColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
