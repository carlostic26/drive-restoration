import 'package:flutter/material.dart';

class InfoDialogService {
  static void showInfoDialog(
      BuildContext context,
      String title,
      String description,
      String actualScreen,
      int? currentPage,
      PageController? pageController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          children: <Widget>[
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 25),
                  child: Text(textAlign: TextAlign.center, description),
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
                      onPressed: () {
                        if (actualScreen == 'Finish Screen') {
                          if (currentPage! < 2) {
                            pageController!.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }

                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      }),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}