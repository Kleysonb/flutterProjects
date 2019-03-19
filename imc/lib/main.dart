import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  String info = "Informe os Dados";

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _resetFilds() {
    setState(() {
      weightController.text = "";
      heightController.text = "";
      this.info = "Informe os Dados!";
    });
  }

  void _calcular() {
    double weight = double.parse(weightController.text);
    double heigth = double.parse(heightController.text) / 100;
    double imc = weight / (heigth * heigth);

    setState(() {
      if (imc < 18.6) {
        info = "Abaixo do Peso (${imc.toStringAsPrecision(2)})";
      } else {
        info = "Não sei mais... (${imc.toStringAsPrecision(2)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("Calculadora de IMC", style: TextStyle(color: Colors.teal)),
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.teal),
              onPressed: () {
                _resetFilds();
              },
            )
          ],
        ),
        backgroundColor: Colors.teal,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Center(
            child: Card(
                child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.person_outline, size: 120, color: Colors.teal),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Peso (kg)",
                          labelStyle: TextStyle(color: Colors.teal)),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.teal, fontSize: 25.0),
                      controller: weightController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Insira seu Peso";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Altura (cm)",
                          labelStyle: TextStyle(color: Colors.teal)),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.teal, fontSize: 25.0),
                      controller: heightController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Insira sua Altura";
                        }
                      },
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Container(
                        height: 50,
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _calcular();
                            }
                          },
                          child: Text(
                            "Calcular",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                          color: Colors.teal,
                        ),
                      )),
                  Container(
                      padding: EdgeInsets.only(top: 30, bottom: 30),
                      child: Text(
                        info,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.teal, fontSize: 25),
                      ))
                ],
              ),
            )),
          ),
        ));
  }
}
