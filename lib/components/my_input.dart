import 'package:flutter/material.dart';

class MyInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String imageUrl; // Cambiado de imagePath a imageUrl
  final TextInputType keyboardType;
  final double? width; // Parámetro opcional para el ancho

  const MyInput({
    Key? key,
    required this.controller,
    required this.labelText,
    this.hintText = '',
    required this.imageUrl, // Cambiado de imagePath a imageUrl
    this.keyboardType = TextInputType.number,
    this.width, // Inicialización del nuevo parámetro
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Aplica el ancho si se proporciona
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF5F5DC), Color(0xFFEDEBE0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Color(0xFF232635), // Color oscuro para la imagen
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              ),
            ),
            child: Image.network( // Cambiado a Image.network para cargar la imagen desde una URL
              imageUrl,
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                style: TextStyle(
                  color: Color(0xFF333333), // Tono oscuro pero suave para el texto
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
                decoration: InputDecoration(
                  labelText: labelText,
                  hintText: hintText,
                  labelStyle: TextStyle(
                    color: Color(0xFF444444), // Tono medio para la etiqueta
                    fontSize: 16.0,
                  ),
                  hintStyle: TextStyle(
                    color: Color(0xFF666666), // Tono más claro para el hint
                    fontSize: 14.0,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                ),
                cursorColor: Color(0xFF232635),
                cursorWidth: 2.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
