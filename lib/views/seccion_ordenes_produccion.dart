import 'package:flutter/material.dart';

class SeccionOrdenesProduccion extends StatelessWidget {
  final Map<String, TextEditingController> controladoresOrdenes;

  const SeccionOrdenesProduccion({
    Key? key,
    required this.controladoresOrdenes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titulo('Órdenes al Proveedor'),
            _matrizOrdenes(),
          ],
        ),
      ),
    );
  }

    Widget _titulo(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        texto,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade800),
      ),
    );
  }

  Widget _matrizOrdenes() {
    List<String> dias = ['Lunes', 'Jueves', 'Sábado'];
    List<String> tipos = ['Pequeño', 'Mediano', 'Grande'];

    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      columnWidths: const {
        0: FractionColumnWidth(0.3),
        1: FractionColumnWidth(0.35),
        2: FractionColumnWidth(0.35),
      },
      children: [
        TableRow(
          children: dias.map((dia) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                dia,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade700),
              ),
            );
          }).toList(),
        ),
        for (var tipo in tipos)
          TableRow(
            children: dias.map((dia) {
              String clave =
                  '${dia.toLowerCase().replaceAll('á', 'a')}${tipo.toLowerCase().replaceAll('é', 'e')}';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controladoresOrdenes[clave],
                  decoration: InputDecoration(
                    labelText: '$tipo',
                    labelStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
