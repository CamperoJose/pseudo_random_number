import 'package:flutter/material.dart';
import 'package:pseudo_random_number/bl/flow_chart/craps_bl.dart';

class CrapsView extends StatefulWidget {
  @override
  _CrapsViewState createState() => _CrapsViewState();
}

class _CrapsViewState extends State<CrapsView> {
  final TextEditingController _numSimulationsController = TextEditingController();
  final TextEditingController _gamesPerSimulationController = TextEditingController();
  final TextEditingController _gameCostController = TextEditingController();
  final TextEditingController _houseWinAmountController = TextEditingController();
  final TextEditingController _winRuleController = TextEditingController();

  CrapsBL crapsBL = CrapsBL();
  int selectedSimulationIndex = 0;
  bool isLoading = false;

  void _runSimulation() async {
    if (_areInputsValid()) {
      setState(() {
        isLoading = true;


      });
              // mostrar el indicador de carga



      crapsBL.runSimulations(
        numSimulations: int.parse(_numSimulationsController.text),
        gamesPerSimulation: int.parse(_gamesPerSimulationController.text),
        gameCost: double.parse(_gameCostController.text),
        playerWinAmount: double.parse(_houseWinAmountController.text),
        winRule: int.parse(_winRuleController.text),
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
    _gamesPerSimulationController.clear();
    _gameCostController.clear();
    _houseWinAmountController.clear();
    _winRuleController.clear();
    setState(() {
      crapsBL.allSimulations.clear();
    });
  }

  bool _areInputsValid() {
    return _numSimulationsController.text.isNotEmpty &&
           int.tryParse(_numSimulationsController.text) != null &&
           _gamesPerSimulationController.text.isNotEmpty &&
           int.tryParse(_gamesPerSimulationController.text) != null &&
           _gameCostController.text.isNotEmpty &&
           double.tryParse(_gameCostController.text) != null &&
           _houseWinAmountController.text.isNotEmpty &&
           double.tryParse(_houseWinAmountController.text) != null &&
           _winRuleController.text.isNotEmpty &&
           int.tryParse(_winRuleController.text) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.casino, color: Colors.white),
            SizedBox(width: 8),
            Text('Simulación de Craps', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Color(0xFF1A237E), // Azul marino oscuro
          iconTheme: IconThemeData(color: Colors.white), // Cambia el color del botón de ir atrás a blanco

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
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField('Número de Simulaciones', _numSimulationsController, 'Ej: 30', Icons.playlist_add),
          _buildInputField('Juegos por Simulación', _gamesPerSimulationController, 'Ej: 100', Icons.videogame_asset),
          _buildInputField('Costo del Juego (Bs)', _gameCostController, 'Ej: 2.00', Icons.attach_money),
          _buildInputField('Ganancia Jugador (Bs)', _houseWinAmountController, 'Ej: 5.00', Icons.money_off),
          _buildInputField('Regla para Ganar', _winRuleController, 'Ej: 7', Icons.filter_7),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _runSimulation,
                  icon: Icon(Icons.play_circle_fill, color: Colors.white),
                  label: Text('Ejecutar Simulación', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 34, 142, 17), // Azul marino oscuro
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
    final avgStats = crapsBL.getAverageStats();
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.black, width: 1),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 Resumen de Resultados por Todas las Simulaciones',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A237E)),
          ),
          Divider(color: Colors.black54),
          SizedBox(height: 8),
          _buildSummaryRow('🏆 Promedio Juegos Ganados (Casa): ', '${(avgStats['houseWinsAvg'] ?? 0).toStringAsFixed(2)} juegos'),
          _buildSummaryRow('🥇 Promedio Juegos Ganados (Jugador): ', '${(avgStats['playerWinsAvg'] ?? 0).toStringAsFixed(2)} juegos'),
          _buildSummaryRow('🎲 Promedio porcentaje Juegos Ganados (Casa): ', '${(avgStats['houseWinPercentage'] ?? 0).toStringAsFixed(2)} %'),
          _buildSummaryRow('💰 Promedio Ganancia Neta(Casa): ', '${(avgStats['netHouseProfitAvg'] ?? 0).toStringAsFixed(2)} Bs'),
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
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(value, style: TextStyle(fontSize: 14, color: Color(0xFF1A237E))),
        ],
      ),
    );
  }

  Widget _buildSimulationResults() {
    return Column(
      children: [
        if (crapsBL.allSimulations.isNotEmpty)
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
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              underline: SizedBox(),
              items: List.generate(
                crapsBL.allSimulations.length,
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

          SizedBox(height: 5,),
        if (crapsBL.allSimulations.isEmpty)
          Text(
            'No hay simulaciones para mostrar. Ejecuta una simulación primero.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        if (crapsBL.allSimulations.isNotEmpty)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,



                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Color(0xFF1A237E)),
                  headingTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  columns: [
                    DataColumn(label: Text('Juego')),
                    DataColumn(label: Text('🎲 Dado 1')),
                    DataColumn(label: Text('🎲 Dado 2')),
                    DataColumn(label: Text('🎲 Suma Dados', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Gana Jugador', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Gana Casa', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('💸 Ganancia Casa', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: crapsBL.getSimulationResults(selectedSimulationIndex).map((game) {
                    return DataRow(


                      color: MaterialStateProperty.resolveWith(
                          (states) => game['winRuleMet'] ? Colors.green[50] : Colors.red[50]),
                      cells: [
                        DataCell(Text(game['gameNumber'].toString()) ), 
                        DataCell(Text(game['die1'].toString())),
                        DataCell(Text(game['die2'].toString())),
                        DataCell(Text(game['diceSum'].toString(), style: TextStyle(color: Colors.blueAccent))),
                        DataCell(
                          Text(game['winRuleMet'] ? 'Sí' : 'No',
                              style: TextStyle(fontWeight: FontWeight.bold, color: game['winRuleMet'] ? Colors.green : Colors.red)),
                        ),
                        DataCell(Text(game['houseWins'].toString())),
                        DataCell(Text('${game['house_earnings']?.toStringAsFixed(2)} Bs', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold), )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, String hint, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xFF1A237E)),
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Por favor, ingresa valores válidos en todos los campos.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
