import 'package:flutter/material.dart';
import 'package:pseudo_random_number/components/my_button.dart';
import 'package:pseudo_random_number/components/my_input.dart';
import 'package:pseudo_random_number/bl/flow_chart/maximize_problem_bl.dart';

class MaximizeProblem extends StatefulWidget {
  const MaximizeProblem({super.key});

  @override
  _MaximizeProblemState createState() => _MaximizeProblemState();
}

class _MaximizeProblemState extends State<MaximizeProblem> {
  final TextEditingController _iterationController = TextEditingController();
  final TextEditingController _zX1Controller = TextEditingController(text: '2');
  final TextEditingController _zX2Controller = TextEditingController(text: '3');
  final TextEditingController _zX3Controller = TextEditingController(text: '-1');
  final TextEditingController _x1MinController = TextEditingController(text: '0');
  final TextEditingController _x1MaxController = TextEditingController(text: '10');
  final TextEditingController _x2MinController = TextEditingController(text: '0');
  final TextEditingController _x2MaxController = TextEditingController(text: '100');
  final TextEditingController _x3MinController = TextEditingController(text: '1');
  final TextEditingController _x3MaxController = TextEditingController(text: '2');
  final TextEditingController _x1x2SumController = TextEditingController(text: '20');

  double? mejorZ;
  double? mejorX1;
  double? mejorX2;
  double? mejorX3;
  List<Map<String, dynamic>> resultados = [];
  bool isLoading = false;

void calcularResultados() async {
  setState(() => isLoading = true);  // Mostrar el indicador de carga.

  await Future.delayed(const Duration(milliseconds: 500)); // Simula un tiempo de espera para ver el loading.

  var resultado = maximizarFuncion(
    NMI: int.parse(_iterationController.text),
    coefX1: double.parse(_zX1Controller.text),
    coefX2: double.parse(_zX2Controller.text),
    coefX3: double.parse(_zX3Controller.text),
    x1Min: double.parse(_x1MinController.text),
    x1Max: double.parse(_x1MaxController.text),
    x2Min: double.parse(_x2MinController.text),
    x2Max: double.parse(_x2MaxController.text),
    x3Min: double.parse(_x3MinController.text),
    x3Max: double.parse(_x3MaxController.text),
    x1x2Max: double.parse(_x1x2SumController.text),
  );

  setState(() {
    isLoading = false; // Ocultar el indicador de carga.
    mejorZ = resultado['mejorZ'];
    mejorX1 = resultado['mejorX1'];
    mejorX2 = resultado['mejorX2'];
    mejorX3 = resultado['mejorX3'];
    resultados = resultado['estados']
        .map<Map<String, dynamic>>((estado) => {
              'CIT': estado.CIT,
              'ZC': estado.ZC,
              'X1C': estado.X1C,
              'X2C': estado.X2C,
              'X3C': estado.X3C,
            })
        .toList();
  });
}


  void limpiarCampos() {
    _iterationController.clear();
    _zX1Controller.text = '2';
    _zX2Controller.text = '3';
    _zX3Controller.text = '-1';
    _x1MinController.text = '0';
    _x1MaxController.text = '10';
    _x2MinController.text = '0';
    _x2MaxController.text = '100';
    _x3MinController.text = '1';
    _x3MaxController.text = '2';
    _x1x2SumController.text = '20';
    setState(() {
      mejorZ = null;
      mejorX1 = null;
      mejorX2 = null;
      mejorX3 = null;
      resultados.clear();
    });
  }

  Widget _buildObjectiveInput(String label, TextEditingController controller, String variable) {
    return Expanded(
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          SizedBox(
            width: 50,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          Text(variable, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildRangeInputWithLimits(String label, TextEditingController minController, TextEditingController maxController) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: TextField(
            controller: minController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text('≤ $label ≤'),
        const SizedBox(width: 10),
        SizedBox(
          width: 60,
          child: TextField(
            controller: maxController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Iteración')),
          DataColumn(label: Text('Z')),
          DataColumn(label: Text('X₁')),
          DataColumn(label: Text('X₂')),
          DataColumn(label: Text('X₃')),
        ],
        rows: resultados
            .asMap()
            .entries
            .map(
              (entry) => DataRow(
                cells: [
                  DataCell(Text((entry.key + 1).toString())),
                  DataCell(Text(entry.value['ZC'].toStringAsFixed(2))),
                  DataCell(Text(entry.value['X1C'].toStringAsFixed(2))),
                  DataCell(Text(entry.value['X2C'].toStringAsFixed(2))),
                  DataCell(Text(entry.value['X3C'].toStringAsFixed(2))),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problema de Maximización', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF232635),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Ecuaciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 10),
                    MyInput(
                      controller: _iterationController,
                      labelText: 'Número de Iteraciones',
                      hintText: 'Ingrese un número',
                      keyboardType: TextInputType.number,
                      imageUrl: 'https://res.cloudinary.com/deaodcmae/image/upload/v1728394542/odqt5oxib6rvtog9p1bu.png',
                    ),
                    const SizedBox(height: 20),
                    const Text('Función Objetivo:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildObjectiveInput('Z = ', _zX1Controller, 'X₁'),
                        _buildObjectiveInput(' + ', _zX2Controller, 'X₂'),
                        _buildObjectiveInput(' + ', _zX3Controller, 'X₃'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text('Restricciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    _buildRangeInputWithLimits('X₁', _x1MinController, _x1MaxController),
                    _buildRangeInputWithLimits('X₂', _x2MinController, _x2MaxController),
                    _buildRangeInputWithLimits('X₃', _x3MinController, _x3MaxController),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('X₁ + X₂ ≤'),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 60,
                          child: TextField(
                            controller: _x1x2SumController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.calculate),
                          onPressed: calcularResultados,
                          label: const Text('Calcular'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF232635),
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.clear),
                          onPressed: limpiarCampos,
                          label: const Text('Limpiar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isLoading) const Center(child: CircularProgressIndicator()),
                    if (mejorZ != null)
                      Card(
                        color: Colors.green[100],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Mejor Resultado:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              Text('Mejor Z: ${mejorZ!.toStringAsFixed(2)}'),
                              Text('Mejor X₁: ${mejorX1!.toStringAsFixed(2)}'),
                              Text('Mejor X₂: ${mejorX2!.toStringAsFixed(2)}'),
                              Text('Mejor X₃: ${mejorX3!.toStringAsFixed(2)}'),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (resultados.isNotEmpty) Expanded(child: _buildResultsTable()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
