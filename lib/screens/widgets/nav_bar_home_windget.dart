import 'package:flutter/material.dart';
import 'package:recu_drive/domain/entities/content_form_page.dart';

import '../finish_screen_pages.dart';

class NavBarHomeSection extends StatelessWidget {
  late PageController pageController;
  bool finishPage;
  int currentPage;
  List<ContentFormPage> contentPages;
  String prompt;
  bool canNext;

  NavBarHomeSection(
      {super.key,
      required this.finishPage,
      required this.currentPage,
      required this.pageController,
      required this.contentPages,
      required this.canNext,
      required this.prompt});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: const Color.fromARGB(255, 226, 226, 226),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 7.5, 15),
              child: TextButton(
                onPressed: () {
                  _goToPreviousPage();
                },
                style: TextButton.styleFrom(
                  shadowColor: Colors.black,
                  elevation: 5,
                  minimumSize: const Size(0, 50),
                  backgroundColor:
                      const Color(0xFFF5F5F5), // Un blanco ligeramente atenuado
                  foregroundColor: Colors.black87, // Color del texto
                ),
                child: const Text(
                  'VOLVER',
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(7.5, 15, 15, 15),
              child: TextButton(
                onPressed: () {
                  if (finishPage) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => FinishScreenPages(
                                  prompt: prompt,
                                )));
                  } else {
                    if (canNext) {
                      _goToNextPage();
                    }
                  }
                },
                style: TextButton.styleFrom(
                  shadowColor: Colors.black,
                  elevation: 5,
                  minimumSize: const Size(0, 50),
                  backgroundColor: const Color.fromARGB(255, 0, 130, 30),
                  foregroundColor: Colors.white70,
                ),
                child: Text(finishPage ? 'FINALIZAR' : 'SIGUIENTE'),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _goToPreviousPage() {
    if (currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage() {
    if (currentPage < contentPages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
