import 'dart:convert'; 
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html; 
import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:pseudo_random_number/bl/method_two_bl.dart';
import 'package:pseudo_random_number/components/my_button.dart';
import 'package:pseudo_random_number/components/my_input.dart';
import 'package:pseudo_random_number/components/custom_table.dart'; 
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';

class MethodTwoPage extends StatefulWidget {
  const MethodTwoPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MethodTwoPageState createState() => _MethodTwoPageState();
}

class _MethodTwoPageState extends State<MethodTwoPage> {
  final TextEditingController _seedControllerOne = TextEditingController();
  final TextEditingController _seedControllerTwo = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  final TextEditingController _digitsController = TextEditingController(text: '4');

  List<Map<String, dynamic>> _results = [];
  String _message = '';
  String _messageType = 'success'; // Valor por defecto

  void _generateNumbers() {
    final int seed = int.tryParse(_seedControllerOne.text) ?? 0;
    final int seed2 = int.tryParse(_seedControllerTwo.text) ?? 0;
    final int count = int.tryParse(_countController.text) ?? 0;
    final int digits = int.tryParse(_digitsController.text) ?? 4;

    if (seed > 0 && count > 0 && digits >= 2) {
      setState(() {
        var result = MethodTwoBL().generateNumbers(seed, seed2, count, digits);
        _results = result['results'];
        _message = result['message'];
        _messageType = result['message_type'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingrese valores válidos')),
      );
    }
  }

  void _downloadCSVWeb() {
    List<List<dynamic>> rows = [
      ['i', 'Yi', 'Operación', 'X1', 'Ri'],
      ..._results.map((result) => [
        result['i'],
        result['yi'],
        result['operation'],
        result['x1'],
        result['ri']
      ])
    ];

    String csv = const ListToCsvConverter().convert(rows);
    final bytes = utf8.encode(csv);
    final base64Str = base64.encode(bytes);

    final anchor = html.AnchorElement(href: 'data:text/csv;base64,$base64Str')
      ..setAttribute('download', 'datos.csv')
      ..click();
  }

  void _downloadExcelWeb() {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    sheet.appendRow(['i', 'Yi', 'Operación', 'X1', 'Ri']);
    _results.forEach((result) {
      sheet.appendRow([
        result['i'],
        result['yi'],
        result['operation'],
        result['x1'],
        result['ri']
      ]);
    });

    final bytes = excel.encode();
    final base64Str = base64.encode(bytes!);

    final anchor = html.AnchorElement(href: 'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,$base64Str')
      ..setAttribute('download', 'datos.xlsx')
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Algoritmo de los Productos Medios',
          style: TextStyle(color: Color.fromARGB(255, 225, 224, 209)),
        ),
        backgroundColor: const Color(0xFF232635),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 225, 224, 209)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: MyInput(
                    controller: _seedControllerOne,
                    labelText: 'Semilla',
                    hintText: 'Ingrese un número',
                    imageUrl: 'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/gbaik513uv0epoapmsby.png',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: MyInput(
                    controller: _seedControllerTwo,
                    labelText: 'Semilla',
                    hintText: 'Ingrese un número',
                    imageUrl: 'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/gbaik513uv0epoapmsby.png',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: MyInput(
                    controller: _countController,
                    labelText: 'Cantidad',
                    hintText: 'Ingrese la cantidad',
                    imageUrl: 'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/mbpo7ijdohdc2anfnj86.png',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 30.0),
                
                Container(
                  width: 140.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Número de dígitos:',
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.0),
                      InputQty(
                        initVal: int.tryParse(_digitsController.text) ?? 4,
                        minVal: 2,
                        maxVal: 10,
                        onQtyChanged: (value) {
                          _digitsController.text = value.toString();
                        },
                        decoration: QtyDecorationProps(
                          isBordered: false,
                          minusBtn: Icon(Icons.remove, color: Colors.red),
                          plusBtn: Icon(Icons.add, color: Colors.green),
                          width: 20,
                        ),
                        qtyFormProps: QtyFormProps(
                          enableTyping: true,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: MyButton(
                      onPressed: () {
                        _generateNumbers();
                      },
                      labelText: 'Generar',
                      imageUrl: 'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/zon4ufqykb2cmhrh6v5t.png',
                      buttonColor: Color(0xFF232635),
                      textColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: MyButton(
                      onPressed: () {
                        _downloadCSVWeb();
                      },
                      labelText: 'Descargar CSV',
                      imageUrl: 'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/qw6aq26zodhpxalwyys0.png',
                      buttonColor: Color.fromARGB(255, 162, 27, 25),
                      textColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: MyButton(
                      onPressed: () {
                        _downloadExcelWeb();
                      },
                      labelText: 'Descargar Excel',
                      imageUrl: 'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/qfhrgkssikmsgncohymd.png',
                      buttonColor: Color.fromARGB(255, 13, 122, 55),
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            // Mostrar el mensaje arriba de la tabla
            if (_message.isNotEmpty)
              Container(
                padding: EdgeInsets.all(10.0),
                color: _messageType == 'error' ? Colors.red[100] : Colors.green[100],
                child: Text(
                  _message,
                  style: TextStyle(
                    color: _messageType == 'error' ? Colors.red[700] : Colors.green[700],
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(height: 20.0),
            Expanded(
              child: Center(
                child: CustomTable(results: _results), // Usando el nuevo componente CustomTable
              ),
            ),
          ],
        ),
      ),
    );
  }
}
