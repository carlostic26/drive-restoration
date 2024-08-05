import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:recu_drive/screens/web_view_form_screen.dart';
import 'package:recu_drive/screens/widgets/drawer_home_widget.dart';
import 'package:recu_drive/screens/widgets/info_dialog_service.dart';
import 'package:url_launcher/url_launcher.dart';

class FinishScreenPages extends StatefulWidget {
  String prompt;
  FinishScreenPages({super.key, required this.prompt});

  @override
  State<FinishScreenPages> createState() => _FinishScreenPagesState();
}

class _FinishScreenPagesState extends State<FinishScreenPages> {
  late PageController _pageController;
  int _currentPage = 0;

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

  @override
  Widget build(BuildContext context) {
    String urlForm =
        'https://support.google.com/drive/answer/1716222?visit_id=638581436457838840-4120509564&rd=1'; //todo: Hacer gifs en cada page o pantalla si es necesario

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

                              InfoDialogService.showInfoDialog(
                                  context,
                                  '¿Para qué me sirve?',
                                  '⚠️ Es posible que el formulario de recuperación de Google te requiera un texto de solicitud. Copialo y pegalo en el apartado de "Información adicional útil"',
                                  'Finish Screen Prompt',
                                  0,
                                  PageController());
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
                            onPressed: () {
                              InfoDialogService.showInfoDialog(
                                  context,
                                  'Importante',
                                  'El tiempo de recuperación de tus archivos puede tardar entre 5 horas y 3 dias. Google te enviará un correo informandote la decisión.',
                                  'Finish Screen',
                                  _currentPage,
                                  _pageController);
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
              return Center(
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
                          offset:
                              const Offset(0, 3), // Desplazamiento de la sombra
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
                            const SizedBox(width: 20),
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
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Fila con textos
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Abrir aquí',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            SizedBox(width: 20),
                            Text(
                              'Abrir en navegador',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
      bottomNavigationBar: const SizedBox(height: 80, child: Placeholder()),
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
