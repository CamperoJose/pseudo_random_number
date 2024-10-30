import 'package:flutter/material.dart';
import 'package:pseudo_random_number/bl/flow_chart/egg_chicken_problem_bl.dart';

class EggSimulation extends StatefulWidget {
  const EggSimulation({super.key});

  @override
  _EggSimulationState createState() => _EggSimulationState();
}

class _EggSimulationState extends State<EggSimulation> {
  // Controladores para los inputs
  final TextEditingController _simulationsController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _eggProfitController = TextEditingController();
  final TextEditingController _chickenProfitController =
      TextEditingController();

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

  void clearInputs() {
    _simulationsController.clear();
    _daysController.clear();
    _eggProfitController.clear();
    _chickenProfitController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🐣 Simulación de Huevos y Pollos 🐔', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF232635),
          iconTheme: IconThemeData(color: Colors.white), // Cambia el color del botón de ir atrás a blanco
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    _buildInputField('Cantidad de Simulaciones',
                        _simulationsController, 'Ej: 30'),
                    _buildInputField('Cantidad de Días por Simulación',
                        _daysController, 'Ej: 28'),
                    _buildInputField('Ganancia por Huevo (Bs)',
                        _eggProfitController, 'Ej: 1.2'),
                    _buildInputField('Ganancia por Pollo (Bs)',
                        _chickenProfitController, 'Ej: 30'),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: calculateSimulations,
                          icon:
                              const Icon(Icons.calculate, color: Colors.white),
                          label: const Text('Calcular',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            backgroundColor: const Color(0xFF6C63FF),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: clearInputs,
                          icon: const Icon(Icons.clear, color: Colors.white),
                          label: const Text('Limpiar',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            backgroundColor: Colors.redAccent,
                          ),
                        ),
                      ],
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
                    '📊 Resultados Totales de Simulaciones',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
if (avgNetGain != null)
  Text('💰 Ganancia Neta Promedio: ${avgNetGain!.toStringAsFixed(2)} Bs'),
if (avgEggs != null)
  Text('🥚 Promedio de Huevos Puestos: ${avgEggs!.toStringAsFixed(2)}'),
if (avgChickensAlive != null)
  Text('🐔 Promedio Pollos Vivos: ${avgChickensAlive!.toStringAsFixed(2)}'),
if (avgChickensDead != null)
  Text('💀 Promedio Pollos Muertos: ${avgChickensDead!.toStringAsFixed(2)}'),

                  const SizedBox(height: 20),
                  const Text(
                    '🔍 Resultados Individuales por Simulación',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  _buildSimulationDropdown(),
                  const SizedBox(height: 20),
                  if (simulationResults.isNotEmpty)
                    const Text(
                      '📅 Detalles de la Simulación Seleccionada',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  const SizedBox(height: 10),
                  if (simulationResults.isNotEmpty)
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: simulationResults[selectedSimulation]['dias']
                            .length,
                        itemBuilder: (context, index) {
                          var dayResult = simulationResults[selectedSimulation]
                              ['dias'][index];
                          return Card(
                            color: Colors.lightGreen[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '📅 Día ${dayResult['dia']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildDetailRow(
                                    'Huevos:',
                                    '${dayResult['huevos']}',
                                    Icons.egg,
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
  Widget _buildInputField(
      String label, TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.edit),
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
  Widget _buildDetailRow(
      String label, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
