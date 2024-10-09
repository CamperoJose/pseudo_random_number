import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  List<Map<String, dynamic>> resultados = [];
  double mejorZ = 0;
  double mejorX1 = 0;
  double mejorX2 = 0;
  double mejorX3 = 0;

  void calcularResultados() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Problema de Maximización',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF232635),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Panel izquierdo
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
                    // Ecuaciones y entradas
                    // ...
                    MyButton(
                      onPressed: calcularResultados,
                      labelText: 'Calcular',
                      buttonColor: const Color(0xFF232635),
                      textColor: Colors.white,
                      imageUrl: 'https://res.cloudinary.com/deaodcmae/image/upload/v1728488878/jqvb8sodpmozey7lsoxh.png',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Panel derecho (resumen de resultados)
            Expanded(
              flex: 3,
              child: Container(
                height: double.infinity,
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
                      'Resumen de Resultados',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Mejor Z: $mejorZ',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Mejor X₁: $mejorX1',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Mejor X₂: $mejorX2',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Mejor X₃: $mejorX3',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    // Tabla de resultados con scroll
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Iteración')),
                                DataColumn(label: Text('ZC')),
                                DataColumn(label: Text('X₁')),
                                DataColumn(label: Text('X₂')),
                                DataColumn(label: Text('X₃')),
                              ],
                              rows: resultados
                                  .map((resultado) => DataRow(
                                        cells: [
                                          DataCell(Text(resultado['CIT'].toString())),
                                          DataCell(Text(resultado['ZC'].toString())),
                                          DataCell(Text(resultado['X1C'].toString())),
                                          DataCell(Text(resultado['X2C'].toString())),
                                          DataCell(Text(resultado['X3C'].toString())),
                                        ],
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
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
