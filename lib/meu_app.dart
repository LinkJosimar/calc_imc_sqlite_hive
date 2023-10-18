import 'package:flutter/material.dart';
import 'pages/calc_imc_page.dart';

class MeuAppImc extends StatelessWidget {
  const MeuAppImc({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const CalcImcPage(),
    );
  }
}
