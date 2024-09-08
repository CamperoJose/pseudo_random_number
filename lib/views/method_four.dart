import 'dart:math';
import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:pseudo_random_number/bl/method_four_bl.dart';
import 'package:pseudo_random_number/components/custom_summary.dart';
import 'package:pseudo_random_number/components/custon_table_congruential.dart';
import 'package:pseudo_random_number/components/my_button.dart';
import 'package:pseudo_random_number/components/my_input.dart';
import 'package:pseudo_random_number/components/message_display.dart';
import 'package:pseudo_random_number/utils/file_download.dart';

class MethodFourPage extends StatefulWidget {
  const MethodFourPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MethodFourPageState createState() => _MethodFourPageState();
}

class _MethodFourPageState extends State<MethodFourPage> {
  final TextEditingController _seedController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  final TextEditingController _kController = TextEditingController();
  final TextEditingController _cController = TextEditingController();
  final TextEditingController _fileNameController = TextEditingController();
  final TextEditingController _digitsController = TextEditingController();

  final seedNotifier = ValueNotifier<String>('');
  final quantityNotifier = ValueNotifier<String>('');
  final constantKNotifier = ValueNotifier<String>('');
  final moduloPNotifier = ValueNotifier<String>('');

  List<Map<String, dynamic>> _results = [];
  String _message = '';
  String _messageType = 'success';

