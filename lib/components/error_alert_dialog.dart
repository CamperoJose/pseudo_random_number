import 'package:flutter/material.dart';

class ErrorAlertDialog extends StatelessWidget {
  final String imageUrl; // URL de la imagen de alerta
  final String title; // Título de la alerta
  final String description; // Descripción del error
  final VoidCallback onConfirm; // Acción al confirmar

  const ErrorAlertDialog({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 50.0),
          padding: const EdgeInsets.only(
              top: 60.0, bottom: 20.0, left: 20.0, right: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[900],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                ),
                child: const Text(
                  'Entendido',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            radius: 50.0,
            backgroundColor: Colors.red[100],
          ),
        ),
      ],
    );
  }
}
