import 'package:flutter/material.dart';
import 'package:recu_drive/screens/home_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //LOGO
              SizedBox(
                  height: 150, width: 150, child: Image.asset('assets/icon.png')
                  //Placeholder()
                  ),

              //LINEAR PROGRESS BAR
              const Padding(
                padding: EdgeInsets.fromLTRB(70, 5, 70, 5),
                child: LinearProgressIndicator(
                  color: Colors.blue,
                  minHeight: 5.0,
                ),
              ),

              //TEXT
              const Text('Cargando app...'),

              const SizedBox(
                height: 100,
              ),

              //BTN CONTINUE
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  child: const Text(
                    'Continuar',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
