import 'dart:math';

// Estructura para almacenar los resultados de cada iteración
class ResultState {
  double CIT;   // Contador de iteraciones
  double ZC;    // Valor de comparación de Z
  double X1C;   // Valor de comparación de X1
  double X2C;   // Valor de comparación de X2
  double X3C;   // Valor de comparación de X3
  double rX1C;  // Valor aleatorio para X1
  double rX2C;  // Valor aleatorio para X2 (redondeado a entero)
  double rX3C;  // Valor aleatorio para X3

  ResultState({
    required this.CIT,
    required this.ZC,
    required this.X1C,
    required this.X2C,
    required this.X3C,
    required this.rX1C,
    required this.rX2C,
    required this.rX3C
  });
}

// Función para generar un valor aleatorio entre un rango dado
double generarValorAleatorio(double min, double max) {
  Random random = Random();
  return min + (random.nextDouble() * (max - min));
}

// Redondear el valor aleatorio para X2
int roundDouble(double value) {
  return value.round();
}

// Función de maximización basada en el diagrama de flujo
Map<String, dynamic> maximizarFuncion({
  required int NMI,  // Número máximo de iteraciones
  required double coefX1,
  required double coefX2,
  required double coefX3,
  required double x1Min,
  required double x1Max,
  required double x2Min,
  required double x2Max,
  required double x3Min,
  required double x3Max,
  required double x1x2Max,
}) {
  double Z = 0; // Inicialmente Z óptimo es 0
  double X1 = 0, X2 = 0, X3 = 0; // Valores óptimos de X1, X2, X3
  List<ResultState> estados = []; // Lista de estados para almacenar cada iteración

  for (int CIT = 0; CIT < NMI; CIT++) {
    // Generar valores aleatorios dentro de los límites de las restricciones
    double rX1C = generarValorAleatorio(x1Min, x1Max);
    double rX2C = roundDouble(generarValorAleatorio(x2Min, x2Max)).toDouble(); // Redondeado a entero
    double rX3C = generarValorAleatorio(x3Min, x3Max);

    // Inicializar ZC para cada iteración
    double ZC = coefX1 * rX1C + coefX2 * rX2C + coefX3 * rX3C;

    // Verificar la restricción adicional X1 + X2 <= x1x2Max
    bool esValido = (rX1C + rX2C <= x1x2Max);

    // Comparar para ver si esta es la mejor solución hasta ahora
    if (esValido && ZC > Z) {
      Z = ZC;
      X1 = rX1C;
      X2 = rX2C;
      X3 = rX3C;
    }

    // Guardar el estado actual, registrando todos los valores
    estados.add(ResultState(
      CIT: CIT.toDouble(),
      ZC: ZC, // Se registra ZC
      X1C: rX1C,
      X2C: rX2C,
      X3C: rX3C,
      rX1C: rX1C,
      rX2C: rX2C,
      rX3C: rX3C
    ));

    // Imprimir cada iteración con todos los valores
    print('Iteración: $CIT, Z=$ZC, X₁=$rX1C, X₂=$rX2C, X₃=$rX3C');
  }

  // Devolver el mejor resultado encontrado junto con los estados
  return {
    'mejorZ': Z,
    'mejorX1': X1,
    'mejorX2': X2,
    'mejorX3': X3,
    'estados': estados
  };
}
