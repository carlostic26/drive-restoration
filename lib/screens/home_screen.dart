import 'package:flutter/material.dart';
import 'package:recu_drive/domain/entities/answer_page.dart';
import 'package:recu_drive/domain/entities/content_page.dart';
import 'package:recu_drive/screens/finish_screen.dart';
import 'package:recu_drive/screens/widgets/nav_bar_home_section.dart';
import 'package:recu_drive/screens/widgets/option_tile_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  bool finishPage = false;

  String prompt = '';

  AnswerPage answerPage = AnswerPage('', '');

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

  List<ContentPage> contentPages = [
    ContentPage('Elije tu tipo de cuenta de Google Drive', [
      ['👤    Personal', false],
      ['🏫    Intitucional', false],
      ['❓    No lo sé', false]
    ]),
    ContentPage('Elige el tipo de archivo eliminado', [
      ['⏯️    Video (mp4, mkv, 3gp, mov, h264, h265, otro...)', false],
      ['🖼️    Imagen (png, jpg, jpeg, gif, webp, webm, otro...)', false],
      ['🎵    Audio (mp3, m4a, flac, wav, ogg, aac, otro...)', false],
      ['📄    Documentos (pdf, doc, pptx, txt, xlsx, otro... )', false],
      ['📚    Comprimido (zip, rar, tar, 7z)', false],
      ['🧩    Otro (psd, veg, prpro, html, otro...)', false],
      ['❓    No lo sé', false],
    ]),
    ContentPage('Elige tu región habitual', [
      ['🌎    Norteamérica', false],
      ['🌎    Centroamérica', false],
      ['🌎    Sudamérica', false],
      ['🌍    Europa', false],
      ['🌏    Asia', false],
      ['🌍    Africa', false],
      ['🧩    Otro', false],
    ]),
    ContentPage('Elige el idioma que usas en Google Drive', [
      //Las solicitudes de recuperacion de archivos se hace unicamente en inglés.
      ['🇪🇸     Español', false],
      ['🇬🇧     Inglés', false],
      ['🧩    Otro', false],
    ]),
    ContentPage('Elige el tiempo de borrado', [
      //¿Hace cuanto tiempo borraste los archivos? || Dialog si marca mas de 25: Advertencia: Es probable que Google no pueda recuperar la información debido al largo tiempo de borrado de los archivos. Pero puedes intentar continuar con el proceso de recuperación de todos modos.

      ['📆   Hace menos de 25 dias', false],
      ['📅   Hace más de 25', false],
    ]),

    //AVISO: El tiempo de recuperación de tus archivos puede tardar entre 5 horas y 3 dias. Google te enviará un correo informandote la decisión.
    //ato curioso: El 99% de los usuarios ha logrado recuperar exitosamente sus archivos eliminados de Google Drive siempre y cuando lo soliciten en un plazo menor a 25 días desde su eliminación.
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
                      contentPages.length,
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
              itemCount: contentPages.length,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                final contentPage = contentPages[index];
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      //TODO: Progres section

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
                          text: option[0],
                          isSelected: option[1],
                          onSelected: (value) {
                            setState(() {
                              // Desmarca todos los demás RadioButton
                              for (var otherOption in contentPage.optionTile) {
                                otherOption[1] = false;
                              }

                              option[1] = value;

                              if (_currentPage == 0 &&
                                  option[0] == '❓    No lo sé') {
                                _helpDialogTypeAccount(context);
                                option[1] = false;
                              }

                              //guarda la info sobre tipo de archivo
                              if (_currentPage == 1) {
                                fileType = option[0];
                                print(
                                    'actualPage: $_currentPage FileType Selected: $fileType');

                                //guarda la info de tiempo de borrado y habilita el boton de finalizar
                              } else if (_currentPage == 4) {
                                timeDeleted = option[0];
                                print(
                                    'actualPage: $_currentPage TimeDeleted Selected: $timeDeleted');

                                finishPage = true;
                              }

                              if (_currentPage != 4) {
                                finishPage = false;
                              }

                              /*  print('FileType Selected: $fileType');
                              print('TimeDeleted Selected: $timeDeleted'); */

                              answerPage = AnswerPage(fileType, timeDeleted);

                              prompt =
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
        finishPage: finishPage,
        currentPage: _currentPage,
        pageController: _pageController,
        contentPages: contentPages,
        promt: prompt,
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
}
