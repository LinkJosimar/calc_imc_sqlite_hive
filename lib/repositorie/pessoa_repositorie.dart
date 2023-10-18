import 'package:calc_imc_sqlite/repositorie/sqlitedatabase.dart';
import '../model/pessoa.dart';

class ResultadosImcRepositorie {
  Future<List<PessoaImc>> obterDados() async {
    List<PessoaImc> pessoaImc = [];
    var db = await SQLiteDataBase().obterDataBase();
    var result = await db
        .rawQuery('SELECT id,altura,peso,imc,classificacao,data FROM IMC');
    for (var element in result) {
      pessoaImc.add(PessoaImc(
        int.parse(element["id"].toString()),
        double.parse(element["altura"].toString()),
        double.parse(element["peso"].toString()),
        double.parse(element["imc"].toString()),
        element["classificacao"].toString(),
        element["data"].toString(),
      ));
    }
    return pessoaImc;
  }

  Future<void> salvar(PessoaImc pessoaImc) async {
    var db = await SQLiteDataBase().obterDataBase();
    await db.rawInsert(
        'INSERT INTO IMC (altura,peso,imc,classificacao,data) values(?,?,?,?,?)',
        [
          pessoaImc.altura,
          pessoaImc.peso,
          pessoaImc.imc,
          pessoaImc.classificacao,
          pessoaImc.data
        ]);
  }

  Future<void> remover(int id) async {
    var db = await SQLiteDataBase().obterDataBase();
    await db.rawInsert('DELETE FROM IMC WHERE id = ?', [id]);
  }
}
