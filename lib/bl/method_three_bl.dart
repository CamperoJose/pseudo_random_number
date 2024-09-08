import 'dart:math';

class MethodThreeBL {
  Map<String, dynamic> generateNumbers(int seed, int count, int k, int c) {
    List<Map<String, dynamic>> results = [];
    int currentSeed = seed;

    // Parámetros del generador
    int m = (pow(2, (log(count) / log(2)).ceil()))
        .toInt(); // m debe ser una potencia de 2
    double g = log(count) / log(2);
    int a = 1 + 4 * k;

    // Generar todos los números
    for (int i = 0; i < count + 1; i++) {
      int xi = (a * currentSeed + c) % m;
      double ri = xi / (m - 1);

      results.add({
        'i': i + 1,
        'xi': xi,
        'ri': ri.toStringAsFixed(6),
      });

      currentSeed = xi;
    }

    print(results);

    Map<String, String> degenerationResult = verifyDegeneration(results);
    String message = degenerationResult['message']!;
    String messageType = degenerationResult['message_type']!;

    if (messageType == 'success' && results.isEmpty) {
      message = message;
      messageType = 'error';
    } else if (messageType == 'success') {
      message = message;
    }

    return {
      'results': results,
      'message': message,
      'message_type': messageType,
      'parameters': {
        'p': count,
        'g': g.toStringAsFixed(2),
        'm': m,
        'a': a,
        'k': k,
        'c': c,
      },
    };
  }

  Map<String, String> verifyDegeneration(List<Map<String, dynamic>> results) {
    Set<int> seenNumbers = {};
    String message = 'La secuencia de números generada es válida.';
    String messageType = 'success';

    bool degenerationDetected = false;
    int degenerateStartIndex = -1;

    for (int i = 0; i < results.length; i++) {
      int xi = results[i]['xi'];

      if (seenNumbers.contains(xi)) {
        message =
            'Degeneración detectada: El número $xi se repitió en la posición ${i + 1}.';
        messageType = 'error';
        degenerationDetected = true;
        degenerateStartIndex = i;
        break; 
      }
      seenNumbers.add(xi);
    }

    if (!degenerationDetected && results.isNotEmpty) {
      message =
          'La generación se completó sin detectar degeneración. Se generaron ${results.length} números.';
      messageType = 'success';
    } else if (degenerationDetected && degenerateStartIndex >= 0) {
      message =
          'La secuencia repite los valores desde la posición ${degenerateStartIndex + 1}. Los primeros $degenerateStartIndex números son válidos.';
      messageType = 'success';
    }

    return {
      'message': message,
      'message_type': messageType,
    };
  }
}
