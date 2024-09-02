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
                              'Generador de Números Pseudoaleatorios v0.0 CD',
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
                              // Sección de información adicional


                              // Columnas de contenido con iconos
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
        // Botones de métodos con animación de escala
        AnimatedButton(
          text: 'Cuadrados Medios',
          onPressed: () {
            //ir a la página del método 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MethodOnePage()),
            );
          },
        ),
        const SizedBox(height: 10.0),
        AnimatedButton(
          text: 'Productos Mínimos',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MethodTwoPage()),
            );
          },
        ),
        const SizedBox(height: 10.0),
        AnimatedButton(
          text: 'Algoritmo Congruencial Lineal',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MethodThreePage()),
            );
          },
        ),
        const SizedBox(height: 10.0),
        AnimatedButton(
          text: 'Algoritmo Congruencial Multiplicativo',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MethodThreePage()),
            );
          },
        ),
      ],
    );
  }
}

// Clase para botones animados
class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const AnimatedButton({
    required this.text,
    required this.onPressed,
  });

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onPressed: widget.onPressed,
        ),
      ),
    );
  }
}
