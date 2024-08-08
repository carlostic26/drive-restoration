import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:recu_drive/presentation/screens/home_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool buttonEnabled = false;

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
              Padding(
                padding: EdgeInsets.fromLTRB(70, 5, 70, 5),
                child: LinearPercentIndicator(
                    //width: width * 0.55,
                    lineHeight: 5,
                    percent: 100 / 100,
                    animation: true,
                    animationDuration: 1000, // 8.5 sec para cargar la barra
                    progressColor: Colors.blue,
                    onAnimationEnd: () {
                      setState(() {
                        buttonEnabled = true;
                      });
                    }),

                /* LinearProgressIndicator(
                 
                  color: Colors.blue,
                  minHeight: 5.0,
                ), */
              ),

              //TEXT
              const Text('Cargando app...'),

              const SizedBox(
                height: 100,
              ),

              //BTN CONTINUE
              ElevatedButton(
                  style: buttonEnabled
                      ? ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        )
                      : ElevatedButton.styleFrom(
                          disabledBackgroundColor: Colors.grey[300],
                          disabledForegroundColor: Colors.grey[600],
                        ),
                  onPressed: () {
                    if (buttonEnabled) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    }
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
