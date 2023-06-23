import 'package:flutter/material.dart';
import 'package:lista_de_compras/screens/detail_screen.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> nombres = [];
  List<String> tiendas = [];
  List<List<Map<String, dynamic>>> objetosAsociados = [];

  TextEditingController nombreController = TextEditingController();
  TextEditingController tiendaController = TextEditingController();
  double valorTotal = 0.0;

  void agregarLista() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar lista'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de tu lista',
                ),
              ),
              TextField(
                controller: tiendaController,
                decoration: const InputDecoration(
                  labelText: 'Tienda (opcional)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  nombres.add(nombreController.text);
                  tiendas.add(tiendaController.text);
                  objetosAsociados.add([]);
                  nombreController.clear();
                  tiendaController.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void editarLista(int index) {
    nombreController.text = nombres[index];
    tiendaController.text = tiendas[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar lista'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                ),
              ),
              TextField(
                controller: tiendaController,
                decoration: const InputDecoration(
                  labelText: 'Tienda (opcional)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  nombres[index] = nombreController.text;
                  tiendas[index] = tiendaController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void borrarLista(int index) {
    setState(() {
      nombres.removeAt(index);
      tiendas.removeAt(index);
      objetosAsociados.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listas de compras'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: nombres.length,
                itemBuilder: (context, index) {
                  final nombre = nombres[index];
                  final tienda = tiendas[index];
                  final objetos = objetosAsociados[index];

                  final fechaActual =
                      DateFormat('dd/MM/yyyy').format(DateTime.now());

                  return Dismissible(
                    key: Key(nombre),
                    background: Container(
                      color: Colors.green,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirmar borrado'),
                              content: const Text(
                                  '¿Estás seguro de que deseas borrar esta lista?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Lista eliminada')),
                                    );
                                  },
                                  child: const Text('Borrar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('Cancelar'),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (direction == DismissDirection.startToEnd) {
                        editarLista(index);
                      }
                      return false;
                    },
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        borrarLista(index);
                      }
                    },
                    child: ListTile(
                      title: Text(
                          '$nombre (${tienda.isNotEmpty ? tienda : 'Sin tienda'})'),
                      subtitle: Text('Fecha: $fechaActual'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              nombre: nombre,
                              objetos: objetos,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).canvasColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Agregar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            agregarLista();
          } else if (index == 1) {
            // Aqui falta implementar la busqueda
          }
        },
      ),
    );
  }
}
