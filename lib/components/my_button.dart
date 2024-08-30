import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String labelText;
  final String imageUrl; // Cambiado de imagePath a imageUrl
  final Color buttonColor;
  final Color textColor;

  const MyButton({
    Key? key,
    required this.onPressed,
    required this.labelText,
    required this.imageUrl, // Cambiado de imagePath a imageUrl
    this.buttonColor = const Color(0xFF3A5FCD),
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
        elevation: 5.0,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [buttonColor.withOpacity(0.8), buttonColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              child: Image.network( // Cambiado a Image.network para cargar la imagen desde una URL
                imageUrl,
                width: 40.0,
                height: 40.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10.0),
            Text(
              labelText,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.normal,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
