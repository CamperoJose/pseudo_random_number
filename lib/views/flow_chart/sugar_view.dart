import 'package:flutter/material.dart';
import 'package:pseudo_random_number/bl/flow_chart/sugar_bl.dart';

class SugarView extends StatefulWidget {
  @override
  _SugarViewState createState() => _SugarViewState();
}

class _SugarViewState extends State<SugarView> {
  final TextEditingController _numSimulationsController = TextEditingController();
  final TextEditingController _numDaysController = TextEditingController();
  final TextEditingController _meanDemandController = TextEditingController();
  final TextEditingController _minDeliveryDaysController = TextEditingController();
  final TextEditingController _maxDeliveryDaysController = TextEditingController();
  final TextEditingController _inventoryCapacityController = TextEditingController();
  final TextEditingController _orderCostController = TextEditingController();
  final TextEditingController _holdingCostController = TextEditingController();
  final TextEditingController _acquisitionCostController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();

  final SugarBL sugarBL = SugarBL();
  bool isLoading = false;

  void _runSimulation() async {
    if (_areInputsValid()) {
      setState(() => isLoading = true);

      await Future.delayed(Duration(seconds: 1)); // Simulación de carga.

      sugarBL.runSimulations(
        numSimulations: int.parse(_numSimulationsController.text),
        numDays: int.parse(_numDaysController.text),
        meanDemand: double.parse(_meanDemandController.text),
        minDeliveryDays: int.parse(_minDeliveryDaysController.text),
        maxDeliveryDays: int.parse(_maxDeliveryDaysController.text),
        inventoryCapacity: double.parse(_inventoryCapacityController.text),
        orderCost: double.parse(_orderCostController.text),
        holdingCost: double.parse(_holdingCostController.text),
        acquisitionCost: double.parse(_acquisitionCostController.text),
        salePrice: double.parse(_salePriceController.text),
      );

      setState(() => isLoading = false);
    } else {
      _showValidationError();
    }
  }

  void _clearInputs() {
    _numSimulationsController.clear();
    _numDaysController.clear();
    _meanDemandController.clear();
    _minDeliveryDaysController.clear();
    _maxDeliveryDaysController.clear();
    _inventoryCapacityController.clear();
    _orderCostController.clear();
    _holdingCostController.clear();
    _acquisitionCostController.clear();
    _salePriceController.clear();
    setState(() => sugarBL.allSimulations.clear());
  }

  bool _areInputsValid() {
    return _numSimulationsController.text.isNotEmpty &&
           _numDaysController.text.isNotEmpty &&
           _meanDemandController.text.isNotEmpty &&
           _minDeliveryDaysController.text.isNotEmpty &&
           _maxDeliveryDaysController.text.isNotEmpty &&
           _inventoryCapacityController.text.isNotEmpty &&
           _orderCostController.text.isNotEmpty &&
           _holdingCostController.text.isNotEmpty &&
           _acquisitionCostController.text.isNotEmpty &&
           _salePriceController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simulación de Demanda de Azúcar'),
        backgroundColor: Colors.teal,
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
    return ListView(
      children: [
        _buildInputField('Número de Simulaciones', _numSimulationsController),
        _buildInputField('Cantidad de Días', _numDaysController),
        _buildInputField('Media Demanda Diaria (kg)', _meanDemandController),
        _buildInputField('Días Mínimos de Entrega', _minDeliveryDaysController),
        _buildInputField('Días Máximos de Entrega', _maxDeliveryDaysController),
        _buildInputField('Capacidad de Inventario (kg)', _inventoryCapacityController),
        _buildInputField('Costo de Orden (Bs)', _orderCostController),
        _buildInputField('Costo de Mantenimiento (Bs/kg)', _holdingCostController),
        _buildInputField('Costo de Adquisición (Bs/kg)', _acquisitionCostController),
        _buildInputField('Precio de Venta (Bs/kg)', _salePriceController),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _runSimulation,
          child: Text('Ejecutar Simulación'),
        ),
        ElevatedButton(
          onPressed: _clearInputs,
          child: Text('Limpiar'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }

  Widget _buildResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryTable(),
        Expanded(child: _buildSimulationResults()),
      ],
    );
  }

  Widget _buildSummaryTable() {
    final avgStats = sugarBL.getAverageStats();
    return DataTable(
      columns: const [
        DataColumn(label: Text('Promedio Ganancia Neta')),
        DataColumn(label: Text('Promedio Costos Totales')),
        DataColumn(label: Text('Demanda Insatisfecha Promedio')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text((avgStats['avgNetProfit'] ?? 0).toStringAsFixed(2))),
          DataCell(Text((avgStats['avgTotalCost'] ?? 0).toStringAsFixed(2))),
          DataCell(Text((avgStats['avgUnsatisfiedDemand'] ?? 0).toStringAsFixed(2))),
        ]),
      ],
    );
  }

Widget _buildSimulationResults() {
  return ListView.builder(
    itemCount: sugarBL.allSimulations.length,
    itemBuilder: (context, index) {
      final simulation = sugarBL.allSimulations[index];
      return ExpansionTile(
        title: Text('Simulación ${index + 1}'),
        children: [
          _buildSimulationTable(simulation),
        ],
      );
    },
  );
}

Widget _buildSimulationTable(List<Map<String, dynamic>> simulation) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal, // Maneja mejor tablas anchas.
    child: DataTable(
      columns: const [
        DataColumn(label: Text('Día')),
        DataColumn(label: Text('Kg Demanda')),
        DataColumn(label: Text('Inventario (kg)')),
        DataColumn(label: Text('Ingreso Bruto')),
        DataColumn(label: Text('Costos')),
        DataColumn(label: Text('Demanda Insatisfecha')),
        DataColumn(label: Text('Días para Pedido')),
      ],
      rows: simulation.map((day) {
        return DataRow(cells: [
          DataCell(Text(day['day'].toString())),
          DataCell(Text(day['demand'].toString())),
          DataCell(Text(day['inventory'].toString())),
          DataCell(Text(day['grossIncome'].toString())),
          DataCell(Text(day['cost'].toString())),
          DataCell(Text(day['unsatisfiedDemand'].toString())),
          DataCell(Text(day['daysRemainingForOrder'].toString())),
        ]);
      }).toList(),
    ),
  );
}


  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Por favor, ingresa valores válidos.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
