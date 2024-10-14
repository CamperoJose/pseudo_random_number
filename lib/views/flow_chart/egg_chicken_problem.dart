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
  double? avgCTPV;
  double? avgCTPM;

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
      avgCTPV = results['avgCTPV'];
      avgCTPM = results['avgCTPM'];
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Panel izquierdo - Inputs de simulación
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
                      icon: Icon(Icons.calculate),
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
            // Panel derecho - Resultados
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resultados Totales de Simulaciones',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  if (totalNetGain != null) Text('Ganancia Neta Total: $totalNetGain Bs'),
                  if (avgCTPV != null) Text('CTPV Promedio: $avgCTPV Bs'),
                  if (avgCTPM != null) Text('CTPM Promedio: $avgCTPM Bs'),
                  const SizedBox(height: 20),
                  const Divider(),
                  const Text(
                    'Resultados por Simulación',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  if (simulationResults.isNotEmpty)
                    DropdownButton<int>(
                      value: selectedSimulation,
                      items: List.generate(
                        simulationResults.length,
                        (index) => DropdownMenuItem(
                          value: index,
                          child: Text('Simulación ${index + 1}'),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedSimulation = value!;
                        });
                      },
                    ),
                  if (simulationResults.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: simulationResults[selectedSimulation]['dias'].length,
                        itemBuilder: (context, index) {
                          final dia = simulationResults[selectedSimulation]['dias'][index];
                          return Card(
                            child: ListTile(
                              title: Text('Día ${index + 1}'),
                              subtitle: Text(
                                'Ganancia Huevos: ${dia['gananciaHuevos']} Bs, Ganancia Pollos: ${dia['gananciaPollos']} Bs\n'
                                'Costo Huevos: ${dia['costoHuevos']} Bs, Costo Pollos: ${dia['costoPollos']} Bs',
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

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
