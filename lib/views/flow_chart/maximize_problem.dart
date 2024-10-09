import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'; // Librería para expresiones matemáticas bonitas
import 'package:pseudo_random_number/components/my_button.dart';
import 'package:pseudo_random_number/components/my_input.dar


class MaximizeProblem extends StatefulWidget {
  const MaximizeProblem({super.key})

  @override
  _MaximizeProblemState createState() => _MaximizeProblemState();
}

class _MaximizeProblemState extends State<MaximizeProblem> {
  // Controladores para los inputs
  final TextEditingController _iterationController = TexitingController();
  final TextEditingController _zX1Controller = TextEditingConler(text: '2');
  final TextEditingController _zX2Controller = TextEditingController(text: '3');
  final TextEditingController _zX3Controller = TextEditingController(text: '-1');

  final TextEditingController _x1MinController = TextEditingController(text: '0');
  final TextEditingController _x1MaxController = TextEditingController(text: '10');
  final TextEditingController _x2MinController = TextEditingController(text: '0');
  final TextEditingController _x2MaxController = TextEditingController(text: '100');
  final TextEditingController _x3MinController = TextEditingController(text: '1');
  final TextEditingController _x3MaxController = TextEditingController(text: '2');
  final TextEditingController _x1x2SumController = TextEditingController(text: '100');

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >;

    return Scaffol(
    appBar: AppBar(
    title: const Text(
    'Problema de Maximización',
    style: TextStyle(color: Color.fromARGB(255, 225, 224, 209)),
    ),
    backgroundColor: const Color(0xFF232635),
    iconTheme: const IconThemeData(color: Color.fromARGB(255, 225, 224, 209)),
    ),
    body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Inputs de iteraciones y función objetivo Z
    Row(
    children: [
    Expanded(
    flex: isWide ? 1 : 3,
    child: MyInput(
    controller: _iterationController,
    labelText: 'Número de Iteraciones',
    hintText: 'Ingrese un número',
    keyboardType: TextInputType.number,
    ),
    ),
    const SizedBox(width: 20.0),
    Expanded(
    flex: isWide ? 2 : 5,
    child: Row(
    children: [
    _buildObjectiveInput('Z = ', _zX1Controller, 'X₁'),
    _buildObjectiveInput('+ ', _zX2Controller, 'X₂'),
    _buildObjectiveInput('- ', _zX3Controller, 'X₃'),
    ],
    ),
    ),
    ],
    ),
    const SizedBox(height: 20.0),

    // Restricciones
    const Text('Restricciones', style: TextStyle(fontWeight: FontWeight.bold)),
    const SizedBox(height: 10.0),
    Row(
    children: [
    _buildRangeInput('0 ≤ X₁ ≤ ', _x1MaxController),
    const SizedBox(width: 10),
    _buildRangeInput('0 ≤ X₂ ≤ ', _x2MaxController),
    const SizedBox(width: 10),
    _buildRangeInput('1 ≤ X₃ ≤ ', _x3MaxController),
    ],
    ),
    const SizedBox(height: 20.0),
    Row(
    children: [
    Text('X₁ + X₂ ≤ '),
    SizedBox(
    width: 100,
    child: TextField(
    controller: _x1x2SumController,
    keyboardType: TextInputType.number,
    decoration: const InputDecoration(
    border: OutlineInputBorder(),
    isDense: true,
    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
    ),
    ),
    ),
    ],
    ),
    const SizedBox(height: 20.0),

    // Botón de calcular
    Row(
    children: [
    MyButton(
    onPressed: () {
    // Aquí irá la lógica para calcular en el futuro
    },
    labelText: 'Calcular',
    buttonColor: const Color(0xFF232635),
    textColor: Colors.white,
    ),
    ],
    ),
    const SizedBox(height: 20.0),

    // Sección de "Resumen de Resultados" y "Prueba de Escritorio"
    if (isWide) ...[
    Row(
    children: [
    Expanded(
    child: Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    ),
    child: const Text(
    'Resumen de Resultados',
    style: TextStyle(fontWeight: FontWeight.bold),
    ),
    ),
    ),
    ],
    ),
    const SizedBox(height: 20.0),
    ],
    const Text('Prueba de Escritorio', style: TextStyle(fontWeight: FontWeight.bold)),
    ],
    ),
    ),
    );
  }

  // Construir input para función objetivo
  Widget _buildObjectiveInput(String prefix, TextEditingController controller, String variable) {
    return Row(
      children: [
        Text(prefix),
        SizedBox(
          width: 50,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
          ),
        ),
        Text(variable, style: const TextStyle(fontStyle: FontStyle.italic)),
      ],
    );
  }

  // Construir input para rangos de restricciones
  Widget _buildRangeInput(String label, TextEditingController controller) {
    return Row(
      children: [
        Text(label),
        SizedBox(
          width: 50,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
          ),
        ),
      ],
    );
  }
}
