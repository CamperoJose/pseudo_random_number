import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDeveloperPage extends StatelessWidget {
  const AboutDeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre el Desarrollador'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://example.com/developer_image.jpg'), // Reemplazar con la URL de la imagen del desarrollador
            ),
            const SizedBox(height: 20),
            const Text(
              'Nombre: José Antonio Campero Morales',
              style: TextStyle(fontSize: 20),
            ),
            const Text(
              'Estudiante de Ingeniería de Sistemas UCB',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.purple),
                  onPressed: () => _launchURL('https://www.instagram.com/campero__jose/'),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.code, color: Colors.black),
                  onPressed: () => _launchURL('https://github.com/CamperoJose'),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.email, color: Colors.blue),
                  onPressed: () => _launchURL('mailto:jose.campero@ucb.edu.bo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
