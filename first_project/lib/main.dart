import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(title: "Contador de Pessoas", home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _people = 0;
  String _infoText = "Pode Entrar!";

  void _chagePeople(increment) {
    setState(() {
      this._people += increment;

      if(this._people < 0){
        this._infoText = "Mundo invertido?!";
      }else{
        if(this._people > 10){
          this._infoText = "LOTADO!";
        }else{
          this._infoText = "Pode Entrar!";
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/wallpaper3.jpg",
          fit: BoxFit.cover,
          // height: 1000,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Pessoas $_people",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(15.0),
                    child: FlatButton(
                      child: Text('+1',
                          style: TextStyle(color: Colors.white, fontSize: 40)),
                      onPressed: () {
                        _chagePeople(1);
                      },
                    )),
                Padding(
                    padding: EdgeInsets.all(15.0),
                    child: FlatButton(
                      child: Text('-1',
                          style: TextStyle(color: Colors.white, fontSize: 40)),
                      onPressed: () {
                        _chagePeople(-1);
                      },
                    )),
              ],
            ),
            Text(
              this._infoText,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontStyle: FontStyle.italic),
            )
          ],
        ),
      ],
    );
  }
}
