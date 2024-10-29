import 'dart:math';

// Función para ejecutar la simulación basada en el diagrama de flujo proporcionado
Map<String, dynamic> calculateEggChickenSimulations(
    int numSimulations, int numDays, double eggProfit, double chickenProfit) {
  List<Map<String, dynamic>> simulations = [];
  double totalNetGain = 0;
  double totalEggs = 0;
  double totalChickensAlive = 0;
  double totalChickensDead = 0;

  for (int sim = 0; sim < numSimulations; sim++) {
    List<Map<String, dynamic>> daysResults = [];
    int CTPV = 0; // Cantidad total de pollos vivos
    int CTPM = 0; // Cantidad total de pollos muertos
    int CTH = 0; // Cantidad total de huevos

    for (int day = 0; day < numDays; day++) {
      // Simulación de la cantidad de huevos (CHG)
      double rCHG = Random().nextDouble();
      int CHG = calculateEggQ(rCHG); // Huevos en este día que puso la gallina
      int CHPD = 0;
      int CPVPP = 0;
      int CPMPP = 0;

      for (int i = 0; i < CHG; i++) {
        double rEH = Random().nextDouble();

        if (rEH > 0.2 && rEH <= 0.5) {
          // Se convierte en pollo
          double rEP = Random().nextDouble();
          if (rEP <= 0.2) {
            CTPM += 1; // Pollo muerto
            CPMPP += 1;
          } else {
            CTPV += 1; // Pollo vivo
            CPVPP += 1;
          }
        } else if (rEH > 0.5) {
          //se convierte en huevo (no roto):
          CTH += 1;
          CHPD += 1;
        }
      }

      // Registrar los resultados de este día
      daysResults.add({
        'dia': day + 1,
        'huevos': CHG,
        'pollosVivos': CPVPP,
        'pollosMuertos': CPMPP,
        'huevosNoRotos': CHPD,
      });
    }

    // Calcular la ganancia de la simulación
    double gainEggs = CTH * eggProfit;
    double gainChickens = CTPV * chickenProfit;
    double netGain = gainEggs + gainChickens;

    // Acumular resultados generales
    totalNetGain += netGain;
    totalEggs += CTH;
    totalChickensAlive += CTPV;
    totalChickensDead += CTPM;

    // Registrar los resultados de esta simulación
    simulations.add({
      'simulacion': sim + 1,
      'dias': daysResults,
      'gananciaNeta': netGain,
      'totalHuevos': CTH,
      'totalPollosVivos': CTPV,
      'totalPollosMuertos': CTPM,
    });
  }

  // Calcular promedios al final de todas las simulaciones
  double avgNetGain = totalNetGain / numSimulations;
  double avgEggs = totalEggs / numSimulations;
  double avgChickensAlive = totalChickensAlive / numSimulations;
  double avgChickensDead = totalChickensDead / numSimulations;

  return {
    'simulations': simulations,
    'totalNetGain': totalNetGain,
    'avgNetGain': avgNetGain,
    'avgEggs': avgEggs,
    'avgChickensAlive': avgChickensAlive,
    'avgChickensDead': avgChickensDead,
  };
}

// Función para calcular la cantidad de huevos que pone la gallina al día
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
  } else if (randomValue <= 0.99) {
    return 5;
  } else {
    return 6;
  }
}
