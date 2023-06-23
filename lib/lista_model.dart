import 'package:hive/hive.dart';

// part 'lista_model.g.dart';

@HiveType(typeId: 0)
class ListaModel extends HiveObject {
  @HiveField(0)
  late String nombre;

  @HiveField(1)
  late String tienda;

  @HiveField(2)
  late List<Map<String, dynamic>> objetosAsociados;
}
