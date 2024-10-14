import 'dart:math';

// Función para ejecutar la simulación basada en el diagrama de flujo proporcionado
Map<String, dynamic> calculateEggChickenSimulations(
    int numSimulations, int numDays, double eggProfit, double chickenProfit) {
  
  List<Map<String, dynamic>> simulations = [];
  double totalNetGain = 0;
  double avgCTPV = 0;
  double avgCTPM = 0;

  for (int sim = 0; sim < numSimulations; sim++) {
    List<Map<String, dynamic>> daysResults = [];
    int CTPV = 0;
    int CTPM = 0;
    int CTH = 0;

    for (int day = 0; day < numDays; day++) {
      // Simulación del huevo perdido (CH6) - Generar aleatorio
      double rCHG = Random().nextDouble();
      int CHG = calculateEggQ(rCHG);

      // Simular el destino de los huevos
      if (CHG > 0) {
        for (int i = 0; i < CHG; i++) {
          double rEH = Random().nextDouble();


          if (rEH <= 1 && rEH > 0.5) {
            CTH += 1;
          } else if (rEH <= 0.5 && rEH > 0.2) {
            //simular destino de pollo:
            double rEP = Random().nextDouble();

            if (rEP <= 0.2) {
              CTPM += 1;
            } else {
              CTPV += 1;
            }
          }
        }
      }

      double gainEggs = CTPV * eggProfit;
      double gainChickens = CTPM * chickenProfit;
      totalNetGain += gainEggs + gainChickens;

      daysResults.add({
        'gananciaHuevos': gainEggs,
        'gananciaPollos': gainChickens,
        'costoHuevos': CTPV * eggProfit * 0.5,
        'costoPollos': CTPM * chickenProfit * 0.7,
      });
    }

    simulations.add({
      'dias': daysResults,
    });

    avgCTPV += CTPV / numDays;
    avgCTPM += CTPM / numDays;
  }

  return {
    'simulations': simulations,
    'totalNetGain': totalNetGain,
    'avgCTPV': avgCTPV / numSimulations,
    'avgCTPM': avgCTPM / numSimulations,
  };
}

// Función para calcular la cantidad de huevos que pone la gallina al dia
int calculateEggQ(double randomValue) {
  if (randomValue <= 0.14) {
    return 0;
  } else if (randomValue <= 0.41) {
    return 1;
  } else if (randomValue <= 0.68) {
    return 2;
  } else if (randomValue <= 0.86) {
    return 3;
  } else if (randomValue <= 0.95) {
    return 4;
  }  else if (randomValue <= 0.99) {
    return 5;
  }else {
    return 6;
  }
}
