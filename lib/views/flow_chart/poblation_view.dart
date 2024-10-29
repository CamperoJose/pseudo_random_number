import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pseudo_random_number/bl/flow_chart/poblation_bl.dart';

class PoblationView extends StatefulWidget {
  @override
  _PoblationViewState createState() => _PoblationViewState();
}

class _PoblationViewState extends State<PoblationView> {
  final TextEditingController _projectionYearController = TextEditingController();
  final TextEditingController _startYearController = TextEditingController();
  final TextEditingController _populationController = TextEditingController();
  final TextEditingController _birthRateController = TextEditingController();
  final TextEditingController _deathRateController = TextEditingController();

  List<Map<String, dynamic>> _yearlyData = [];
  bool _isLoading = false;

  void _calculateProjection() async {
    if (_areInputsValid()) {
      setState(() => _isLoading = true);

      await Future.delayed(Duration(seconds: 1)); // Simula el tiempo de procesamiento

      setState(() {
        _yearlyData = calculatePopulationProjection(
          int.parse(_projectionYearController.text),
          int.parse(_startYearController.text),
          int.parse(_populationController.text),
          double.parse(_birthRateController.text),
          double.parse(_deathRateController.text),
        );
        _isLoading = false;
      });
    } else {
      _showValidationError();
    }
  }

  bool _areInputsValid() {
    return _projectionYearController.text.isNotEmpty &&
           int.tryParse(_projectionYearController.text) != null &&
           int.parse(_projectionYearController.text) > 0 &&
           _startYearController.text.isNotEmpty &&
           int.tryParse(_startYearController.text) != null &&
           _populationController.text.isNotEmpty &&
           int.tryParse(_populationController.text) != null &&
           int.parse(_populationController.text) > 0 &&
           _birthRateController.text.isNotEmpty &&
           double.tryParse(_birthRateController.text) != null &&
           double.parse(_birthRateController.text) >= 0 &&
           _deathRateController.text.isNotEmpty &&
           double.tryParse(_deathRateController.text) != null &&
           double.parse(_deathRateController.text) >= 0;
  }

  void _clearInputs() {
    _projectionYearController.clear();
    _startYearController.clear();
    _populationController.clear();
    _birthRateController.clear();
    _deathRateController.clear();
    setState(() => _yearlyData = []);
  }

  void _showValidationError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Datos inválidos"),
        content: Text("Por favor, asegúrate de ingresar todos los datos correctamente."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int lastYear = _yearlyData.isNotEmpty ? _yearlyData.last['year'] : 0;
    final int lastPopulation = _yearlyData.isNotEmpty ? _yearlyData.last['population'] : 0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.query_stats, color: Colors.white),
            SizedBox(width: 8),
            Text('Proyección de Población - Bolivia', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 80, 94, 185), 
        //posicion:
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(flex: 1, child: _buildInputSection()),
            VerticalDivider(),
            Expanded(flex: 2, child: _buildResultsSection(lastYear, lastPopulation)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 247, 246, 240),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [BoxShadow(color: const Color.fromARGB(255, 234, 235, 228).withOpacity(0.3), blurRadius: 8.0)],
        border: Border.all(color: Color.fromARGB(255, 0, 0, 0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle('Parámetros de Proyección'),
          _buildInputField('Año Final de Proyección', _projectionYearController, 'Ej: 2024', Icons.calendar_today),
          _buildInputField('Año de Inicio', _startYearController, 'Ej: 2013', Icons.access_time),
          _buildInputField('Población Inicial', _populationController, 'Ej: 12000000', Icons.people),
          _buildInputField('Tasa de Natalidad (%)', _birthRateController, 'Ej: 2.5', Icons.trending_up),
          _buildInputField('Tasa de Mortalidad (%)', _deathRateController, 'Ej: 1.5', Icons.trending_down),
          SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _calculateProjection,
                icon: Icon(Icons.calculate, color: Colors.white),
                label: Text('Calcular', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 37, 159, 26), // Azul oscuro
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: _clearInputs,
                icon: Icon(Icons.clear, color: Colors.white),
                label: Text('Limpiar', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD32F2F), // Rojo oscuro
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF3949AB)),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, String hint, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
          suffixIcon: Icon(icon, color: Color(0xFF3949AB)),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*$')),
        ],
      ),
    );
  }

  Widget _buildResultsSection(int lastYear, int lastPopulation) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _yearlyData.isEmpty
            ? Center(child: Text('No hay datos para mostrar. Inicia un cálculo.'))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Población estimada en el año $lastYear: $lastPopulation',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
                    ),
                    SizedBox(height: 16),
                    DataTable(
                      headingRowColor: MaterialStateProperty.all(Color(0xFF3949AB)),
                      columns: [
                        DataColumn(label: Text('Año', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                        DataColumn(label: Text('Nacimientos', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                        DataColumn(label: Text('Muertes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                        DataColumn(label: Text('Población', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                      ],
                      rows: _yearlyData.map((data) {
                        return DataRow(cells: [
                          DataCell(Text(data['year'].toString(), style: TextStyle(color: Color(0xFF3949AB)))),
                          DataCell(Text(data['births'].toString(), style: TextStyle(color: Color(0xFF3949AB)))),
                          DataCell(Text(data['deaths'].toString(), style: TextStyle(color: Color(0xFF3949AB)))),
                          DataCell(Text(data['population'].toString(), style: TextStyle(color: Color(0xFF3949AB)))),
                        ]);
                      }).toList(),
                    ),
                  ],
                ),
              );
  }
}
