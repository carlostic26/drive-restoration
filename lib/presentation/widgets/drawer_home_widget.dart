import 'package:flutter/material.dart';
import 'package:recu_drive/config/styles/constants/enviroment.dart';
import 'package:recu_drive/presentation/screens/guias_screen.dart';
import 'package:recu_drive/presentation/widgets/info_dialog_service.dart';

class DrawerHomeWidget extends StatelessWidget {
  BuildContext? context;
  DrawerHomeWidget({super.key, required context});
  String flutterVersion = '3.22.1';

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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 80,
                  width: 80,
                ),
                const SizedBox(height: 2),
                const Text(
                  'RecuDrive',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '1.0.1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.tips_and_updates),
            title: const Text('Guías'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const GuiasScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Política de Privacidad'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Info de la App'),
            onTap: () {
              dialogVersion(context, 'Información',
                  'RecuDrive es una app desarrollada por TICnoticos para ayudar a los usuarios a recuperar sus archivos eliminados por error de la papelera de Google Drive.\n\nLa app es una guia donde se explica paso a paso que hacer para restablecer los archivos.\n\nVersión: $flutterVersion');
            },
          ),
        ],
      ),
    );
  }

  Future<dynamic> dialogVersion(BuildContext context, title, description) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          children: <Widget>[
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 25),
                  child: Text(textAlign: TextAlign.center, description),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.green),
                      ),
                      child: const Text(
                        'Ok',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
