import 'package:flutter/material.dart';
import 'package:recu_drive/infrastructure/sqlite_db.dart';
import 'package:recu_drive/presentation/screens/loading_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //init db sqlite
  await LocalDatabase().initializeDB();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recu Drive',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 0, 226, 83)),
        useMaterial3: true,
      ),
      home: const LoadingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
