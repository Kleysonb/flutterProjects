import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
// import 'package:async/async.dart';
import 'dart:convert';

const request =
    "http://www.apilayer.net/api/live?access_key=a4321582a7275c2a488dd9408a0589c7&format=1";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double real;
  double euro;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text) {
    if (text.isEmpty) {
      dolarController.text = "";
      euroController.text = "";
    } else {
      double realInput = double.parse(text);
      dolarController.text = (realInput / real).toStringAsFixed(2);
      euroController.text = ((realInput / real) * euro).toStringAsFixed(2);
    }
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      realController.text = "";
      euroController.text = "";
    } else {
      double dolar = double.parse(text);
      realController.text = (dolar * real).toStringAsFixed(2);
      euroController.text = (dolar * euro).toStringAsFixed(2);
    }
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      dolarController.text = "";
      realController.text = "";
    } else {
      double euroInput = double.parse(text);
      dolarController.text = (euroInput / euro).toStringAsFixed(2);
      realController.text = ((euroInput / euro) * real).toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: Scaffold(
          // Barra
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text("\$ Conversor \$",
                style: TextStyle(color: Colors.black, fontSize: 25)),
            backgroundColor: Colors.amber,
            centerTitle: true,
          ),
          body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    'Carregando Dados...',
                    style: TextStyle(color: Colors.amber, fontSize: 25),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'Erro ao Carregar Dados :(',
                      style: TextStyle(color: Colors.amber, fontSize: 25),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    real = snapshot.data["quotes"]["USDBRL"];
                    euro = snapshot.data["quotes"]["USDEUR"];
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 25, bottom: 25),
                            child: Icon(
                              Icons.monetization_on,
                              size: 100,
                              color: Colors.amber,
                            ),
                          ),
                          buildTextFild(
                              "Real", "R\$ ", realController, _realChanged),
                          Divider(),
                          buildTextFild(
                              "Dólar", "US\$ ", dolarController, _dolarChanged),
                          Divider(),
                          buildTextFild(
                              "Euro", "€ ", euroController, _euroChanged)
                        ],
                      ),
                    );
                  }
              }
            },
          ),
        ));
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

Widget buildTextFild(String label, String prefix,
    TextEditingController textController, Function acao) {
  return TextField(
    controller: textController,
    decoration: InputDecoration(
      labelStyle: TextStyle(color: Colors.amber),
      labelText: label,
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25),
    onChanged: acao,
    keyboardType: TextInputType.number,
  );
}
