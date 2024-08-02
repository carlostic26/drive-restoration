import 'package:flutter/material.dart';

class DrawerHomeWidget extends StatelessWidget {
  BuildContext? context;
  DrawerHomeWidget({super.key, required context});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 1, 171, 60),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/app_icon.png', // Asegúrate de tener esta imagen en tu proyecto
                  height: 60,
                  width: 60,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Nombre de la App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Información de la App'),
            onTap: () {
              // Implementar navegación
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Política de Privacidad'),
            onTap: () {
              // Implementar navegación
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Ayuda'),
            onTap: () {
              // Implementar navegación
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Versión'),
            onTap: () {
              // Implementar navegación
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
