class PessoaImc {
  int _id = 0;
  double _peso = 0.0;
  double _altura = 0.0;
  double _imc = 0.0;
  String? _classificacao;
  String? _data;

  PessoaImc(this._id, this._altura, this._peso, this._imc, this._classificacao,
      this._data);

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  double get peso => _peso;

  set peso(double peso) {
    _peso = peso;
  }

  double get altura => _altura;

  set altura(double altura) {
    _altura = altura;
  }

  double get imc => _imc;

  set imc(double imc) {
    _imc = imc;
  }

  String get classificacao => _classificacao!;

  set classificacao(String classificacao) {
    _classificacao = classificacao;
  }

  String get data => _data!;

  set data(String data) {
    _data = data;
  }
}
