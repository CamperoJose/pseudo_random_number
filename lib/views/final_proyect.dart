import 'package:flutter/material.dart';
import 'package:pseudo_random_number/bl/final_proyect/final_proyect_bl.dart';
import 'seccion_variables.dart';
import 'seccion_ordenes_produccion.dart';

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

  final TextEditingController _cantidadSimulacionesController =
      TextEditingController(text: "50");
  final TextEditingController _numeroSimulacionesController =
      TextEditingController(text: "1");

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
  List<List<Map<String, dynamic>>> simulaciones = [];
  int simulacionSeleccionada = 0;
  bool data_init = false;

  Map<String, double> calcularPromedios() {
    if (simulaciones.isEmpty) return {};

    Map<String, double> sumas = {};
    int totalSimulaciones = simulaciones.length;

    for (var simulacion in simulaciones) {
      var ultimoRegistro = simulacion.lastWhere(
        (registro) => registro['final_data_to_avg'] == true,
        orElse: () => {},
      );
      if (ultimoRegistro.isNotEmpty) {
        ultimoRegistro.forEach((key, value) {
          if (key != 'final_data_to_avg' && value is num) {
            sumas[key] = (sumas[key] ?? 0) + value.toDouble();
          }
        });
      }
    }

    return sumas.map((key, value) => MapEntry(key, value / totalSimulaciones));
  }

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
                    Expanded(
                      flex: 2,
                      child: SeccionVariables(
                        diasDelMes: diasDelMes,
                        vidaUtilPasteles: vidaUtilPasteles,
                        diasEntregaProveedor: diasEntregaProveedor,
                        precioPastelPequeno: precioPastelPequeno,
                        precioPastelMediano: precioPastelMediano,
                        precioPastelGrande: precioPastelGrande,
                        costosAdquisicion: costosAdquisicion,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: SeccionOrdenesProduccion(
                        controladoresOrdenes: _controladoresOrdenes,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _numeroSimulacionesController,
                  decoration: InputDecoration(
                    labelText: "Número de Simulaciones",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
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
                        return 0;
                      }
                    }).toList();

                    int numeroSimulaciones = int.parse(
                        _numeroSimulacionesController.value.text);
                    List<List<Map<String, dynamic>>> nuevosResultados = [];

                    for (int i = 0; i < numeroSimulaciones; i++) {
                      nuevosResultados.add(pasteleriaBL.PasteleriaSimulacion(
                        diasDelMes,
                        precioPastelPequeno,
                        precioPastelMediano,
                        precioPastelGrande,
                        diasEntregaProveedor,
                        vidaUtilPasteles,
                        costosAdquisicion,
                        int.parse(_cantidadSimulacionesController.value.text),
                        detalleOrdenes,
                      ));
                    }

                    setState(() {
                      simulaciones = nuevosResultados;
                      simulacionSeleccionada = 0;
                      data_init = true;
                    });
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
                if (data_init)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: _tablaPromedios(calcularPromedios()),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButton<int>(
                              value: simulacionSeleccionada,
                              items: List.generate(
                                simulaciones.length,
                                (index) => DropdownMenuItem(
                                  value: index,
                                  child: Text("Simulación ${index + 1}"),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  simulacionSeleccionada = value!;
                                });
                              },
                            ),
                            _seccionResultados(
                                simulaciones[simulacionSeleccionada]),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tablaPromedios(Map<String, double> promedios) {
    if (promedios.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No hay datos para promediar.',
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade700),
            ),
          ),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Promedios de Simulaciones',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 10),
            DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    'Métrica',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Promedio',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: promedios.entries
                  .map(
                    (entry) => DataRow(
                      cells: [
                        DataCell(Text(entry.key)),
                        DataCell(Text(entry.value.toStringAsFixed(2))),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _seccionResultados(List<Map<String, dynamic>> data) {
    List<Map<String, dynamic>> registrosFiltrados =
        data.where((registro) => registro.containsKey('day')).toList();

    if (registrosFiltrados.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No hay resultados para mostrar.',
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade700),
            ),
          ),
        ),
      );
    }

    List<String> columnas = registrosFiltrados.first.keys.toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Resultados',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Container(
              height: 300,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: columnas
                        .map((columna) => DataColumn(
                              label: Text(
                                columna,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ))
                        .toList(),
                    rows: registrosFiltrados
                        .map((registro) => DataRow(
                              cells: columnas
                                  .map((columna) => DataCell(
                                        Text(
                                          registro[columna]?.toString() ?? '',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ))
                                  .toList(),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
