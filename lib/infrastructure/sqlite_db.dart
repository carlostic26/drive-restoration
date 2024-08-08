import 'package:recu_drive/domain/entities/guia_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'guias_001.db'),
      onCreate: (database, version) async {
        const String sql =
            'CREATE TABLE guia (id INTEGER PRIMARY KEY AUTOINCREMENT, title_step TEXT, url_img TEXT, description TEXT);';

        await database.execute(sql);

        const String addGuias = ''
            'INSERT INTO guia(title_step, url_img, description) VALUES '
            //
            '("Ingrese a su cuenta de Google", "", "El primer paso es ingresar a su cuenta de Google, ya que desde ahi se deberá realzar el proceso de recuperacion de archivos."),'
            //
            '("Tipo de cuenta", "", "Asegurese de saber que tipo de cuenta maneja. Esto es necesario ya que Google solo permite la recuperación de archivos en cuentas personales."),'
            //
            '("Ingresar a la solicitud", "", "Tenga en cuenta que pueden existir dos tipos de solicitud de recuperación de archivos que usted puede realizar con Google. El primero es mediante un formulario de recuperación, y el segundo es mediante el envío de un correo eléctronico."),'
            //
            '("Idioma y ubicación", "", "Dependiendo del idioma y la ubicación, se mostrará el acceso a cualquiera de las dos posibilidades de solicitud. Esto significa que el acceso a dicha solicitud puede no aparecer segun su idioma o pais. Si ese es su caso, deberá bajar al final de la página y camibar el idioma a “english”."),'
            //
            '("Tiempo de eliminación", "", "Tenga en cuenta que el tiempo de eliminación o borrado de sus archivos es crucial para garantizar su recuperación. Esto es asi porque Google informa que después de los 25 dias no será posible traer de vuelta los archivos."),'
            //
            '("Numero del caso", "", "Una vez radique el texto de solicitud (mediante formulario o correo) Google le asignará un numero de caso (CASE ID). Con este, podrá hacer seguimiento de la respuesta que le darán por correo."),'
            //
            '("Paciencia", "", "Es necesario ser paciente y esperar el tiempo necesario para obtener la respuesta satisfactoria de Google. Estos tiempos van de 3 horas a 3 dias. Debes revisar tu bandeja de correo, o volver a la app varias veces al dia.")';

        await database.execute(addGuias);

        //deleteOldDatabases();
      },
      version: 1,
    );
  }

  Future<List<GuiaEntity>> getGuias() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult =
        await db.rawQuery('SELECT * FROM guia');
    Map<String, dynamic> result = {};
    for (var r in queryResult) {
      result.addAll(r);
    }
    return queryResult.map((e) => GuiaEntity.fromMap(e)).toList();
  }
}