  void _generateNumbers() {
    final int seed = int.tryParse(_seedController.text) ?? 0;
    final int count = int.tryParse(_countController.text) ?? 0;
    final int k = int.tryParse(_kController.text) ?? 0;
    final int c = int.tryParse(_cController.text) ?? 0;
    final int digits = int.tryParse(_digitsController.text) ?? 4;

    if (seed > 0 && count > 0 && k >= 0 && c >= 0) {
      setState(() {
        var result = MethodFourBL().generateNumbers(seed, count, k, digits, 0);
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
          'Algoritmo Congruencial Multiplicativo',
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
            // Inputs y nuevo recuadro
            if (isWide) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: MyInput(
                                controller: _seedController,
                                labelText: 'Valor de X0',
                                hintText: 'Ingrese valor de X0',
                                imageUrl:
                                    'https://res.cloudinary.com/deaodcmae/image/upload/v1725228817/upi9pr42qflrdjooufbo.png',
                                keyboardType: TextInputType.number,
                                onChanged: (value) =>
                                    seedNotifier.value = value,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: MyInput(
                                controller: _countController,
                                labelText: 'Cantidad de números a generar',
                                hintText:
                                    'Ingrese la cantidad de números a generar',
                                imageUrl:
                                    'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/mbpo7ijdohdc2anfnj86.png',
                                keyboardType: TextInputType.number,
                                onChanged: (value) =>
                                    quantityNotifier.value = value,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3.0),
                        Row(
                          children: [
                            Expanded(
                              child: MyInput(
                                controller: _kController,
                                labelText: 'Constante k',
                                hintText: 'Ingrese el valor de k',
                                imageUrl:
                                    'https://res.cloudinary.com/deaodcmae/image/upload/v1725228817/sdeqbahu0f7e9jlkvorr.png',
                                keyboardType: TextInputType.number,
                                onChanged: (value) =>
                                    constantKNotifier.value = value,
                              ),
                            ),
                            const SizedBox(width: 10.0),

                          ],
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Centra los elementos en la fila
                            mainAxisSize: MainAxisSize
                                .min, // Ajusta el tamaño al contenido
                            children: [
                              const Text(
                                "Cantidad de decimales a generar:",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign
                                    .center, // Centra el texto dentro de su espacio
                              ),
                              const SizedBox(width: 10), // Espaciado entre el texto y el InputQty
                              InputQty(
                                initVal:
                                    int.tryParse(_digitsController.text) ?? 4,
                                minVal: 2,
                                maxVal: 10,
                                onQtyChanged: (value) {
                                  _digitsController.text = value.toString();
                                },
                                decoration: const QtyDecorationProps(
                                  isBordered: false,
                                  minusBtn:
                                      Icon(Icons.remove, color: Colors.red),
                                  plusBtn: Icon(Icons.add, color: Colors.green),
                                  width: 20,
                                ),
                                qtyFormProps: const QtyFormProps(
                                  enableTyping: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5.0),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    flex: 1,
                    child: MySummary(
                      seed: seedNotifier,
                      quantity: quantityNotifier,
                      constantK: constantKNotifier,
                      moduloP: moduloPNotifier,
                    ),
                  ),
                ],
              ),
            ] else ...[
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: MyInput(
                          controller: _seedController,
                          labelText: 'Valor de X0',
                          hintText: 'Ingrese valor de X0',
                          imageUrl:
                              'https://res.cloudinary.com/deaodcmae/image/upload/v1725228817/upi9pr42qflrdjooufbo.png',
                          keyboardType: TextInputType.number,
                          onChanged: (value) => seedNotifier.value = value,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: MyInput(
                          controller: _countController,
                          labelText: 'Cantidad',
                          hintText: 'Ingrese la cantidad',
                          imageUrl:
                              'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/mbpo7ijdohdc2anfnj86.png',
                          keyboardType: TextInputType.number,
                          onChanged: (value) => quantityNotifier.value = value,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3.0),
                  Row(
                    children: [
                      Expanded(
                        child: MyInput(
                          controller: _kController,
                          labelText: 'Constante k',
                          hintText: 'Ingrese el valor de k',
                          imageUrl:
                              'https://res.cloudinary.com/deaodcmae/image/upload/v1725228817/sdeqbahu0f7e9jlkvorr.png',
                          keyboardType: TextInputType.number,
                          onChanged: (value) => constantKNotifier.value = value,
                        ),
                      ),
                      const SizedBox(width: 10.0),

                    ],
                  ),

                                          Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Centra los elementos en la fila
                            mainAxisSize: MainAxisSize
                                .min, // Ajusta el tamaño al contenido
                            children: [
                              const Text(
                                "Cantidad de decimales a generar:",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign
                                    .center, // Centra el texto dentro de su espacio
                              ),
                              const SizedBox(width: 10), // Espaciado entre el texto y el InputQty
                              InputQty(
                                initVal:
                                    int.tryParse(_digitsController.text) ?? 4,
                                minVal: 2,
                                maxVal: 10,
                                onQtyChanged: (value) {
                                  _digitsController.text = value.toString();
                                },
                                decoration: const QtyDecorationProps(
                                  isBordered: false,
                                  minusBtn:
                                      Icon(Icons.remove, color: Colors.red),
                                  plusBtn: Icon(Icons.add, color: Colors.green),
                                  width: 20,
                                ),
                                qtyFormProps: const QtyFormProps(
                                  enableTyping: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5.0),
                  const SizedBox(height: 3.0),
                  MySummary(
                    seed: seedNotifier,
                    quantity: quantityNotifier,
                    constantK: constantKNotifier,
                    moduloP: moduloPNotifier,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 5.0),
            // Botones
            if (isWide) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MyButton(
                      onPressed: _generateNumbers,
                      labelText: 'Generar',
                      imageUrl:
                          'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/zon4ufqykb2cmhrh6v5t.png',
                      buttonColor: const Color(0xFF232635),
                      textColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: MyButton(
                      onPressed: _downloadCSVWeb,
                      labelText: 'Descargar CSV',
                      imageUrl:
                          'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/qw6aq26zodhpxalwyys0.png',
                      buttonColor: const Color.fromARGB(255, 162, 27, 25),
                      textColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: MyButton(
                      onPressed: _downloadExcelWeb,
                      labelText: 'Descargar Excel',
                      imageUrl:
                          'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/qfhrgkssikmsgncohymd.png',
                      buttonColor: const Color.fromARGB(255, 13, 122, 55),
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ] else if (isMedium) ...[
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
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
                        child: MyButton(
                          onPressed: _downloadCSVWeb,
                          labelText: 'Descargar CSV',
                          imageUrl:
                              'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/qw6aq26zodhpxalwyys0.png',
                          buttonColor: const Color.fromARGB(255, 162, 27, 25),
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  
                  const SizedBox(height: 3.0),
                  MyButton(
                    onPressed: _downloadExcelWeb,
                    labelText: 'Descargar Excel',
                    imageUrl:
                        'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/qfhrgkssikmsgncohymd.png',
                    buttonColor: const Color.fromARGB(255, 13, 122, 55),
                    textColor: Colors.white,
                  ),
                ],
              ),
            ] else ...[
              Column(
                children: [
                  MyButton(
                    onPressed: _generateNumbers,
                    labelText: 'Generar',
                    imageUrl:
                        'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/zon4ufqykb2cmhrh6v5t.png',
                    buttonColor: const Color(0xFF232635),
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 3.0),
                  MyButton(
                    onPressed: _downloadCSVWeb,
                    labelText: 'Descargar CSV',
                    imageUrl:
                        'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/qw6aq26zodhpxalwyys0.png',
                    buttonColor: const Color.fromARGB(255, 162, 27, 25),
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 3.0),
                  MyButton(
                    onPressed: _downloadExcelWeb,
                    labelText: 'Descargar Excel',
                    imageUrl:
                        'https://res.cloudinary.com/deaodcmae/image/upload/v1724986930/qfhrgkssikmsgncohymd.png',
                    buttonColor: const Color.fromARGB(255, 13, 122, 55),
                    textColor: Colors.white,
                  ),
                ],
              ),
            ],

            const SizedBox(height: 5.0),
            if (_results.isNotEmpty && _message.isNotEmpty)
              Center(
                child: MessageDisplay(
                  message: _message,
                  messageType: _messageType,
                ),
              ),
            const SizedBox(height: 5.0),
            Expanded(
              child: Center(
                child: CustomTable(
                    results:
                        _results), // Usando el nuevo componente CustomTable
              ),
            ),
          ],
        ),
      ),
    );
  }
}
