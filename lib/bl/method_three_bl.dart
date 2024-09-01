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

      // Guardar el resultado
      results.add({
        'i': i + 1,
        'xi': xi,
        'ri': ri.toStringAsFixed(6),
      });

      // Actualizar la semilla para la siguiente iteración
      currentSeed = xi;
    }

    print(results);

    // Verificar degeneración después de generar todos los números
    Map<String, String> degenerationResult = verifyDegeneration(results);
    String message = degenerationResult['message']!;
    String messageType = degenerationResult['message_type']!;

    // Mensaje de éxito si la generación fue completada sin problemas
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

      // Verificar si el número se repitió
      if (seenNumbers.contains(xi)) {
        message =
            'Degeneración detectada: El número $xi se repitió en la posición ${i + 1}.';
        messageType = 'error';
        degenerationDetected = true;
        degenerateStartIndex = i;
        break; // No es necesario continuar verificando
      }
      seenNumbers.add(xi);

      // Verificar si la secuencia se ha convertido en cero
      if (xi == 0) {
        message =
            'Secuencia degenerada: Todos los números generados son cero a partir de la posición ${i + 1}.';
        messageType = 'error';
        degenerationDetected = true;
        degenerateStartIndex = i;
        break; // No es necesario continuar verificando
      }
    }

    // Mensaje si no se detectó degeneración pero se generaron números
    if (!degenerationDetected && results.isNotEmpty) {
      message =
          'La generación se completó sin detectar degeneración. Se generaron ${results.length} números.';
      messageType = 'success';
    } else if (degenerationDetected && degenerateStartIndex >= 0) {
      message =
          'La secuencia se degeneró a partir de la posición ${degenerateStartIndex + 1}. Verifique los números generados.';
      messageType = 'error';
    }

    return {
      'message': message,
      'message_type': messageType,
    };
  }
}
