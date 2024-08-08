import 'package:flutter/material.dart';
import 'package:recu_drive/domain/entities/guia_entity.dart';
import 'package:recu_drive/infrastructure/sqlite_db.dart';

class GuiasScreen extends StatefulWidget {
  const GuiasScreen({super.key});

  @override
  State<GuiasScreen> createState() => _GuiasScreenState();
}

class _GuiasScreenState extends State<GuiasScreen> {
  late LocalDatabase localDb;
  Future<List<GuiaEntity>>? _guia;

  @override
  void initState() {
    super.initState();
    loadGuias();
  }

  loadGuias() {
    localDb = LocalDatabase();
    localDb.initializeDB().whenComplete(() async {
      setState(() {
        _guia = getGuiasDb();
      });
    });
  }

  Future<List<GuiaEntity>> getGuiasDb() async {
    return await localDb.getGuias();
  }

  Future<void> _onRefresh() async {
    setState(() {
      //hacemos un switch para que sepa que cateogira es la que debe refrescar
      _guia = getGuiasDb();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 1, 171, 60),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Guías de recuperación',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        body: FutureBuilder<List<GuiaEntity>>(
          future: _guia,
          builder:
              (BuildContext context, AsyncSnapshot<List<GuiaEntity>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              var items = snapshot.data ?? <GuiaEntity>[];

              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 1.0,
                  vertical: 1.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(children: [
                      //title
                      Text(items[index].titleStep),

                      //url
                      Image.network(
                        items[index].urlImg,
                      ),

                      //desc
                      Text(items[index].description),
                    ]);
                  },
                ),
              );
            }
          },
        ));
  }
}
