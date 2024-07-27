import 'package:flutter/material.dart';
import 'package:recu_drive/domain/entities/content_page.dart';
import 'package:recu_drive/screens/widgets/option_tile_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ContentPage> contentPages = [
    ContentPage('Elije tu tipo de cuenta de Google Drive', [
      ['👤  Personal', false],
      ['🏫  Intitucional', false],
      [
        '❓  No lo sé',
        false
      ] //Si tu cuenta no termina en gmail.com entonces es institucional.
    ]),
    ContentPage('Elige el tipo de archivo eliminado', [
      ['⏯️  Video (mp4, mkv, 3gp, mov, h264, h265, otro...)', false],
      ['🖼️  Imagen (png, jpg, jpeg, gif, webp, webm, otro...)', false],
      ['🎵  Audio (mp3, m4a, flac, wav, ogg, aac, otro...)', false],
      ['📄  Documentos (pdf, doc, pptx, txt, xlsx, otro... )', false],
      ['📚  Comprimido (zip, rar, tar, 7z)', false],
      ['🧩  Otro (psd, veg, prpro, html, otro...)', false],
      ['❓   No lo sé', false],
    ]),
    ContentPage('Elige tu región habitual', [
      ['🌎  Norteamérica', false],
      ['🌎  Centroamérica', false],
      ['🌎  Sudamérica', false],
      ['🌍  Europa', false],
      ['🌏  Asia', false],
      ['🌍  Africa', false],
      ['🧩  Otro', false],
    ]),
    ContentPage('Elige el idioma que usas en Google Drive', [
      //Las solicitudes de recuperacion de archivos se hace unicamente en inglés.
      ['🇪🇸 Español', false],
      ['🇬🇧 Inglés', false],
      ['🧩  Otro', false],
    ]),
    ContentPage('Elige el tiempo de borrado', [
      //¿Hace cuanto tiempo borraste los archivos? || Dialog si marca mas de 25: Advertencia: Es probable que Google no pueda recuperar la información debido al largo tiempo de borrado de los archivos. Pero puedes intentar continuar con el proceso de recuperación de todos modos.

      ['📆 Hace menos de 25 dias', false],
      ['📅 Hace más de 25', false],
    ]),

    //AVISO: El tiempo de recuperación de tus archivos puede tardar entre 5 horas y 3 dias. Google te enviará un correo informandote la decisión.
    //ato curioso: El 99% de los usuarios ha logrado recuperar exitosamente sus archivos eliminados de Google Drive siempre y cuando lo soliciten en un plazo menor a 25 días desde su eliminación.
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 226, 226),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Formulario de recuperación',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        itemCount: contentPages.length,
        itemBuilder: (context, index) {
          final contentPage = contentPages[index];
          return Column(
            children: [
              //TODO: Progres section

              const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, top: 10),
                    child:
                        SizedBox(width: 200, height: 20, child: Placeholder()),
                  )),

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
                    // Handle radio button selection
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
