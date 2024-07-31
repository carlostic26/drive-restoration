import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class FinishScreen extends StatelessWidget {
  String prompt;
  FinishScreen({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
    String urlForm =
        'https://support.google.com/drive/answer/1716222?hl=en&co=GENIE.Platform%3DDesktop&sjid=10827554286653290509-NA'; //todo: Hacer gifs en cada page o pantalla si es necesario

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 226, 226),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 171, 60),
        title: const Text(
          'Finalizar solicitud',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          //TEXT: Este es el texto de tu solicitud de restauracion de archivos de Google Drive.

          const Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Text(
              'Este es el texto de tu solicitud de restauracion de archivos de Google Drive:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(10, 1, 5, 5),
            child: Text(
              '⚠️ Copialo y pegalo en el apartado de "Información adicional útil"',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          //Spacer(),

          const SizedBox(
            height: 30,
          ),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(children: [
              Container(
                color: const Color.fromARGB(255, 123, 123, 123),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      copiarPrompt(context, prompt);
                    },
                    icon: const Icon(
                      Icons.content_copy,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                color: Colors.black87,
                child: Text(
                  '"$prompt"',
                  style: const TextStyle(color: Colors.white, fontSize: 23),
                ),
              ),
            ]),
          ),

          //TEXT PROMT - con iconButton de copiar

          //BOTTON: PROCEDER
          //const Spacer(),

          SizedBox(
            height: 15,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child:


                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.black,
                      elevation: 5,
                      minimumSize: const Size(0, 50),
                      backgroundColor: Color.fromARGB(255, 123, 123, 123),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      copiarPrompt(context, prompt);
                    },
                    icon: const Icon(Icons.copy_all, color: Colors.white),
                    label: const Text(
                      'Copiar texto',
                      style: TextStyle(color: Colors.white),
                    ),
                  )

              ),
              const SizedBox(
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child:ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.black,
                    elevation: 5,
                    minimumSize: const Size(0, 50),
                    backgroundColor: const Color.fromARGB(255, 1, 171, 60),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    launchURL(urlForm);
                  },
                  icon: const Icon(Icons.language, color: Colors.white),
                  label: const Text(
                    'Ir al formulario',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: const SizedBox(height: 80, child: Placeholder()),
    );
  }

  void copiarPrompt(BuildContext context, String prompt) {
    FlutterClipboard.copy(prompt).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copiado al portapapeles'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  Future<void> launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('No se pudo abrir $url');
    }
  }


}
