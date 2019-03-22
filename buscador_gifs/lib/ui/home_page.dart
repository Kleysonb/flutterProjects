import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:share/share.dart';
import 'dart:convert';

import 'package:transparent_image/transparent_image.dart';
import './gif_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset;

  Future<Map> _getSearch() async {
    http.Response response;

    if (_search == null) {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=btYjso2J59vyR49KBVWolgJrEcVJ4vQ3&limit=20&rating=G");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=btYjso2J59vyR49KBVWolgJrEcVJ4vQ3&q=$_search&limit=19&offset=$_offset&rating=G&lang=en");
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    // _getSearch().then((map) {
    //   print(map);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: $body(),
    );
  }

  Widget $body() {
    return Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
                onSubmitted: (texto) {
                  setState(() {
                    _search = texto;
                    _offset = 0;
                  });
                },
                decoration: InputDecoration(
                    labelText: "Pesquise Aqui!",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder()),
                style: TextStyle(color: Colors.white, fontSize: 18.0),
                textAlign: TextAlign.center)),
        Expanded(
          child: FutureBuilder(
            future: _getSearch(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Container(
                    width: 200,
                    height: 200,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5,
                    ),
                  );
                default:
                  if (snapshot.hasError)
                    return Container();
                  else
                    return _$createGifsTable(context, snapshot);
              }
            },
          ),
        )
      ],
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _$createGifsTable(context, snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data["data"].length) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GifPage(snapshot.data["data"][index])));
            },
            onLongPress: (){
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
            },
          );
        } else {
          return GestureDetector(
            child: Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.white, size: 70),
                    Text(
                      "Carregar mais...",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offset += 19;
                  });
                },
              ),
            ),
          );
        }
      },
    );
  }
}
