import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

// stfull já cria tudo isso
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double valorINSS = 0;
  double valorIR = 0;

  TextEditingController salaryController = TextEditingController();
  TextEditingController dependentsController = TextEditingController();
  TextEditingController otherDiscountsController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = "Informe seus dados!";

  void _resetFields() {
    salaryController.text = "";
    dependentsController.text = "";
    otherDiscountsController.text = "";
    setState(() {
      _infoText = "Informe seus dados!";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculateLiquidSalary() {
    setState(() {
      double salary = salaryController.text != "" ? double.parse(salaryController.text) : 0;
      double dependents = dependentsController.text != "" ? double.parse(dependentsController.text) : 0;
      double others = otherDiscountsController.text != "" ? double.parse(otherDiscountsController.text) : 0;
      print(salary);
      print(dependents);
      print(others);

      double inss = _calculateINSS(salary);
      double IR = _calculateIR(salary, dependents, others);
      double liquidSalary = salary - inss - IR - others;
      print(inss);
      print(IR);
      print(liquidSalary);

      _infoText = "Salário Líquido: ${liquidSalary.toStringAsPrecision(7)}\n"
          "Inss: ${inss.toStringAsPrecision(5)}\n"
          "IR: ${IR.toStringAsPrecision(6)}\n"
          "Outros Descontos: ${others.toStringAsPrecision(6)}\n";
    });
  }

//  Até 1.903,98	0%	0,00
//  De 1.903,99 até 2.826,65	7,5%	142,80
//  De 2.826,66 até 3.751,05	15%	354,80
//  De 3.751,06 até 4.664,68	22,5%	636,13
//  Acima de 4.664,69	27,5%	869,36

  double _calculateIR(double bruteSalary, dependents, others) {

    double faixa1IR = 1903.98;
    double faixa2IR = 2826.65;
    double faixa3IR = 3751.05;
    double faixa4IR = 4664.68;

    double aliquotaIR1 = 0.075;
    double aliquotaIR2 = 0.15;
    double aliquotaIR3 = 0.225;
    double aliquotaIR4 = 0.275;

    double dedutivelIR1 = 142.80;
    double dedutivelIR2 = 354.80;
    double dedutivelIR3 = 636.13;
    double dedutivelIR4 = 869.36;

    double bcIR = bruteSalary -valorINSS - (189.59*dependents) - others;

    if (bcIR <= faixa1IR) {
      valorIR = 0;
      return valorIR;
    }
    else if (bcIR <= faixa2IR) {
      valorIR = (bcIR * aliquotaIR1) - dedutivelIR1;
      return valorIR;
    }
    else if (bcIR <= faixa3IR) {
      valorIR = (bcIR * aliquotaIR2) - dedutivelIR2;
      return valorIR;
    }
    else if (bcIR <= faixa4IR) {
      valorIR = (bcIR * aliquotaIR3) - dedutivelIR3;
      return valorIR;
    }
    else {
      valorIR = (bcIR * aliquotaIR4) - dedutivelIR4;
      return valorIR;
    }
  }
  //    Salário mínimo: R$ 1.045,00	7,5%
//    De R$ 1.045,01 a R$ 2.089,60	9%
//    De R$ 2.089,61 a R$ 3.134,40	12%
//    De R$ 3.134,41 a R$ 6.101,06	14%
  double _calculateINSS(double salary) {
    double aliquotaINSS1 = 0.075;
    double aliquotaINSS2 = 0.09;
    double aliquotaINSS3 = 0.12;
    double aliquotaINSS4 = 0.14;

    double faixa1INSS = 1045.00;
    double faixa2INSS = 2089.60;
    double faixa3INSS = 3134.40;
    double faixa4INSS = 6101.06;

    double acumuladoINSS1 = 78.38;
    double acumuladoINSS2 = 94.01;
    double acumuladoINSS3 = 125.38;
    double acumuladoINSS4 = 261.18;

    if (salary < faixa1INSS) {
      return salary * aliquotaINSS1;
    }
    else if (salary < faixa2INSS) {
      valorINSS = ((salary - faixa1INSS) * aliquotaINSS2) + acumuladoINSS1;
      return valorINSS;

    }
    else if (salary < faixa3INSS) {
      valorINSS = ((salary - faixa2INSS) * aliquotaINSS3) + acumuladoINSS1 + acumuladoINSS2;
      return valorINSS;
    }
    else if (salary < faixa4INSS) {
      valorINSS = ((salary - faixa3INSS) * aliquotaINSS4) + acumuladoINSS1 + acumuladoINSS2 + acumuladoINSS3;
      return valorINSS;
    }
    else {
      valorINSS = 713.10;
      return valorINSS;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calculadora Salário Líquido 2020"),
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _resetFields();
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.monetization_on,
                  size: 120.0,
                  color: Colors.lightBlue,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Salário Bruto",
                    labelStyle: TextStyle(color: Colors.lightBlue),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.lightBlue, fontSize: 20.0),
                  controller: salaryController,
                  // ignore: missing_return
                  validator: (value) {
                    if(value.isEmpty){
                      return "Insira o valor do salário";
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Número de Dependentes",
                    labelStyle: TextStyle(color: Colors.lightBlue),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.lightBlue, fontSize: 20.0),
                  controller: dependentsController,
                    // ignore: missing_return
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Outros descontos (VA, VR, VT, Plano de saúde, Pensão)\n",
                    labelStyle: TextStyle(color: Colors.lightBlue),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.lightBlue, fontSize: 20.0),
                  controller: otherDiscountsController,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                  child: Container(
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: () {
                        if(_formKey.currentState.validate()) {
                          _calculateLiquidSalary();
                        }
                      },
                      child: (Text(
                        "Calcular",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      )),
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                Text(_infoText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.lightBlue, fontSize: 25.0)),
              ],
            )
          ),
        ));
  }
}
