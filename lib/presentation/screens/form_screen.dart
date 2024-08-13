import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:recu_drive/config/styles/constants/ads/ads.dart';
import 'package:recu_drive/domain/entities/answer_page.dart';
import 'package:recu_drive/domain/entities/content_form_page.dart';
import 'package:recu_drive/presentation/widgets/drawer_home_widget.dart';
import 'package:recu_drive/presentation/widgets/info_dialog_service.dart';
import 'package:recu_drive/presentation/widgets/nav_bar_home_widget.dart';
import 'package:recu_drive/presentation/widgets/option_tile_widget.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _finishPage = false;

  bool _canNext = false;
  String _prompt = '';

  //initializing banner ad
  BannerAd? _anchoredAdaptiveAd;

  RecudriveAds recuAds = RecudriveAds();
  bool _isAdLoaded = false;
  bool _isLoaded = false;

  static const AdRequest request = AdRequest(
      //keywords: ['',''],
      //contentUrl: '',
      //nonPersonalizedAds: false
      );

  AnswerPage _answerPage = AnswerPage('', '');

  String fileType = '';
  String timeDeleted = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _loadAdaptativeAd();
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

  final List<ContentFormPage> _contentFormPages = [
    ContentFormPage('', 'Elije tu tipo de cuenta de Google Drive', [
      ['👤', 'Personal', false],
      ['🏫', 'Intitucional', false],
      ['❓', 'No lo sé', false]
    ]),
    ContentFormPage('', 'Elige el tipo de archivo eliminado', [
      ['⏯️', 'Video (mp4, mkv, 3gp, mov, h264, h265, otro...)', false],
      ['🖼️', 'Imagen (png, jpg, jpeg, gif, webp, webm, otro...)', false],
      ['🎵', 'Audio (mp3, m4a, flac, wav, ogg, aac, otro...)', false],
      ['📄', 'Documentos (pdf, doc, pptx, txt, xlsx, otro... )', false],
      ['📚', 'Comprimido (zip, rar, tar, 7z)', false],
      ['🧩', 'Otro (psd, veg, prpro, html, otro...)', false],
      ['❓ ', 'Varios', false],
    ]),
    ContentFormPage('', 'Elige tu región habitual', [
      ['🌎', 'Norteamérica', false],
      ['🌎', 'Centroamérica', false],
      ['🌎', 'Sudamérica', false],
      ['🌍', 'Europa', false],
      ['🌏', 'Asia', false],
      ['🌍', 'Africa', false],
      ['🧩', 'Otro', false],
    ]),
    ContentFormPage('', 'Elige el idioma que usas en Google Drive', [
      //Las solicitudes de recuperacion de archivos se hace unicamente en inglés.
      ['🇪🇸', 'Español', false],
      ['🇬🇧', 'Inglés', false],
      ['🧩', 'Otro', false],
    ]),
    ContentFormPage('', 'Elige el tiempo de borrado', [
      //¿Hace cuanto tiempo borraste los archivos? || Dialog si marca mas de 25: Advertencia: Es probable que Google no pueda recuperar la información debido al largo tiempo de borrado de los archivos. Pero puedes intentar continuar con el proceso de recuperación de todos modos.

      ['📆', 'Hace menos de 25 días', false],
      ['📅', 'Hace más de 25 días', false],
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 226, 226),
      appBar: AppBar(
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
          'Formulario de recuperación',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 20),
                child: SizedBox(
                  width: 200,
                  height: 5,
                  child: Row(
                    children: List.generate(
                      _contentFormPages.length,
                      (i) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: i <= _currentPage
                                ? Colors
                                    .black54 // Color para páginas completadas
                                : Colors.grey, // Color para páginas pendientes
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _contentFormPages.length,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                final contentPage = _contentFormPages[index];
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 100, 40),
                        child: Text(
                          contentPage.title,
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      for (var option in contentPage.optionTile)
                        OptionTileWidget(
                          icon: option[0],
                          text: option[1],
                          isSelected: option[2],
                          onSelected: (value) {
                            setState(() {
                              // Desmarca todos los demás RadioButton
                              for (var otherOption in contentPage.optionTile) {
                                otherOption[2] = false;
                              }

                              option[2] = value;

                              if (_currentPage == 0 ||
                                  _currentPage == 1 ||
                                  _currentPage == 2 ||
                                  _currentPage == 3 ||
                                  _currentPage == 4) {
                                if (option[2] == true) {
                                  _canNext = true;
                                }
                              }

                              if (_currentPage == 0 &&
                                  option[1] == 'No lo sé') {
                                InfoDialogService.showInfoDialog(
                                    context,
                                    'Conoce tu tipo de cuenta',
                                    'Si tu cuenta no termina en "@gmail.com" entonces es institucional.',
                                    'Home Screen',
                                    0,
                                    PageController());

                                option[2] = false;
                                _canNext = false;
                              }

                              //guarda la info sobre tipo de archivo
                              if (_currentPage == 1) {
                                fileType = option[1];
                                print(
                                    'actualPage: $_currentPage FileType Selected: $fileType');

                                //guarda la info de tiempo de borrado y habilita el boton de finalizar
                              } else if (_currentPage == 4) {
                                timeDeleted = option[1];
                                print(
                                    'actualPage: $_currentPage TimeDeleted Selected: $timeDeleted');

                                _finishPage = true;
                              }
                              if (_currentPage == 3 && option[1] == 'Español' ||
                                  option[1] == 'Otro') {
                                InfoDialogService.showInfoDialog(
                                    context,
                                    'Dato curioso',
                                    'Ten en cuenta que Google responde más rápido a las solicitudes de recuperación en inglés',
                                    'Home Screen',
                                    0,
                                    PageController());
                              }

                              if (_currentPage == 4 &&
                                  option[1] == 'Hace más de 25 días') {
                                InfoDialogService.showInfoDialog(
                                    context,
                                    'Dato curioso',
                                    'La mayoría de los usuarios recuperan sus archivos de Google Drive siempre y cuando los soliciten en un plazo menor a 25 días desde su eliminación.',
                                    'Home Screen',
                                    0,
                                    PageController());
                              }

                              if (_currentPage != 4) {
                                _finishPage = false;
                              }

                              /*  print('FileType Selected: $fileType');
                                print('TimeDeleted Selected: $timeDeleted'); */

                              _answerPage = AnswerPage(fileType, timeDeleted);

                              _prompt =
                                  'Como usuario de Google Drive requiero la restauración de mis archivos tipo $fileType, ' +
                                      'que eliminé por accidente $timeDeleted';

                              //TODO: Al finalizar la ultima pagina, el objeto answerPage se debe enviar al meotodd
                              // que armará el promt y se debe mostrar dicho prompt (String) en pantalla..

                              // La la pantalla final debe titularse: Solicitar recuperación
                              // en el body debe tener un icono de google drive
                              // debajo, el prompt
                              // debajo el boton recuperar mis archivos
                              // al tocarlo se muestra pantalla con 2 op: dentro de la app, fuera de la app
                              // si es dentro de la app, se mostrara webview, sino un launcher
                              // debajo se debe copiar el texto del promt porque el user lo va a usar
                              // fin de la app
                            });
                          },
                        )
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: heightScreen * 0.09,
            child: BottomSection(
              finishPage: _finishPage,
              currentPage: _currentPage,
              pageController: _pageController,
              contentPages: _contentFormPages,
              prompt: _prompt,
              canNext: _canNext,
            ),
          ),
        ],
      ),
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
}
