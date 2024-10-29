import 'dart:math';

class ClientsBL {
  final List<Map<String, dynamic>> allSimulations = [];
  final Map<String, dynamic> avgStats = {};

  Future<void> runSimulations({
    required int numSimulations,
    required double fixedCost,
    required double articleCost,
    required double articlePrice,
    required int hoursOpen,
  }) async {
    allSimulations.clear();
    double totalNetProfit = 0;
    int totalClients = 0;
    int totalPurchases = 0;

    for (int i = 0; i < numSimulations; i++) {
      final simulationResults = _simulateSingleDay(
        fixedCost: fixedCost,
        articleCost: articleCost,
        articlePrice: articlePrice,
        hoursOpen: hoursOpen,
      );

      totalNetProfit += simulationResults['totalNetProfit'];
      totalClients += simulationResults['totalClients'] as int;
      totalPurchases += simulationResults['totalPurchases'] as int;

      allSimulations.add(simulationResults);
    }

    avgStats['netProfitAvg'] = (totalNetProfit / numSimulations).toStringAsFixed(2);
    avgStats['avgClientsPerDay'] = (totalClients / numSimulations).toStringAsFixed(2);
    avgStats['avgPurchasesPerDay'] = (totalPurchases / numSimulations).toStringAsFixed(2);
  }

  Map<String, dynamic> _simulateSingleDay({
    required double fixedCost,
    required double articleCost,
    required double articlePrice,
    required int hoursOpen,
  }) {
    final rng = Random();
    double totalNetProfit = 0;
    int totalClients = 0;
    int totalPurchases = 0;
    List<Map<String, dynamic>> hourDetails = [];

    int accumulatedClients = 0;
    int accumulatedPurchases = 0;

    for (int hour = 1; hour <= hoursOpen; hour++) {
      int clientsThisHour = rng.nextInt(20) + 5;
      List<int> purchasesPerClient = [];
      int purchasesThisHour = 0;

      for (int j = 0; j < clientsThisHour; j++) {
        int clientPurchases = rng.nextInt(3); // entre 0 y 2 compras por cliente
        if (clientPurchases > 0) {
          purchasesPerClient.add(clientPurchases);
          purchasesThisHour += clientPurchases;
        }
      }

      double revenueThisHour = purchasesThisHour * articlePrice;
      double variableCostThisHour = purchasesThisHour * articleCost;
      double totalCostThisHour = (fixedCost / hoursOpen) + variableCostThisHour;
      double netProfitThisHour = revenueThisHour - totalCostThisHour;

      accumulatedClients += clientsThisHour;
      accumulatedPurchases += purchasesThisHour;
      totalNetProfit += netProfitThisHour;
      totalClients += clientsThisHour;
      totalPurchases += purchasesThisHour;

      hourDetails.add({
        'hour': hour,
        'clients': clientsThisHour,
        'purchasesPerClient': purchasesPerClient,
        'accumulatedClients': accumulatedClients,
        'accumulatedPurchases': accumulatedPurchases,
        'profit': netProfitThisHour,
      });
    }

    return {
      'totalClients': totalClients,
      'totalPurchases': totalPurchases,
      'totalNetProfit': totalNetProfit,
      'hourlyDetails': hourDetails,
    };
  }

  Map<String, dynamic> getAverageStats() => avgStats;

  void clearSimulations() {
    allSimulations.clear();
    avgStats.clear();
  }
}
