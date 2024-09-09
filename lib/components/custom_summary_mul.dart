import 'dart:math';
import 'package:flutter/material.dart';

class MySummary extends StatelessWidget {
  final ValueNotifier<String> seed;
  final ValueNotifier<String> quantity;
  final ValueNotifier<String> constantK;
  final ValueNotifier<String> moduloP;
  final ValueNotifier<String> aSelected;

  const MySummary({
    Key? key,
    required this.seed,
    required this.quantity,
    required this.constantK,
    required this.moduloP,
    required this.aSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5F5DC), Color(0xFFEDEBE0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Resumen de Valores",
            style: TextStyle(
              color: Color(0xFF232635),
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildValueRow("X₀ =", seed),
                    _buildQuantityRow("P =", quantity),
                    _buildValueRow("k =", constantK),
                  ],
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCalculationRow("g =", quantity),
                    _buildCalculationRow("m =", quantity),
                    _buildCalculationRow("a =", constantK),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueRow(String label, ValueNotifier<String> notifier) {
    return ValueListenableBuilder<String>(
      valueListenable: notifier,
      builder: (context, value, child) {
        int? number = int.tryParse(value);
        bool isEven = number != null && number % 2 == 0;
        String displayValue = value.isNotEmpty
            ? '$value (${isEven ? "par" : "impar"})'
            : '-';

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF444444),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                displayValue,
                style: TextStyle(
                  color: isEven ? Colors.red : Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuantityRow(String label, ValueNotifier<String> notifier) {
    return ValueListenableBuilder<String>(
      valueListenable: notifier,
      builder: (context, value, child) {
        int? number = 0;
        String resultText = '-';
        bool isPowerOfTwo = true;
        int nextPowerOfTwo = 0;

        if (value.isNotEmpty) {
          number = int.tryParse(value);
          isPowerOfTwo = number != null && (number & (number - 1)) == 0;
          nextPowerOfTwo = isPowerOfTwo ? number : _nextPowerOfTwo(number!);
          resultText =
              isPowerOfTwo ? value : '$value (se generarán $nextPowerOfTwo)';
          number = isPowerOfTwo ? number : nextPowerOfTwo;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF444444),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resultText,
                      style: TextStyle(
                        color: isPowerOfTwo ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    if (!isPowerOfTwo)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          '* $number es la potencia\nde 2 más cercana.',
                          style: const TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModuloRow(String label, ValueNotifier<String> notifier) {
    return ValueListenableBuilder<String>(
      valueListenable: notifier,
      builder: (context, value, child) {
        bool isValidNumber = int.tryParse(value) != null;
        bool isPrimeNumber = isValidNumber ? _isPrime(int.parse(value)) : false;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF444444),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                isValidNumber ? value : '-',
                style: TextStyle(
                  color: isValidNumber
                      ? (isPrimeNumber ? Colors.green : Colors.red)
                      : Color(0xFF333333),
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(width: 8.0),
              if (isValidNumber)
                Text(
                  isPrimeNumber ? 'es primo' : 'no es primo',
                  style: TextStyle(
                    color: isPrimeNumber ? Colors.green : Colors.red,
                    fontStyle: FontStyle.italic,
                    fontSize: 12.0,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalculationRow(String label, ValueNotifier<String> notifier) {
    return ValueListenableBuilder<String>(
      valueListenable: notifier,
      builder: (context, value, child) {
        String result = '-';
        double? number;

        if (value.isNotEmpty) {
          number = double.tryParse(value);

          if (number != null && number > 0) {
            bool isPowerOfTwo = (log(number) / log(2) % 1 == 0);
            double nextPowerOfTwo = isPowerOfTwo
                ? number
                : _nextPowerOfTwo(number.toInt()).toDouble();

            number = isPowerOfTwo ? number : nextPowerOfTwo;

            if (label.contains('g')) {
              result = (log(number) / log(2) + 2).toStringAsFixed(4);
            } else if (label.contains('m')) {
              double g = log(number) / log(2) + 2;
              result = pow(2, g).toStringAsFixed(4);
            } else if (label.contains('a')) {
              if (aSelected.value == 'a=5+8k') {
                result = (5 + 8 * number).toStringAsFixed(4);
              } else {
                result = (3 + 8 * number).toStringAsFixed(4);
              }
            }
          }
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF444444),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                result,
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isPrime(int number) {
    if (number < 2) return false;
    for (int i = 2; i <= sqrt(number); i++) {
      if (number % i == 0) {
        return false;
      }
    }
    return true;
  }

  int _nextPowerOfTwo(int number) {
    return pow(2, (log(number) / log(2)).ceil()).toInt();
  }
}
