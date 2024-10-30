import 'package:flutter/material.dart';
import 'package:pseudo_random_number/bl/flow_chart/clients_bl.dart';

class ClientsView extends StatefulWidget {
  @override
  _ClientsViewState createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView> {
  final TextEditingController _numSimulationsController =
      TextEditingController();
  final TextEditingController _fixedCostController = TextEditingController();
  final TextEditingController _articleCostController = TextEditingController();
  final TextEditingController _articlePriceController = TextEditingController();
  final TextEditingController _hoursOpenController = TextEditingController();

  final TextEditingController _art1 = TextEditingController();
  final TextEditingController _art2 = TextEditingController();
  final TextEditingController _art3 = TextEditingController();
  final TextEditingController _art4 = TextEditingController();






  ClientsBL clientsBL = ClientsBL();
  int selectedSimulationIndex = 0;
  bool isLoading = false;

  void _runSimulation() async {
    if (_areInputsValid()) {
      setState(() {
        isLoading = true;
      });

      await clientsBL.runSimulations(
        numSimulations: int.parse(_numSimulationsController.text),
        fixedCost: double.parse(_fixedCostController.text),
        articleCost: double.parse(_articleCostController.text),
        articlePrice: double.parse(_articlePriceController.text),
        hoursOpen: int.parse(_hoursOpenController.text),
        art1: double.parse(_art1.text),
        art2: double.parse(_art2.text),
        art3: double.parse(_art3.text),
        art4: double.parse(_art4.text),
      );

      setState(() {
        isLoading = false;
      });
    } else {
      _showValidationError();
    }
  }

  void _clearInputs() {
    _numSimulationsController.clear();
    _fixedCostController.clear();
    _articleCostController.clear();
    _articlePriceController.clear();
    _hoursOpenController.clear();
    setState(() {
      clientsBL.clearSimulations();
    });
  }

  bool _areInputsValid() {
    return _numSimulationsController.text.isNotEmpty &&
        int.tryParse(_numSimulationsController.text) != null &&
        _fixedCostController.text.isNotEmpty &&
        double.tryParse(_fixedCostController.text) != null &&
        _articleCostController.text.isNotEmpty &&
        double.tryParse(_articleCostController.text) != null &&
        _articlePriceController.text.isNotEmpty &&
        double.tryParse(_articlePriceController.text) != null &&
        _hoursOpenController.text.isNotEmpty &&
        int.tryParse(_hoursOpenController.text) != null;
  }

  void _showValidationError() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error en los campos'),
        content:
            Text('Por favor, complete todos los campos con valores válidos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store, color: Colors.white),
            SizedBox(width: 8),
            Text('Simulación de Clientes',
                style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Color(0xFF1A237E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(flex: 1, child: _buildInputSection()),
            VerticalDivider(),
            Expanded(flex: 2, child: _buildResultsSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F6F0),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
              'Número de Simulaciones', _numSimulationsController, 'Ej: 100'),
          _buildInputField(
              'Costos Fijos por Día (Bs)', _fixedCostController, 'Ej: 500.00'),
          _buildInputField(
              'Costo por Artículo (Bs)', _articleCostController, 'Ej: 20.00'),
          _buildInputField('Precio de Venta por Artículo (Bs)',
              _articlePriceController, 'Ej: 30.00'),
          _buildInputField(
              'Horas que Atiende por Día', _hoursOpenController, 'Ej: 8'),
          SizedBox(height: 20),

          //Tabla con inputs de probabilidad de compra por cliente:
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Probabilidad de Cantidad de Productos Comprados por Cliente',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8),
    Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            _buildInputField('0 Artículos', _art1, 'Ej: 0.2'),
            _buildInputField('1 Artículo', _art2, 'Ej: 0.3'),
            _buildInputField('2 Artículos', _art3, 'Ej: 0.4'),
            _buildInputField('3 Artículos', _art4, 'Ej: 0.1'),
          ],
        ),
      ],
    ),
  ],
),


          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _runSimulation,
                  icon: Icon(Icons.play_circle_fill, color: Colors.white),
                  label: Text('Ejecutar Simulación',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 34, 142, 17),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _clearInputs,
                  icon: Icon(Icons.clear, color: Colors.white),
                  label: Text('Limpiar', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryTable(),
        SizedBox(height: 20),
        Expanded(child: _buildSimulationResults()),
      ],
    );
  }

  Widget _buildSummaryTable() {
    final avgStats = clientsBL.getAverageStats();
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.black, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 Resumen de Resultados por Todas las Simulaciones',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1A237E)),
          ),
          Divider(color: Colors.black54),
          SizedBox(height: 8),
          _buildSummaryRow('Promedio Ganancia Neta (Bs): ',
              '${avgStats['netProfitAvg'] ?? 0}'),
          _buildSummaryRow('Promedio Clientes por Día: ',
              '${avgStats['avgClientsPerDay'] ?? 0}'),
          _buildSummaryRow('Promedio Compras por Día: ',
              '${avgStats['avgPurchasesPerDay'] ?? 0}'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(value, style: TextStyle(fontSize: 14, color: Color(0xFF1A237E))),
        ],
      ),
    );
  }

  Widget _buildSimulationResults() {
    return Column(
      children: [
        if (clientsBL.allSimulations.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Color(0xFF1A237E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<int>(
              dropdownColor: Color(0xFF3949AB),
              value: selectedSimulationIndex,
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              underline: SizedBox(),
              items: List.generate(
                clientsBL.allSimulations.length,
                (index) => DropdownMenuItem<int>(
                  value: index,
                  child: Text('Simulación ${index + 1}'),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  selectedSimulationIndex = value!;
                });
              },
            ),
          ),
        SizedBox(height: 10),
        if (clientsBL.allSimulations.isNotEmpty)
          Expanded(
            child: _buildDetailedTable(
                clientsBL.allSimulations[selectedSimulationIndex]),
          ),
      ],
    );
  }

Widget _buildDetailedTable(Map<String, dynamic> simulation) {
  final hourData = simulation['hourlyDetails'] as List<Map<String, dynamic>>? ?? [];

  print("===========================");
  print(hourData);
  print("===========================");

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columnSpacing: 20.0, // Ajusta el espacio entre columnas si es necesario
        columns: [
          DataColumn(label: Text('Hora', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Clientes', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Compras', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Cantidad de Clientes', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Cantidad de Ventas', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Ganancia Neta', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: hourData.map((data) {
          return DataRow(cells: [
            DataCell(Text('${data['hour']}')),
            DataCell(Text('${data['clients']}')),
            DataCell(Text('${data['purchasesPerClient']}')),
            DataCell(Text('${data['accumulatedClients']}')),
            DataCell(Text('${data['accumulatedPurchases']}')),
            DataCell(Text('${data['profit']}')),
          ]);
        }).toList(),
      ),
    ),
  );
}


  Widget _buildInputField(
      String label, TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  @override
  void dispose() {
    _numSimulationsController.dispose();
    _fixedCostController.dispose();
    _articleCostController.dispose();
    _articlePriceController.dispose();
    _hoursOpenController.dispose();
    super.dispose();
  }
}
