import 'dart:math';

class MethodOneBL {
  Map<String, dynamic> generateNumbers(int seed, int count) {
    List<Map<String, dynamic>> results = [];
    int currentSeed = seed;

    // Cantidad de dígitos de la semilla
    int digits = seed.toString().length;

    // Generar todos los números
    for (int i = 0; i < count; i++) {
      int yi = currentSeed * currentSeed;
      String yiString = yi.toString();

      // Determinar la cantidad de dígitos actuales en yiString
      int yiLength = yiString.length;

      // Aplicar reglas para agregar ceros a la izquierda
      if ((yiLength % 2 == 0 && digits % 2 != 0) || (yiLength % 2 != 0 && digits % 2 == 0)) {
        yiString = yiString.padLeft(yiLength + 1, '0');
      } else {
        yiString = yiString.padLeft(yiLength, '0');
      }

      // Asegurarse de que yiString tenga suficientes dígitos
      if (yiString.length < digits) {
        yiString = yiString.padLeft(digits, '0');
      }

      String operation = yiString;

      // Extraer los dígitos medios basados en el número de dígitos
      int startIndex = (yiString.length - digits) ~/ 2;
      if (startIndex < 0) startIndex = 0; // Asegurarse de que startIndex no sea negativo

      String middleDigits = yiString.substring(startIndex, startIndex + digits);
      int x1 = int.parse(middleDigits);
      double ri = x1 / pow(10, digits);

      // Guardar el resultado
      results.add({
        'i': i + 1,
        'yi': yi,
        'operation': operation,
        'x1': x1,
        'ri': ri,
      });

      // Actualizar la semilla para la siguiente iteración
      currentSeed = x1;
    }

    // Verificar degeneración después de generar todos los números
    Map<String, String> degenerationResult = verifyDegeneration(results);
    String message = degenerationResult['message']!;
    String messageType = degenerationResult['message_type']!;

    // Mensaje de éxito si la generación fue completada sin problemas
    if (messageType == 'success' && results.isEmpty) {
      message = "No se generaron resultados.";
      messageType = 'error';
    } else if (messageType == 'success') {
      message = message;
    }

    return {
      'results': results,
      'message': message,
      'message_type': messageType,
    };
  }

  Map<String, String> verifyDegeneration(List<Map<String, dynamic>> results) {
    Map<double, int> seenNumbers = {}; // Almacena el número y su primera aparición
    String message = 'La secuencia de números generada es válida.';
    String messageType = 'success';

    bool degenerationDetected = false;
    int degenerateStartIndex = -1;
    bool firstZeroEncountered = false;

    for (int i = 0; i < results.length; i++) {
      double ri = results[i]['ri'];

      // Verificar si el número generado es cero
      if (ri == 0) {
        if (firstZeroEncountered) {
          message = 'Secuencia degenerada: Todos los números generados son cero a partir de la posición ${i + 1}. El número cero se generó en la posición ${i}.';
          messageType = 'error';
          degenerationDetected = true;
          degenerateStartIndex = i;
          break; // No es necesario continuar verificando
        } else {
          firstZeroEncountered = true;
        }
      } else {
        // Verificar si el número aleatorio se repitió
        if (seenNumbers.containsKey(ri)) {
          int firstOccurrence = seenNumbers[ri]!;
          message = 'Degeneración detectada: El número ${ri.toStringAsFixed(4)} se repitió en la posición ${i + 1}. La primera aparición fue en la posición ${firstOccurrence + 1}.';
          messageType = 'error';
          degenerationDetected = true;
          degenerateStartIndex = i;
          break; // No es necesario continuar verificando
        }
        seenNumbers[ri] = i; // Registrar la posición de la primera aparición
      }
    }

    // Mensaje si no se detectó degeneración pero se generaron números
    if (!degenerationDetected && results.isNotEmpty) {
      message = 'La generación se completó sin detectar degeneración. Se generaron ${results.length} números.';
      messageType = 'success';
    } else if (degenerationDetected && degenerateStartIndex >= 0) {
      messageType = 'error';
    }

    return {
      'message': message,
      'message_type': messageType,
    };
  }
}
