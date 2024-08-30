import 'package:flutter/material.dart';
import 'package:pseudo_random_number/views/method_one.dart';

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
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://res.cloudinary.com/deaodcmae/image/upload/v1724986931/jwfefm8l1qbswsdvx4va.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                // Título centrado en la parte superior
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

                Expanded(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(25.0),
                      margin: EdgeInsets.symmetric(horizontal: 30.0),
                      width: double.infinity * 0.66,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 200, 198, 198).withOpacity(0.2),
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20.0),
                          // Columnas de contenido con iconos
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Columna izquierda
                              Expanded(
                                child: Column(
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
                                      'Los números pseudoaleatorios son secuencias de números que parecen ser aleatorios, pero en realidad son generados por un algoritmo determinista. Estos números se utilizan en simulaciones, criptografía y muchos otros campos.',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white70,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 40.0),
                              // Columna derecha con botones animados
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Escoja un método',
                                      style: TextStyle(
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 20.0),
                                    // Botones de métodos con animación de escala
                                    AnimatedButton(
                                      text: 'Método 1',
                                      onPressed: () {
                                        //ir a la página del método 1:
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => MethodOnePage()),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 10.0),
                                    AnimatedButton(
                                      text: 'Método 2',
                                      onPressed: () {
                                        // Acción para Método 2
                                      },
                                    ),
                                    SizedBox(height: 10.0),
                                    AnimatedButton(
                                      text: 'Método 3',
                                      onPressed: () {
                                        // Acción para Método 3
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
