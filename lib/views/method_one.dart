import 'package:flutter/material.dart';
import 'package:pseudo_random_number/bl/method_one_bl.dart';
import 'package:pseudo_random_number/components/custom_pop_up.dart';
import 'package:pseudo_random_number/components/my_button.dart';
import 'package:pseudo_random_number/components/my_input.dart';
import 'package:pseudo_random_number/components/custom_table.dart';
import 'package:pseudo_random_number/components/message_display.dart'; 
import 'package:pseudo_random_number/utils/file_download.dart';

class MethodOnePage extends StatefulWidget {
  const MethodOnePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MethodOnePageState createState() => _MethodOnePageState();
}

class _MethodOnePageState extends State<MethodOnePage> {
  final TextEditingController _seedController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  final TextEditingController _fileNameController = TextEditingController();

  List<Map<String, dynamic>> _results = [];
  String _message = '';
  String _messageType = 'success';

  void _generateNumbers() {
    final int seed = int.tryParse(_seedController.text) ?? 0;
    final int count = int.tryParse(_countController.text) ?? 0;

    if (seed > 0 && count > 0 && seed.toString().length >= 2) {
      setState(() {
        var result = MethodOneBL().generateNumbers(seed, count);
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
        return CustomPopup(
          title: 'Guardar Archivo',
          message: 'Ingrese el nombre del archivo',
          isInput: true,
          controller: _fileNameController,
          iconPath: 'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/qfhrgkssikmsgncohymd.png',
          backgroundColor: const Color(0xFF232635),
          iconColor: Colors.white,
          onConfirm: () {
            onConfirm();
            Navigator.of(context).pop();
          },
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Algoritmo de los Cuadrados Medios',
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
            // Inputs Semilla y Cantidad
            Row(
              children: [
                Expanded(
                  flex: isWide ? 1 : 2,
                  child: MyInput(
                    controller: _seedController,
                    labelText: 'Semilla',
                    hintText: 'Ingrese un número',
                    imageUrl: 'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/gbaik513uv0epoapmsby.png',
                    keyboardType: TextInputType.number,
                  ),
                ),
                if (isWide) const SizedBox(width: 10.0),
                Expanded(
                  flex: isWide ? 1 : 2,
                  child: MyInput(
                    controller: _countController,
                    labelText: 'Cantidad',
                    hintText: 'Ingrese la cantidad',
                    imageUrl: 'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/mbpo7ijdohdc2anfnj86.png',
                    keyboardType: TextInputType.number,
                  ),
                ),
                if (isWide) const Spacer(), // Espacio vacío en pantallas anchas
              ],
            ),
            const SizedBox(height: 20.0),
            // Botones
            if (isWide)
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: MyButton(
                      onPressed: _generateNumbers,
                      labelText: 'Generar',
                      imageUrl: 'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/zon4ufqykb2cmhrh6v5t.png',
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
                      imageUrl: 'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/qw6aq26zodhpxalwyys0.png',
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
                      imageUrl: 'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/qfhrgkssikmsgncohymd.png',
                      buttonColor: const Color.fromARGB(255, 13, 122, 55),
                      textColor: Colors.white,
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: MyButton(
                      onPressed: _generateNumbers,
                      labelText: 'Generar',
                      imageUrl: 'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/zon4ufqykb2cmhrh6v5t.png',
                      buttonColor: const Color(0xFF232635),
                      textColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        child: MyButton(
                          onPressed: _downloadCSVWeb,
                          labelText: 'Descargar CSV',
                          imageUrl: 'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/qw6aq26zodhpxalwyys0.png',
                          buttonColor: const Color.fromARGB(255, 162, 27, 25),
                          textColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: MyButton(
                          onPressed: _downloadExcelWeb,
                          labelText: 'Descargar Excel',
                          imageUrl: 'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/qfhrgkssikmsgncohymd.png',
                          buttonColor: const Color.fromARGB(255, 13, 122, 55),
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 20.0),
            // Mostrar MessageDisplay solo después de generar números
            if (_results.isNotEmpty && _message.isNotEmpty)
              Center(
                child: MessageDisplay(
                  message: _message,
                  messageType: _messageType,
                ),
              ),
            const SizedBox(height: 20.0),
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
