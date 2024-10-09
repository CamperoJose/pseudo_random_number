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
  // Controladores para los inputs
  final TextEditingController _iterationController = TextEditingController();
  final TextEditingController _zX1Controller = TextEditingController(text: '2');
  final TextEditingController _zX2Controller = TextEditingController(text: '3');
  final TextEditingController _zX3Controller = TextEditingController(text: '-1');
  final TextEditingController _x1MinController = TextEditingController(text: '0'); // Límite inferior de X₁
  final TextEditingController _x1MaxController = TextEditingController(text: '10'); // Límite superior de X₁
  final TextEditingController _x2MinController = TextEditingController(text: '0'); // Límite inferior de X₂
  final TextEditingController _x2MaxController = TextEditingController(text: '100'); // Límite superior de X₂
  final TextEditingController _x3MinController = TextEditingController(text: '1'); // Límite inferior de X₃
  final TextEditingController _x3MaxController = TextEditingController(text: '2'); // Límite superior de X₃
  final TextEditingController _x1x2SumController = TextEditingController(text: '20');

  // Variables para los resultados
  double? mejorZ;
  double? mejorX1;
  double? mejorX2;
  double? mejorX3;
  List<Map<String, dynamic>> resultados = [];

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

  Widget _buildObjectiveInput(String label, TextEditingController controller, String variable) {
    return Expanded(
      child: Row(
        children: [
          Text(label),
          SizedBox(
            width: 50,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          Text(variable),
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


  Widget _buildRangeInput(String label, TextEditingController minController, TextEditingController maxController) {
    return Row(
      children: [
        Text('$label: '),
        Expanded(
          child: TextField(
            controller: minController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Mín',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: maxController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Máx',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
      ],
    );
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
          'Ecuaciones',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: MyInput(
            controller: _iterationController,
            labelText: 'Número de Iteraciones',
            hintText: 'Ingrese un número',
            keyboardType: TextInputType.number,
            imageUrl: 'https://res.cloudinary.com/deaodcmae/image/upload/v1728394542/odqt5oxib6rvtog9p1bu.png',
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Función Objetivo:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            _buildObjectiveInput('Z = ', _zX1Controller, 'X₁'),
            _buildObjectiveInput(' + ', _zX2Controller, 'X₂'),
            _buildObjectiveInput(' + ', _zX3Controller, 'X₃'),
          ],
        ),
        const SizedBox(height: 30),
        const Text(
          'Restricciones',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRangeInputWithLimits('X₁', _x1MinController, _x1MaxController),
            const SizedBox(height: 10),
            _buildRangeInputWithLimits('X₂', _x2MinController, _x2MaxController),
            const SizedBox(height: 10),
            _buildRangeInputWithLimits('X₃', _x3MinController, _x3MaxController),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Text(
              'X₁ + X₂ ≤ ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 100,
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
      ],
    ),
  ),
),

            // Panel derecho (resultados)
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
                      'Resultados',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (mejorZ != null)
                      Text(
                        'Mejor Z: $mejorZ',
                        style: const TextStyle(fontSize: 16),
                      ),
                    const SizedBox(height: 10),
                    if (mejorX1 != null)
                      Text(
                        'Mejor X₁: $mejorX1',
                        style: const TextStyle(fontSize: 16),
                      ),
                    const SizedBox(height: 10),
                    if (mejorX2 != null)
                      Text(
                        'Mejor X₂: $mejorX2',
                        style: const TextStyle(fontSize: 16),
                      ),
                    const SizedBox(height: 10),
                    if (mejorX3 != null)
                      Text(
                        'Mejor X₃: $mejorX3',
                        style: const TextStyle(fontSize: 16),
                      ),
                    const SizedBox(height: 20),
                    if (resultados.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: resultados.length,
                          itemBuilder: (context, index) {
                            final resultado = resultados[index];
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Iteración ${index + 1}:'),
                                    Text('Z: ${resultado['ZC']}'),
                                    Text('X₁: ${resultado['X1C']}'),
                                    Text('X₂: ${resultado['X2C']}'),
                                    Text('X₃: ${resultado['X3C']}'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    MyButton(
                      labelText: 'Calcular',
                      onPressed: calcularResultados,
                      
                      imageUrl: 'https://res.cloudinary.com/deaodcmae/image/upload/v1728488878/jqvb8sodpmozey7lsoxh.png',
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
