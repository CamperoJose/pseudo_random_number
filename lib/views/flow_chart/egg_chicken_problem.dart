import 'package:flutter/material.dart';
import 'package:pseudo_random_number/bl/flow_chart/egg_chicken_problem_bl.dart';

class EggSimulation extends StatefulWidget {
  const EggSimulation({super.key});

  @override
  _EggSimulationState createState() => _EggSimulationState();
}

class _EggSimulationState extends State<EggSimulation> {
  // Controladores para los inputs
  final TextEditingController _simulationsController = TextEditingController(text: '1');
  final TextEditingController _daysController = TextEditingController(text: '100');
  final TextEditingController _eggProfitController = TextEditingController(text: '1.2');
  final TextEditingController _chickenProfitController = TextEditingController(text: '30');

  // Resultados por simulación
  List<Map<String, dynamic>> simulationResults = [];
  double? totalNetGain;
  double? avgNetGain;
  double? avgEggs;
  double? avgChickensAlive;
  double? avgChickensDead;

  int selectedSimulation = 0;

  // Llamada a la lógica segregada en el archivo BL
  void calculateSimulations() {
    setState(() {
      var results = calculateEggChickenSimulations(
        int.parse(_simulationsController.text),
        int.parse(_daysController.text),
        double.parse(_eggProfitController.text),
        double.parse(_chickenProfitController.text),
      );
      simulationResults = results['simulations'];
      totalNetGain = results['totalNetGain'];
      avgNetGain = results['avgNetGain'];
      avgEggs = results['avgEggs'];
      avgChickensAlive = results['avgChickensAlive'];
      avgChickensDead = results['avgChickensDead'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulación de Producción de Pollos y Huevos'),
        backgroundColor: const Color(0xFF232635),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Panel izquierdo - Inputs de simulación (1/4 de la pantalla)
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Parámetros de Simulación',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    _buildInputField('Cantidad de Simulaciones', _simulationsController),
                    _buildInputField('Cantidad de Días por Simulación', _daysController),
                    _buildInputField('Ganancia por Huevo (Bs)', _eggProfitController),
                    _buildInputField('Ganancia por Pollo (Bs)', _chickenProfitController),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: calculateSimulations,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Calcular Simulaciones'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        backgroundColor: const Color(0xFF6C63FF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Panel derecho - Resultados (3/4 de la pantalla)
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resultados Totales de Simulaciones',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  if (avgNetGain != null) Text('Ganancia Neta Promedio: $avgNetGain Bs'),
                  if (avgEggs != null) Text('Promedio de Huevos por Simulación: $avgEggs'),
                  if (avgChickensAlive != null) Text('Promedio de Pollos Vivos: $avgChickensAlive'),
                  if (avgChickensDead != null) Text('Promedio de Pollos Muertos: $avgChickensDead'),
                  const SizedBox(height: 20),
                  const Text(
                    'Resultados Individuales por Simulación',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  _buildSimulationDropdown(),
                  const SizedBox(height: 20),
                  if (simulationResults.isNotEmpty)
                    const Text(
                      'Detalles de la Simulación Seleccionada',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  const SizedBox(height: 10),
                  if (simulationResults.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: simulationResults[selectedSimulation]['dias'].length,
                        itemBuilder: (context, index) {
                          var dayResult = simulationResults[selectedSimulation]['dias'][index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Día ${dayResult['dia']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildDetailRow(
                                    'Huevos:',
                                    '${dayResult['huevos']}',
                                    Icons.egg_alt,
                                    Colors.orange,
                                  ),
                                  _buildDetailRow(
                                    'Pollos Vivos:',
                                    '${dayResult['pollosVivos']}',
                                    Icons.check_circle,
                                    Colors.green,
                                  ),
                                  _buildDetailRow(
                                    'Pollos Muertos:',
                                    '${dayResult['pollosMuertos']}',
                                    Icons.cancel,
                                    Colors.red,
                                  ),
                                  _buildDetailRow(
                                    'Huevos No Rotos:',
                                    '${dayResult['huevosNoRotos']}',
                                    Icons.egg,
                                    Colors.yellow,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Campo de texto para los parámetros de simulación
  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  // Dropdown para seleccionar la simulación a mostrar
  Widget _buildSimulationDropdown() {
    return DropdownButton<int>(
      value: selectedSimulation,
      onChanged: (int? newValue) {
        setState(() {
          selectedSimulation = newValue!;
        });
      },
      items: List.generate(simulationResults.length, (index) {
        return DropdownMenuItem<int>(
          value: index,
          child: Text('Simulación ${simulationResults[index]['simulacion']}'),
        );
      }),
    );
  }

  // Función para construir una fila de detalle de simulación
  Widget _buildDetailRow(String label, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(value),
        ],
      ),
    );
  }
}
