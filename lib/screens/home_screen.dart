import 'package:flutter/material.dart';
import 'package:recu_drive/domain/entities/answer_page.dart';
import 'package:recu_drive/domain/entities/content_form_page.dart';
import 'package:recu_drive/screens/finish_screen.dart';
import 'package:recu_drive/screens/widgets/nav_bar_home_windget.dart';
import 'package:recu_drive/screens/widgets/option_tile_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _finishPage = false;

  bool _canNext = false;

  String _prompt = '';

  AnswerPage _answerPage = AnswerPage('', '');

  String fileType = '';
  String timeDeleted = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

    //AVISO: El tiempo de recuperación de tus archivos puede tardar entre 5 horas y 3 dias. Google te enviará un correo informandote la decisión.
    //ato curioso:
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 226, 226),
      appBar: AppBar(
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
                                _helpDialogTypeAccount(context);
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
                              if (_currentPage == 3 && option[1] == 'Español') {
                                _infoDialogTypeLanguage(context);
                              }

                              if (_currentPage == 4 &&
                                  option[1] == 'Hace más de 25 días') {
                                _infoDialogMaxDays(context);
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
        ],
      ),
      bottomNavigationBar: NavBarHomeSection(
        finishPage: _finishPage,
        currentPage: _currentPage,
        pageController: _pageController,
        contentPages: _contentFormPages,
        prompt: _prompt,
        canNext: _canNext,
      ),
    );
  }

  void _helpDialogTypeAccount(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: const Center(
                child: Text(
                  "Conoce tu tipo de cuenta",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              children: <Widget>[
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 25),
                      child: Text(
                          textAlign: TextAlign.center,
                          'Si tu cuenta no termina en "@gmail.com" entonces es institucional.'),
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
                            'Entiendo',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          onPressed: () => {
                                Navigator.pop(context),
                              }),
                    ),
                  ],
                ),
              ]);
        });
  }

  void _infoDialogTypeLanguage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: const Center(
                child: Text(
                  "Importante",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              children: <Widget>[
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 25),
                      child: Text(
                          textAlign: TextAlign.center,
                          'Ten en cuenta que la solicitud de recuperación se hace en inglés, sin importar que el idioma de tu cuenta esté en español.'),
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
                            'Entiendo',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          onPressed: () => {
                                Navigator.pop(context),
                              }),
                    ),
                  ],
                ),
              ]);
        });
  }

  void _infoDialogMaxDays(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: const Center(
                child: Text(
                  "Dato curioso",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              children: <Widget>[
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 25),
                      child: Text(
                          textAlign: TextAlign.center,
                          'La mayoría de los usuarios recuperan sus archivos de Google Drive siempre y cuando los soliciten en un plazo menor a 25 días desde su eliminación.'),
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
                            'Entiendo',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          onPressed: () => {
                                Navigator.pop(context),
                              }),
                    ),
                  ],
                ),
              ]);
        });
  }
}
