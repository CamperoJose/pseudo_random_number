import 'package:flutter/material.dart';
import 'package:pseudo_random_number/bl/final_proyect/final_proyect_bl.dart';

class BakeryProject extends StatefulWidget {
  @override
  _BakeryProjectState createState() => _BakeryProjectState();
}

class _BakeryProjectState extends State<BakeryProject> {
  // Constantes
  final int diasDelMes = 31;
  final double precioPastelPequeno = 85.0;
  final double precioPastelMediano = 110.0;
  final double precioPastelGrande = 140.0;
  final int diasEntregaProveedor = 2;
  final int vidaUtilPasteles = 3;

  final Map<String, List<Map<String, dynamic>>> costosAdquisicion = {
    "pequeno": [
      {"rango": "1-6", "precio": 60.0},
      {"rango": "7-12", "precio": 55.0},
      {"rango": "13-25", "precio": 50.0},
    ],
    "mediano": [
      {"rango": "1-6", "precio": 80.0},
      {"rango": "7-12", "precio": 75.0},
      {"rango": "13-25", "precio": 70.0},
    ],
    "grande": [
      {"rango": "1-6", "precio": 95.0},
      {"rango": "7-12", "precio": 90.0},
      {"rango": "13-25", "precio": 85.0},
    ],
  };

  // Variables editables
  final TextEditingController _cantidadSimulacionesController =
      TextEditingController(text: "50");

  final Map<String, TextEditingController> _controladoresOrdenes = {
    "lunespequeño": TextEditingController(text: "12"),
    "lunesmediano": TextEditingController(text: "8"),
    "lunesgrande": TextEditingController(text: "5"),
    "juevespequeño": TextEditingController(text: "12"),
    "juevesmediano": TextEditingController(text: "8"),
    "juevesgrande": TextEditingController(text: "5"),
    "sabadopequeño": TextEditingController(text: "12"),
    "sabadomediano": TextEditingController(text: "8"),
    "sabadogrande": TextEditingController(text: "5"),
  };

  final PasteleriaBL pasteleriaBL = PasteleriaBL();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cake, color: Colors.white),
            SizedBox(width: 8),
            Text('Pastelería Emanuel', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.yellow.shade700,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _seccionVariables()),
                    const SizedBox(width: 16),
                    Expanded(flex: 1, child: _seccionOrdenesProduccion()),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    List<int> detalleOrdenes =
                        _controladoresOrdenes.entries.map((entry) {
                      try {
                        return int.parse(entry.value.text);
                      } catch (e) {
                        print(
                            'Error parsing ${entry.key}: ${entry.value.text}');
                        return 0; // Valor predeterminado en caso de error
                      }
                    }).toList();

                    print("boton pressed");
                    List<Map<String, dynamic>> data =
                        pasteleriaBL.PasteleriaSimulacion(
                      diasDelMes,
                      precioPastelPequeno,
                      precioPastelMediano,
                      precioPastelGrande,
                      diasEntregaProveedor,
                      vidaUtilPasteles,
                      costosAdquisicion,
                      int.parse(_cantidadSimulacionesController.value.text),
                      detalleOrdenes,
                    );

                    bool a = false;
                    for (var registro in data) {
                      print(registro.entries
                          .map((entry) => '${entry.key}: ${entry.value}')
                          .join(', '));

                      // if (a == true) {
                      //   print(" ");
                      //   a = false;
                      // } else {
                      //   a = true;
                      // }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 34, 158, 9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Realizar Simulación',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(color: Colors.grey, thickness: 4),
                _seccionResultados(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _seccionVariables() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titulo('Variables Constantes'),
            _listaVariables(),
          ],
        ),
      ),
    );
  }

  Widget _seccionOrdenesProduccion() {
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

  Widget _seccionResultados() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Resultados aparecerán aquí.',
            style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade700),
          ),
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

  Widget _listaVariables() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoVariable(
                      'Días del Mes', '${diasDelMes.toString()} días'),
                  _infoVariable(
                      'Vida Útil de los Pasteles', '$vidaUtilPasteles días'),
                  _infoVariable('Días de Entrega del Proveedor',
                      '$diasEntregaProveedor días'),
                  _infoVariable('Precio de Venta Pastel Pequeño',
                      '$precioPastelPequeno Bs'),
                  _infoVariable('Precio de Venta Pastel Mediano',
                      '$precioPastelMediano Bs'),
                  _infoVariable('Precio de Venta Pastel Grande',
                      '$precioPastelGrande Bs'),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoCostosAdquisicion(
                      'Costos Pastel Pequeño', costosAdquisicion['pequeno']!),
                  _infoCostosAdquisicion(
                      'Costos Pastel Mediano', costosAdquisicion['mediano']!),
                  _infoCostosAdquisicion(
                      'Costos Pastel Grande', costosAdquisicion['grande']!),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _infoVariable(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(etiqueta,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
          ),
          Expanded(
            flex: 1,
            child: Text(valor,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _infoCostosAdquisicion(
      String tipo, List<Map<String, dynamic>> costos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tipo,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade700)),
        ...costos.map((costo) {
          return Text(
            '${costo['rango']}: ${costo['precio']} Bs',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          );
        }).toList(),
      ],
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
                  controller: _controladoresOrdenes[clave],
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
