import 'package:flutter/material.dart';

class FinishScreen extends StatelessWidget {
  String prompt;
  FinishScreen({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
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
              'Copialo y pegalo en el apartado de "Información adicional útil"',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          //Spacer(),

          const SizedBox(
            height: 50,
          ),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(children: [
              Container(
                color: Colors.grey,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      // TODO: hacer que el copy funcione
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
          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextButton(
                    style: TextButton.styleFrom(
                      shadowColor: Colors.black,
                      elevation: 5,
                      minimumSize: const Size(0, 50),
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.black87, // Color del texto
                    ),
                    onPressed: () {
                      // TODO: hacer que el copy funcione
                    },
                    child: const Text(
                      'Copiar promt',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              const SizedBox(
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextButton(
                    style: TextButton.styleFrom(
                      shadowColor: Colors.black,
                      elevation: 5,
                      minimumSize: const Size(0, 50),
                      backgroundColor: const Color.fromARGB(255, 1, 171, 60),
                      foregroundColor: Colors.black87, // Color del texto
                    ),
                    onPressed: () {
                      //Abrir pantalla de dentro o fiuera de la app, no se debe ir si no esta copiado el promyt
                    },
                    child: const Text(
                      'Ir al formulario',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: const SizedBox(height: 80, child: Placeholder()),
    );
  }
}