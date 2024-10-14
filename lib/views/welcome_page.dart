import 'package:flutter/material.dart';
import 'package:pseudo_random_number/views/flow_chart/egg_chicken_problem.dart';
import 'package:pseudo_random_number/views/method_four.dart';
import 'package:pseudo_random_number/views/method_one.dart';
import 'package:pseudo_random_number/views/method_three.dart';
import 'package:pseudo_random_number/views/method_two.dart';
import 'package:pseudo_random_number/views/flow_chart/maximize_problem.dart';


class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

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
                              'Modelado, Dinámica de Sistemas y Simulación',
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
                          padding: const EdgeInsets.all(25.0),
                          margin: const EdgeInsets.symmetric(horizontal: 30.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 200, 198, 198)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(25.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 20.0),
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
                        const SizedBox(height: 40.0),
                        // Botón en la parte inferior central

                        Container(
                          padding: const EdgeInsets.all(25.0),
                          margin: const EdgeInsets.symmetric(horizontal: 30.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 200, 198, 198)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(25.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 20.0),
                              if (constraints.maxWidth > 600)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildMethodsColumn2(context),
                                    ),
                                    const SizedBox(width: 40.0),
                                    Expanded(
                                      child: _buildInfoColumn2(),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildMethodsColumn2(context),
                                    const SizedBox(height: 20.0),
                                    _buildInfoColumn2(),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),

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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Qué son los números pseudoaleatorios?',
          style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Los números pseudoaleatorios son secuencias de números que parecen ser aleatorios, pero en realidad son generados por un algoritmo determinista. Estos números se utilizan en simulaciones, criptografía y muchos otros campos. En este proyecto, exploraremos cómo se generan por cuatro diferentes métodos.',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white70,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 20.0),
        Text(
          '¿Por qué son importantes?',
          style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
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

  Widget _buildInfoColumn2() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '¿Qué es la construcción de modelos de simulación?',
        style: TextStyle(
          fontSize: 26.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 20.0),
      Text(
        'La construcción de modelos de simulación implica el desarrollo de representaciones matemáticas o computacionales de sistemas reales. Estos modelos permiten analizar el comportamiento y la dinámica de dichos sistemas bajo diferentes condiciones, sin la necesidad de realizar experimentos físicos.',
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white70,
          height: 1.5,
        ),
        textAlign: TextAlign.justify,
      ),
      SizedBox(height: 20.0),
      Text(
        '¿Por qué son importantes los modelos de simulación?',
        style: TextStyle(
          fontSize: 26.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 20.0),
      Text(
        'Los modelos de simulación son fundamentales para prever y optimizar el comportamiento de sistemas complejos en áreas como ingeniería, economía y ciencias sociales. Permiten realizar estudios que serían costosos o inviables en el mundo real, brindando herramientas para tomar decisiones informadas y mejorar procesos.',
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
          const MethodOnePage(),
          const Color.fromARGB(255, 9, 116, 135), // Gris Oscuro
        ),
        const SizedBox(height: 10.0),
        _buildButton(
          context,
          'Productos Mínimos',
          const MethodTwoPage(),
          const Color.fromARGB(255, 107, 9, 102), // Gris Azul
        ),
        const SizedBox(height: 10.0),
        _buildButton(
          context,
          'Algoritmo Congruencial Lineal',
          const MethodThreePage(),
          const Color.fromARGB(255, 15, 103, 47), // Gris Azul Claro
        ),
        const SizedBox(height: 10.0),
        _buildButton(
          context,
          'Algoritmo Congruencial Multiplicativo',
          const MethodFourPage(),
          const Color.fromARGB(255, 147, 14, 14), // Gris Medio
        ),
      ],
    );
  }


Widget _buildMethodsColumn2(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Text(
        'Escoja una opción',
        style: TextStyle(
          fontSize: 26.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 20.0),
      _buildButton(
        context,
        'Cálculo de Interes',
        const MethodOnePage(),
        const Color(0xFFe63946), // Rojo Coral Vibrante
      ),
      const SizedBox(height: 10.0),
      _buildButton(
        context,
        'Estimación de población',
        const MethodTwoPage(),
        const Color(0xFFf4a261), // Naranja Arena
      ),
      const SizedBox(height: 10.0),
      _buildButton(
        context,
        'Juego de Azar',
        const MethodThreePage(),
        const Color(0xFFe6a746), // Verde Agua
      ),
      const SizedBox(height: 10.0),
      _buildButton(
        context,
        'Problema de Maximización',
        const MaximizeProblem(),
        const Color(0xFF2a9d8f), // Azul Profundo
      ),

      const SizedBox(height: 10.0),
      _buildButton(
        context,
        'Problema de Huevos y Pollos',
        const EggSimulation(),
        const Color.fromARGB(255, 89, 160, 53), // Azul Profundo
      ),

    ],
  );
}



  Widget _buildButton(BuildContext context, String text, Widget page, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
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
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7, // Botón con ancho del 70% del ancho de la pantalla
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
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