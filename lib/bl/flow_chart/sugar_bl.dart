import 'dart:math';

class SugarBL {
  List<List<Map<String, dynamic>>> allSimulations = [];
  Map<String, dynamic> avgStats = {
    'avgNetProfit': 0.0,
    'avgTotalCost': 0.0,
    'avgUnsatisfiedDemand': 0.0,
  };

  void runSimulations({
    required int numSimulations,
    required int numDays,
    required double meanDemand,
    required int minDeliveryDays,
    required int maxDeliveryDays,
    required double inventoryCapacity,
    required double orderCost,
    required double holdingCost,
    required double acquisitionCost,
    required double salePrice,
  }) {
    Random random = Random();
    allSimulations.clear();
    double totalNetProfit = 0;
    double totalCost = 0;
    double totalUnsatisfiedDemand = 0;
    double kgToOrder = 0;

    for (int i = 0; i < numSimulations; i++) {
      double inventory = inventoryCapacity;
      double netProfit = 0;
      double cost = inventoryCapacity * acquisitionCost + orderCost;
      double unsatisfiedDemand = 0;
      int daysRemainingForOrder = 0;
      List<Map<String, dynamic>> simulationData = [];
      double demand = 0;

      for (int day = 1; day <= numDays; day++) {
        if (day % 7 == 0) {
          // Hacer pedido sin ventas
          // generar variable aleatoria entre 0 y 1:
          double randomValue = random.nextDouble();


          int deliveryTime = round(minDeliveryDays + (maxDeliveryDays - minDeliveryDays) * randomValue);
          print('deliveryTime: $deliveryTime');
          daysRemainingForOrder = deliveryTime+1;
          kgToOrder = inventoryCapacity - inventory;
          cost += kgToOrder * acquisitionCost;
          demand = 0;
        } else {
          demand = -meanDemand * log(1 - random.nextDouble());
          double sold = min(demand, inventory);
          double grossIncome = sold * salePrice;
          inventory -= sold;
          netProfit += grossIncome;
          cost += (inventory) * holdingCost;
          unsatisfiedDemand += max(0, demand - sold);
        }

        if (daysRemainingForOrder > 0) {
          daysRemainingForOrder--;
          if (daysRemainingForOrder == 0) {
            inventory = inventory + kgToOrder;
            cost += orderCost;
          }
        }

        simulationData.add({
          'day': day,
          'demand': demand.toStringAsFixed(2),
          'inventory': inventory.toStringAsFixed(2),
          'grossIncome': netProfit.toStringAsFixed(2),
          'cost': cost.toStringAsFixed(2),
          'unsatisfiedDemand': unsatisfiedDemand.toStringAsFixed(2),
          'daysRemainingForOrder': daysRemainingForOrder,
        });
      }

      totalNetProfit += netProfit;
      totalCost += cost;
      totalUnsatisfiedDemand += unsatisfiedDemand;
      allSimulations.add(simulationData);
    }

    avgStats = {
      'avgNetProfit': (totalNetProfit -totalCost) / numSimulations,
      'avgTotalCost': totalCost / numSimulations,
      'avgUnsatisfiedDemand': totalUnsatisfiedDemand / numSimulations,
    };
  }

  Map<String, dynamic> getAverageStats() => avgStats;
  
  int round(double d) {
    return d.round();
  }
}
