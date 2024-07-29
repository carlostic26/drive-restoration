import 'package:flutter/material.dart';

class FinishScreen extends StatelessWidget {
  const FinishScreen({super.key});

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

          //TEXT PROMT - con iconButton de copiar

          //BOTTON: PROCEDER
        ],
      ),
    );
  }
}
