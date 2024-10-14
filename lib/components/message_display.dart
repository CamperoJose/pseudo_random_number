import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;
  final String messageType;

  const MessageDisplay({
    required this.message,
    required this.messageType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Define colors based on message type
    Color backgroundColor;
    Color textColor;
    IconData iconData;

    switch (messageType) {
      case 'error':
        backgroundColor = Colors.redAccent.shade100;
        textColor = Colors.red.shade800;
        iconData = Icons.error_outline;
        break;
      case 'success':
        backgroundColor = Colors.greenAccent.shade100;
        textColor = Colors.green.shade800;
        iconData = Icons.check_circle_outline;
        break;
      default:
        backgroundColor = Colors.blueAccent.shade100;
        textColor = Colors.blue.shade800;
        iconData = Icons.info_outline;
    }

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, 
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, color: textColor, size: 24.0),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
