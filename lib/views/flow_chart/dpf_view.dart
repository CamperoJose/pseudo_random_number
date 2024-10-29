import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pseudo_random_number/bl/flow_chart/dpf_bl.dart';

class DpfView extends StatefulWidget {
  @override
  _DpfViewState createState() => _DpfViewState();
}

class _DpfViewState extends State<DpfView> {
  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  final TextEditingController _initialCapitalController = TextEditingController();

  List<Map<String, dynamic>> _yearlyData = [];
  bool _isLoading = false;

  void _calculateFixedDeposit() {
    if (_areInputsValid()) {
      setState(() => _isLoading = true);

      setState(() {
        _yearlyData = calculateFixedDeposit(
          int.parse(_yearsController.text),
          double.parse(_interestRateController.text),
          double.parse(_initialCapitalController.text),
        );
        _isLoading = false;
      });
    } else {
      _showValidationError();
    }
  }

  bool _areInputsValid() {
    return _yearsController.text.isNotEmpty &&
           int.tryParse(_yearsController.text) != null &&
           int.parse(_yearsController.text) > 0 &&
           _interestRateController.text.isNotEmpty &&
           double.tryParse(_interestRateController.text) != null &&
           double.parse(_interestRateController.text) > 0 &&
           _initialCapitalController.text.isNotEmpty &&
           double.tryParse(_initialCapitalController.text) != null &&
           double.parse(_initialCapitalController.text) > 0;
  }

  void _clearInputs() {
    _yearsController.clear();
    _interestRateController.clear();
    _initialCapitalController.clear();
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
    final double lastCapital = _yearlyData.isNotEmpty ? _yearlyData.last['capital'] : 0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.savings, color: Colors.white),
            SizedBox(width: 8),
            Text('Depósito a Plazo Fijo', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 189, 86, 95),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(flex: 1, child: _buildInputSection()),
            VerticalDivider(),
            Expanded(flex: 2, child: _buildResultsSection(lastCapital)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 247, 246, 240),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [BoxShadow(color: Color.fromARGB(255, 234, 235, 228).withOpacity(0.3), blurRadius: 8.0)],
        border: Border.all(color: Color.fromARGB(255, 0, 0, 0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle('Parámetros del Depósito'),
          _buildInputField('Tiempo en Años', _yearsController, 'Ej: 5', Icons.calendar_today),
          _buildInputField('Tasa de Interés (%)', _interestRateController, 'Ej: 5.0', Icons.trending_up),
          _buildInputField('Capital Inicial (\$)', _initialCapitalController, 'Ej: 1000.0', Icons.attach_money),
          SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _calculateFixedDeposit,
                icon: Icon(Icons.calculate, color: Colors.white),
                label: Text('Calcular', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 37, 159, 26),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: _clearInputs,
                icon: Icon(Icons.clear, color: Colors.white),
                label: Text('Limpiar', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD32F2F),
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
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 189, 86, 95)),
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
          suffixIcon: Icon(icon, color: Color.fromARGB(255, 189, 86, 95)),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d{0,2})?$')),
        ],
      ),
    );
  }

  Widget _buildResultsSection(double lastCapital) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _yearlyData.isEmpty
            ? Center(child: Text('No hay datos para mostrar. Inicia un cálculo.'))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Después de ${_yearlyData.length} años se alcanzó un capital de \$${lastCapital.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
                    ),
                    SizedBox(height: 16),
                    DataTable(
                      headingRowColor: MaterialStateProperty.all(Color.fromARGB(255, 189, 86, 95)),
                      columns: [
                        DataColumn(label: Text('Año', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                        DataColumn(label: Text('Interés', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                        DataColumn(label: Text('Capital', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                      ],
                      rows: _yearlyData.map((data) {
                        return DataRow(cells: [
                          DataCell(Text(data['year'].toString(), style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)))),
                          DataCell(Text(data['interest'].toStringAsFixed(2), style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)))),
                          DataCell(Text(data['capital'].toStringAsFixed(2), style: TextStyle(color: Color.fromARGB(255, 189, 86, 95)))),
                        ]);
                      }).toList(),
                    ),
                  ],
                ),
              );
  }
}
