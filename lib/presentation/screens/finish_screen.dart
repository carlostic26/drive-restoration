import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:recu_drive/config/styles/constants/ads/ads.dart';
import 'package:recu_drive/presentation/screens/guias_screen.dart';
import 'package:recu_drive/presentation/screens/web_view_form_screen.dart';
import 'package:recu_drive/presentation/widgets/drawer_home_widget.dart';
import 'package:recu_drive/presentation/widgets/info_dialog_service.dart';
import 'package:url_launcher/url_launcher.dart';

class FinishScreenPages extends StatefulWidget {
  String prompt;
  FinishScreenPages({super.key, required this.prompt});

  @override
  State<FinishScreenPages> createState() => _FinishScreenPagesState();
}

const int maxAttempts = 5;

class _FinishScreenPagesState extends State<FinishScreenPages> {
  late PageController _pageController;
  int _currentPage = 0;

  //initializing banner ad
  BannerAd? _anchoredAdaptiveAd;

  //initializing intersticial ad
  InterstitialAd? interstitialAd;
  int interstitialAttempts = 0;

  RecudriveAds recuAds = RecudriveAds();
  bool _isAdLoaded = false;
  bool _isLoaded = false;

  static const AdRequest request = AdRequest(
      //keywords: ['',''],
      //contentUrl: '',
      //nonPersonalizedAds: false
      );

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _loadAdaptativeAd();
    _createInterstitialAd();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAdaptativeAd();
    _createInterstitialAd();
  }

  Future<void> _loadAdaptativeAd() async {
    if (_isAdLoaded) {
      return;
    }

    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      //print('Unable to get height of anchored banner.');
      return;
    }

    BannerAd loadedAd = BannerAd(
      adUnitId: recuAds.bannerAd,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          //print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );

    try {
      await loadedAd.load();
    } catch (e) {
      //print('Error loading anchored adaptive banner: $e');
      loadedAd.dispose();
    }
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        // ignore: deprecated_member_use
        adUnitId: recuAds.interstitialAd,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          interstitialAd = ad;
          interstitialAttempts = 0;
        }, onAdFailedToLoad: (error) {
          interstitialAttempts++;
          interstitialAd = null;

          if (interstitialAttempts <= maxAttempts) {
            _createInterstitialAd();
          }
        }));
  }

  void _showInterstitialAd() {
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        //onAdShowedFullScreenContent: (ad) => print('ad showed $ad'),

        //when ad went closes
        onAdDismissedFullScreenContent: (ad) async {
      ad.dispose();
    }, onAdFailedToShowFullScreenContent: (ad, error) {
      ad.dispose();
      //print('failed to show the ad $ad');
    });

    interstitialAd!.show();
    interstitialAd = null;
  }

  @override
  Widget build(BuildContext context) {
    String urlForm =
        'https://support.google.com/drive/answer/1716222?visit_id=638581436457838840-4120509564&rd=1'; //todo: Hacer gifs en cada page o pantalla si es necesario

    String urlImgForm =
        'https://uohqvmtropvunofucpre.supabase.co/storage/v1/object/public/img/img/formulario%20ejemplo%20en%20espanol.PNG';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 226, 226),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 1, 171, 60),
        title: const Text(
          'Finalizar solicitud',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
          controller: _pageController,
          itemCount: 2,
          //physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  //TEXT: Este es el texto de tu solicitud de restauracion de archivos de Google Drive.

                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: Text(
                      'Este es el texto de tu solicitud de restauracion de archivos de Google Drive:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

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
                              //todo: abrir dialogo con el texto de: es posible...

                              InfoDialogService.showInfoDialogImg(
                                  context,
                                  '¿Para qué me sirve?',
                                  '⚠️ Es posible que Google te pida enviar un correo o rellenar un formulario de recuperación, donde se requiere un texto de solicitud, el cual deberás copiar y pegar en el apartado correspondiente.',
                                  urlImgForm);
                            },
                            icon: const Icon(
                              Icons.help_outline,
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
                          '"${widget.prompt}"',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 23),
                        ),
                      ),
                    ]),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black,
                              elevation: 5,
                              minimumSize: const Size(0, 50),
                              backgroundColor:
                                  const Color.fromARGB(255, 123, 123, 123),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              copiarPrompt(context, widget.prompt);
                            },
                            icon:
                                const Icon(Icons.copy_all, color: Colors.white),
                            label: const Text(
                              'Copiar texto',
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black,
                              elevation: 5,
                              minimumSize: const Size(0, 50),
                              backgroundColor:
                                  const Color.fromARGB(255, 1, 171, 60),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              InfoDialogService.showInfoDialog(
                                  context,
                                  'Importante',
                                  'El tiempo de recuperación de tus archivos puede tardar entre 5 horas y 3 dias. Google te enviará un correo informandote la decisión.',
                                  'Finish Screen',
                                  _currentPage,
                                  _pageController);

                              //show interstitial

                              try {
                                final result =
                                    await InternetAddress.lookup('google.com');
                                if (result.isNotEmpty &&
                                    result[0].rawAddress.isNotEmpty) {
                                  _showInterstitialAd();

                                  /*   int randomNumber = Random().nextInt(10) + 1; // Genera un número entre 1 y 10
                                if (randomNumber <= 6) {
                                  print('\n\n\n\nINTERTITIALI ATTEMP\n\n\n\n');
                                  showInterstitialAd();
                                } else {
                                  print('\n\n\n\nREWARDED ATTEMP\n\n\n\n');
                                  showRewardedAd();
                                } */
                                  //Navigator.pop(context);
                                }
                              } on SocketException catch (_) {
                                Fluttertoast.showToast(
                                  msg:
                                      "No estás conectado a internet.\nConéctate a Wi-Fi o datos móviles.",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                );
                              }
                            },
                            icon: const Icon(Icons.arrow_forward_ios,
                                color: Colors.white),
                            label: const Text(
                              'Continuar',
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ],
                  )
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white60, // Color de fondo del container
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                  0.2), // Color de la sombra con opacidad
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(
                                  0, 3), // Desplazamiento de la sombra
                            ),
                          ],
                        ),
                        height: 300,
                        //color: Colors.grey[200], // Color de fondo para el contenedor
                        padding: const EdgeInsets.all(
                            20.0), // Padding interno del contenedor

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Fila con iconos
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.play_arrow,
                                        size: 100,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => WebViewScreen(
                                                      urlForm: urlForm,
                                                    )));
                                      },
                                    ),
                                    const Text(
                                      'Abrir aquí',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.public,
                                        size: 100,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        // Acción cuando se presiona el botón de internet
                                        print('Internet button pressed');

                                        //Launch url
                                        launchURL(urlForm);
                                      },
                                    ),
                                    const Text(
                                      'Abrir en navegador',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Ya envié mi solicitud.\n¿Ahora qué?",
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const GuiasScreen()));
                        },
                    ),
                  )
                ],
              );
            }
          }),
      bottomNavigationBar: _anchoredAdaptiveAd != null
          ? Container(
              color: Colors.transparent,
              width: _anchoredAdaptiveAd?.size.width.toDouble(),
              height: _anchoredAdaptiveAd?.size.height.toDouble(),
              child: AdWidget(ad: _anchoredAdaptiveAd!),
            )
          : const SizedBox(),
      endDrawer: DrawerHomeWidget(
        context: context,
      ),
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
