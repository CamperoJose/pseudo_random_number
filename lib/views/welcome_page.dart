import 'package:flutter/material.dart';
import 'package:pseudo_random_number/views/method_one.dart';
import 'package:pseudo_random_number/views/method_three.dart';
import 'package:pseudo_random_number/views/method_two.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Lato',
            ),
      ),
      home: Scaffold(
        body: Stack(
          children: [
            // Fondo con imagen
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://res.cloudinary.com/deaodcmae/image/upload/v1724986931/jwfefm8l1qbswsdvx4va.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 80.0, bottom: 20.0),
                          child: Center(
                            child: Text(
                              'Generador de Números Pseudoaleatorios v1.0.1',
                              style: TextStyle(
                                fontSize: 42.0,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 2.0,
                                shadows: [
                                  Shadow(
                                    offset: Offset(3, 3),
                                    blurRadius: 8.0,
                                    color: Colors.black54,
                                  ),
                                  Shadow(
                                    offset: Offset(-3, -3),
                                    blurRadius: 8.0,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(25.0),
                          margin: EdgeInsets.symmetric(horizontal: 30.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 200, 198, 198)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(25.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 20.0),
                              if (constraints.maxWidth > 600)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildInfoColumn(),
                                    ),
                                    const SizedBox(width: 40.0),
                                    Expanded(
                                      child: _buildMethodsColumn(context),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildInfoColumn(),
                                    const SizedBox(height: 20.0),
                                    _buildMethodsColumn(context),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '¿Qué son los números pseudoaleatorios?',
          style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20.0),
        const Text(
          'Los números pseudoaleatorios son secuencias de números que parecen ser aleatorios, pero en realidad son generados por un algoritmo determinista. Estos números se utilizan en simulaciones, criptografía y muchos otros campos. En este proyecto, exploraremos cómo se generan por cuatro diferentes métodos.',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white70,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 20.0),
        const Text(
          '¿Por qué son importantes?',
          style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20.0),
        const Text(
          'La importancia de los números pseudoaleatorios radica en su capacidad para emular la aleatoriedad verdadera en aplicaciones prácticas donde no es posible utilizar fuentes de entropía pura. Esto es crucial en el diseño de sistemas criptográficos, simulaciones y pruebas aleatorias en ciencias computacionales.',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white70,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildMethodsColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Escoja un método',
          style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20.0),
        _buildButton(
          context,
          'Cuadrados Medios',
          MethodOnePage(),
          Color.fromARGB(255, 9, 116, 135), // Gris Oscuro
        ),
        const SizedBox(height: 10.0),
        _buildButton(
          context,
          'Productos Mínimos',
          MethodTwoPage(),
          Color.fromARGB(255, 107, 9, 102), // Gris Azul
        ),
        const SizedBox(height: 10.0),
        _buildButton(
          context,
          'Algoritmo Congruencial Lineal',
          MethodThreePage(),
          Color.fromARGB(255, 15, 103, 47), // Gris Azul Claro
        ),
        const SizedBox(height: 10.0),
        _buildButton(
          context,
          'Algoritmo Congruencial Multiplicativo',
          MethodThreePage(),
          Color.fromARGB(255, 147, 14, 14), // Gris Medio
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String text, Widget page, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7, // Botón con ancho del 70% del ancho de la pantalla
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
