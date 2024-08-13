import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:recu_drive/config/styles/constants/ads/ads.dart';
import 'package:recu_drive/infrastructure/sqlite_db.dart';
import 'package:recu_drive/presentation/screens/loading_screen.dart';

AppOpenAd? openAd;
bool isAdLoaded = false;

Future<void> loadOpenAd() async {
  RecudriveAds recudriveAds = RecudriveAds();
  try {
    await AppOpenAd.load(
      adUnitId: recudriveAds.openAd,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          openAd = ad;
          openAd!.show();
          isAdLoaded = true;
        },
        onAdFailedToLoad: (error) {
          isAdLoaded = false;
        },
      ),
    );
  } catch (e) {
    print('Error loading open ad: $e');
    isAdLoaded = false;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await loadOpenAd();

  await LocalDatabase().initializeDB();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecuDrive',
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
