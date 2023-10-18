import 'package:calc_imc_sqlite/model/pessoa.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../repositorie/pessoa_repositorie.dart';
import '../functions/calc_imc.dart' as calc;

class CalcImcPage extends StatefulWidget {
  const CalcImcPage({super.key});

  @override
  State<CalcImcPage> createState() => _CalcImcPageState();
}

class _CalcImcPageState extends State<CalcImcPage> {
  var imcRepositorie = ResultadosImcRepositorie();
  var _pessoasImc = const <PessoaImc>[];
  var pesoCtrl = TextEditingController();
  var alturaCtrl = TextEditingController();
  var imcNovo = 0.0;
  var classificacaoNova = '';
  var dataAtual = '';
  late Box boxAltura;

  @override
  void initState() {
    super.initState();
    obterClassificacaoImc();
    carregarDados();
  }

  void carregarDados() async {
    if (Hive.isBoxOpen('box_altura')) {
      boxAltura = Hive.box('box_altura');
    } else {
      boxAltura = await Hive.openBox('box_altura');
    }
    alturaCtrl.text = boxAltura.get('alturaCtrl') ?? '0';
    setState(() {});
  }

  void obterClassificacaoImc() async {
    _pessoasImc = await imcRepositorie.obterDados();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Calculadora de IMC"),
        ),
        backgroundColor: const Color.fromARGB(76, 20, 179, 228),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(child: Container()),
                    Expanded(
                      flex: 1,
                      child: Image.asset("lib/images/imc2.png"),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  height: 30,
                  alignment: Alignment.center,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: alturaCtrl,
                    onChanged: (value) {
                      debugPrint(value);
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 0),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 141, 79, 151))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 141, 79, 151))),
                        hintText: "Altura",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 141, 79, 151),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  height: 30,
                  alignment: Alignment.center,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: pesoCtrl,
                    onChanged: (value) {
                      debugPrint(value);
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(top: 0),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 141, 79, 151))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 141, 79, 151))),
                      hintText: "Peso",
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Color.fromARGB(255, 141, 79, 151),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () async {
                          if (pesoCtrl.text.trim() == "" ||
                              alturaCtrl.text.trim() == "") {
                            debugPrint("Peso e altura são obrigatórios");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Valores para peso e/ou altura incorretos",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                            setState(() {});
                          } else {
                            imcNovo = calc.imc(double.parse(alturaCtrl.text),
                                double.parse(pesoCtrl.text));
                            classificacaoNova = calc.classificacao(imcNovo);
                            dataAtual = DateTime.now().toString();

                            await imcRepositorie.salvar(PessoaImc(
                                0,
                                double.parse(alturaCtrl.text),
                                double.parse(pesoCtrl.text),
                                imcNovo,
                                classificacaoNova,
                                dataAtual));
                            boxAltura.put('alturaCtrl', alturaCtrl.text);
                            obterClassificacaoImc();
                            setState(() {});
                          }
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 141, 79, 151))),
                        child: const Text(
                          "Calcular IMC",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        )),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: _pessoasImc.length,
                        itemBuilder: (BuildContext bc, int index) {
                          var pessoaImc = _pessoasImc[index];
                          return Dismissible(
                              onDismissed:
                                  (DismissDirection dismissDirection) async {
                                await imcRepositorie.remover(pessoaImc.id);
                                obterClassificacaoImc();
                              },
                              key: Key(pessoaImc.id.toString()),
                              child: ListTile(
                                title: Text(
                                  pessoaImc.classificacao,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  'Imc: ${pessoaImc.imc.toStringAsFixed(2)}\nAltura: ${pessoaImc.altura}cm\nPeso: ${pessoaImc.peso}kg\nData: ${pessoaImc.data}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ));
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
