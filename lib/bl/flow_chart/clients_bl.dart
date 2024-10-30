import 'dart:math';

import 'package:pseudo_random_number/bl/flow_chart/maximize_problem_bl.dart';

class ClientsBL {
  final List<Map<String, dynamic>> allSimulations = [];
  final Map<String, dynamic> avgStats = {};

  Future<void> runSimulations({
    required int numSimulations,
    required double fixedCost,
    required double articleCost,
    required double articlePrice,
    required int hoursOpen,
    required double art1,
    required double art2,
    required double art3,
    required double art4,
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
        art1: art1,
        art2: art2,
        art3: art3,
        art4: art4,
      );

      totalNetProfit += simulationResults['totalNetProfit'];
      totalClients += simulationResults['totalClients'] as int;
      totalPurchases += simulationResults['totalPurchases'] as int;

      allSimulations.add(simulationResults);
    }

    avgStats['netProfitAvg'] =
        (totalNetProfit / numSimulations).toStringAsFixed(2);
    avgStats['avgClientsPerDay'] =
        (totalClients / numSimulations).toStringAsFixed(2);
    avgStats['avgPurchasesPerDay'] =
        (totalPurchases / numSimulations).toStringAsFixed(2);
  }

  Map<String, dynamic> _simulateSingleDay({
    required double fixedCost,
    required double articleCost,
    required double articlePrice,
    required int hoursOpen,
    required double art1,
    required double art2,
    required double art3,
    required double art4,
  }) {
    final rng = Random();
    double totalNetProfit = 0;
    int totalClients = 0;
    int totalPurchases = 0;
    List<Map<String, dynamic>> hourDetails = [];
    double netProfitThisHour = -fixedCost;

    int accumulatedClients = 0;
    int accumulatedPurchases = 0;

    for (int hour = 1; hour <= hoursOpen; hour++) {
      // simular clientsThisHour con una distribiucion uniforme 2 +-2:
      double clientPurchasesRND = rng.nextDouble();

      int clientsThisHour = roundDouble(4 - (4 - 0) * clientPurchasesRND);

      List<int> purchasesPerClient = [];
      int purchasesThisHour = 0;

      for (int j = 0; j < clientsThisHour; j++) {
        // generar variable aleatoria entre 0 y 1 con decimales:
        double clientPurchasesRND = rng.nextDouble();

        //mostrar valor random de cada cliente:
        print("=====");
        print(clientPurchasesRND);
        print("=====");

        int clientPurchases = 0;

        // estandarizando los rangios de los articulos:
        double rng0 = 0;
        double rng1 = art1;
        double rng2 = rng0 + rng1;
        double rng3 = rng2 + art2;
        double rng4 = rng3 + art3;
        double rng5 = rng4 + art4;

        if (clientPurchasesRND >= rng0 && clientPurchasesRND <= rng1) {
          //print:

          clientPurchases = 0;
        } else if (clientPurchasesRND > rng1 && clientPurchasesRND <= rng2) {
          //print:

          clientPurchases = 1;
        } else if (clientPurchasesRND > rng3 && clientPurchasesRND <= rng4) {
          clientPurchases = 2;
        } else if (clientPurchasesRND > rng4 && clientPurchasesRND <= rng5) {
          clientPurchases = 3;
        }

        purchasesPerClient.add(clientPurchases);
        if (clientPurchases > 0) {
          purchasesThisHour += clientPurchases;
        }

        // en cas
      }

      double revenueThisHour = purchasesThisHour * articlePrice;
      double variableCostThisHour = purchasesThisHour * articleCost;
      netProfitThisHour =
          netProfitThisHour + purchasesThisHour * (articlePrice - articleCost);

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
