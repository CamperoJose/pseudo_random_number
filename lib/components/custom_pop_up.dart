import 'package:flutter/material.dart';

class CustomPopup extends StatelessWidget {
  final String title;
  final String message;
  final bool isInput;
  final TextEditingController? controller;
  final String iconPath;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onConfirm;

  const CustomPopup({
    Key? key,
    required this.title,
    required this.message,
    this.isInput = false,
    this.controller,
    required this.iconPath,
    required this.backgroundColor,
    required this.iconColor,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Row(
        children: [
          Image.network(iconPath, color: iconColor, width: 30, height: 30),
          const SizedBox(width: 10),
          Text(title, style: TextStyle(color: iconColor)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: const TextStyle(color: Colors.white)),
          if (isInput) ...[
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Nombre del archivo',
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white24,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ]
        ],
      ),
      actions: [
        TextButton(
          onPressed: onConfirm,
          child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
