import 'dart:math';

class MethodThreeBL {
  Map<String, dynamic> generateNumbers(int seed, int count, int k, int c, int decimalDigits) {
    List<Map<String, dynamic>> results = [];
    int currentSeed = seed;

    if ((count & (count - 1)) != 0) {
      count = pow(2, (log(count) / log(2)).ceil()).toInt();
    }

    // Parámetros del generador
    int m = count; // m ya será una potencia de 2
    double g = log(count) / log(2);
    int a = 1 + 4 * k;

    // Generar todos los números
    for (int i = 0; i < count + 1; i++) {
      int xi = (a * currentSeed + c) % m;
      double ri = xi / (m - 1);

      results.add({
        'i': i + 1,
        'xi': xi,
        'ri': ri.toStringAsFixed(decimalDigits), // Uso de decimalDigits
      });

      currentSeed = xi;
    }

    Map<String, String> degenerationResult = verifyDegeneration(results, count);
    String message = degenerationResult['message']!;
    String messageType = degenerationResult['message_type']!;

    if (messageType == 'success' && results.isEmpty) {
      message = "No se generaron resultados.";
      messageType = 'error';
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

  Map<String, String> verifyDegeneration(List<Map<String, dynamic>> results, int count) {
    Set<String> seenNumbers = {};
    String message = 'La secuencia de números generada es válida.';
    String messageType = 'success';

    // Verificar repetición dentro de los primeros `count` números
    for (int i = 0; i < count; i++) {
      String ri = results[i]['ri'];

      if (seenNumbers.contains(ri)) {
        message = 'Degeneración detectada: El número aleatorio $ri se repitió en la posición ${i + 1}.';
        messageType = 'error';
        return {
          'message': message,
          'message_type': messageType,
        };
      }
      seenNumbers.add(ri);
    }

    // Verificar si el último número generado (posición `count`) es igual al primero
    if (results[count]['ri'] != results[0]['ri']) {
      message = 'Degeneración detectada: El último número aleatorio no coincide con el primero.';
      messageType = 'error';
    } else {
      message = 'La secuencia es cíclica y no tiene degeneración. Se generaron $count números válidos.';
      messageType = 'success';
    }

    return {
      'message': message,
      'message_type': messageType,
    };
  }
}
