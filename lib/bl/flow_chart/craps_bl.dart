import 'dart:math';

class CrapsBL {
  List<List<Map<String, dynamic>>> allSimulations = [];
  Map<String, dynamic> avgStats = {};

  void runSimulations({
    required int numSimulations,
    required int gamesPerSimulation,
    required double gameCost,
    required double playerWinAmount,
    required int winRule,
  }) {
    Random random = Random();
    allSimulations.clear();
    avgStats = {
      "houseWinsTotal": 0,
      "playerWinsTotal": 0,
      "houseWinsAvg": 0.0,
      "netHouseProfitTotal": 0.0,
    };

    double totalHouseEarningsAVG = 0.0;

    for (int i = 0; i < numSimulations; i++) {
      List<Map<String, dynamic>> simulationData = [];
      int houseWins = 0;
      int playerWins = 0;
      double netHouseProfit = 0.0;
      double gananciaCasa = 0;

      for (int j = 0; j < gamesPerSimulation; j++) {
        int die1 = random.nextInt(6) + 1;
        int die2 = random.nextInt(6) + 1;
        int diceSum = die1 + die2;
        

        bool playerWin = diceSum == winRule;
        double playerGain = playerWin ? gameCost * 2 : 0.0;
        netHouseProfit += playerWin ? -playerGain : playerWinAmount;

        if (playerWin) {
          playerWins++;
          gananciaCasa = gananciaCasa + gameCost - playerWinAmount;
        } else {
          houseWins++;
          gananciaCasa = gananciaCasa + gameCost;
        }

        simulationData.add({
          "gameNumber": j + 1,
          "die1": die1,
          "die2": die2,
          "diceSum": diceSum,
          "winRuleMet": playerWin,
          "houseWins": houseWins,
          "playerWins": playerWins,
          "house_earnings": gananciaCasa,
        });
      }

      totalHouseEarningsAVG = totalHouseEarningsAVG + gananciaCasa;

      allSimulations.add(simulationData);
      avgStats["houseWinsTotal"] += houseWins;
      avgStats["playerWinsTotal"] += playerWins;
      avgStats["netHouseProfitTotal"] += netHouseProfit;
    }

    avgStats["houseWinsAvg"] = avgStats["houseWinsTotal"] / numSimulations;
    avgStats["playerWinsAvg"] = avgStats["playerWinsTotal"] / numSimulations;
    avgStats["netHouseProfitAvg"] =
        totalHouseEarningsAVG / numSimulations;
    avgStats["houseWinPercentage"] = 
        (avgStats["houseWinsTotal"] / (numSimulations * gamesPerSimulation)) * 100;
  }

  List<Map<String, dynamic>> getSimulationResults(int simulationIndex) {
    return allSimulations[simulationIndex];
  }

  Map<String, dynamic> getAverageStats() {
    return avgStats;
  }
}
