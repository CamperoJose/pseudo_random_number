import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pseudo_random_number/bl/method_three_bl.dart';
import 'package:pseudo_random_number/components/custom_table.dart';
import 'package:pseudo_random_number/components/my_button.dart';
import 'package:pseudo_random_number/components/my_input.dart';
import 'package:pseudo_random_number/components/message_display.dart';
import 'package:pseudo_random_number/utils/file_download.dart';

class MethodThreePage extends StatefulWidget {
  const MethodThreePage({super.key});

  @override
  _MethodThreePageState createState() => _MethodThreePageState();
}

class _MethodThreePageState extends State<MethodThreePage> {
  final TextEditingController _seedController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  final TextEditingController _kController = TextEditingController();
  final TextEditingController _cController = TextEditingController();
  final TextEditingController _fileNameController = TextEditingController();

  List<Map<String, dynamic>> _results = [];
  String _message = '';
  String _messageType = 'success';

  void _generateNumbers() {
    final int seed = int.tryParse(_seedController.text) ?? 0;
    final int count = int.tryParse(_countController.text) ?? 0;
    final int k = int.tryParse(_kController.text) ?? 0;
    final int c = int.tryParse(_cController.text) ?? 0;

    if (seed > 0 && count > 0 && k >= 0 && c >= 0) {
      setState(() {
        var result = MethodThreeBL().generateNumbers(seed, count, k, c);
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

  void _showFileNamePopup(VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Guardar Archivo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ingrese el nombre del archivo'),
              TextField(
                controller: _fileNameController,
                decoration:
                    const InputDecoration(hintText: 'Nombre del archivo'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _downloadCSVWeb() {
    _showFileNamePopup(() {
      final fileName = _fileNameController.text.isNotEmpty
          ? _fileNameController.text
          : 'datos';
      downloadCSVWeb(_results, fileName);
    });
  }

  void _downloadExcelWeb() {
    _showFileNamePopup(() {
      final fileName = _fileNameController.text.isNotEmpty
          ? _fileNameController.text
          : 'datos';
      downloadExcelWeb(_results, fileName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > 600;
    final bool isMedium = MediaQuery.of(context).size.width > 400;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Algoritmo Congruencial Lineal',
          style: TextStyle(color: Color.fromARGB(255, 225, 224, 209)),
        ),
        backgroundColor: const Color(0xFF232635),
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 225, 224, 209)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Inputs Semilla, Cantidad, k, c
            if (isWide) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: MyInput(
                      controller: _seedController,
                      labelText: 'Valor de X0',
                      hintText: 'Ingrese valor de X0',
                      imageUrl:
                          'https://res.cloudinary.com/deaodcmae/image/upload/v1725228817/upi9pr42qflrdjooufbo.png',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    flex: 1,
                    child: MyInput(
                      controller: _countController,
                      labelText: 'Cantidad',
                      hintText: 'Ingrese la cantidad',
                      imageUrl:
                          'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/mbpo7ijdohdc2anfnj86.png',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: MyInput(
                      controller: _kController,
                      labelText: 'Constante k',
                      hintText: 'Ingrese el valor de k',
                      imageUrl:
                          'https://res.cloudinary.com/deaodcmae/image/upload/v1725228817/sdeqbahu0f7e9jlkvorr.png',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    flex: 1,
                    child: MyInput(
                      controller: _cController,
                      labelText: 'Constante c',
                      hintText: 'Ingrese el valor de c',
                      imageUrl:
                          'https://res.cloudinary.com/deaodcmae/image/upload/v1725228817/wkob3ymmaazdtagv6ky1.png',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ] else if (isMedium) ...[
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: MyInput(
                          controller: _seedController,
                          labelText: 'Semilla',
                          hintText: 'Ingrese la semilla',
                          imageUrl:
                              'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/gbaik513uv0epoapmsby.png',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        flex: 1,
                        child: MyInput(
                          controller: _countController,
                          labelText: 'Cantidad',
                          hintText: 'Ingrese la cantidad',
                          imageUrl:
                              'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/mbpo7ijdohdc2anfnj86.png',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: MyInput(
                          controller: _kController,
                          labelText: 'Constante k',
                          hintText: 'Ingrese el valor de k',
                          imageUrl:
                              'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/gbaik513uv0epoapmsby.png',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        flex: 1,
                        child: MyInput(
                          controller: _cController,
                          labelText: 'Constante c',
                          hintText: 'Ingrese el valor de c',
                          imageUrl:
                              'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/mbpo7ijdohdc2anfnj86.png',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ] else ...[
              Column(
                children: [
                  MyInput(
                    controller: _seedController,
                    labelText: 'Semilla',
                    hintText: 'Ingrese la semilla',
                    imageUrl:
                        'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/gbaik513uv0epoapmsby.png',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10.0),
                  MyInput(
                    controller: _countController,
                    labelText: 'Cantidad',
                    hintText: 'Ingrese la cantidad',
                    imageUrl:
                        'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/mbpo7ijdohdc2anfnj86.png',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10.0),
                  MyInput(
                    controller: _kController,
                    labelText: 'Constante k',
                    hintText: 'Ingrese el valor de k',
                    imageUrl:
                        'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/gbaik513uv0epoapmsby.png',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10.0),
                  MyInput(
                    controller: _cController,
                    labelText: 'Constante c',
                    hintText: 'Ingrese el valor de c',
                    imageUrl:
                        'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/mbpo7ijdohdc2anfnj86.png',
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ],

            const SizedBox(height: 20.0),

            // Buttons Generar, CSV, Excel
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: MyButton(
                    onPressed: _generateNumbers,
                    labelText: 'Generar',
                    imageUrl:
                        'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/zon4ufqykb2cmhrh6v5t.png',
                    buttonColor: const Color(0xFF232635),
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: MyButton(
                    onPressed: _downloadCSVWeb,
                    labelText: 'Descargar CSV',
                    imageUrl:
                        'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/qw6aq26zodhpxalwyys0.png',
                    buttonColor: const Color.fromARGB(255, 162, 27, 25),
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: MyButton(
                    onPressed: _downloadExcelWeb,
                    labelText: 'Descargar Excel',
                    imageUrl:
                        'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/qfhrgkssikmsgncohymd.png',
                    buttonColor: const Color.fromARGB(255, 13, 122, 55),
                    textColor: Colors.white,
                  ),
                )
              ],
            ),

            const SizedBox(height: 20.0),

            // MessageDisplay
            if (_results.isNotEmpty && _message.isNotEmpty)
              Center(
                child: MessageDisplay(
                  message: _message,
                  messageType: _messageType,
                ),
              ),
            const SizedBox(height: 20.0),

            // CustomTable
            if (_results.isNotEmpty)
              Expanded(
              child: Center(
                child: CustomTable(results: _results), 
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _seedController.dispose();
    _countController.dispose();
    _kController.dispose();
    _cController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }
}
