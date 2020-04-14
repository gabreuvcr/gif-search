import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search = "";
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;
    if(_search == "") {
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=O3EGPU7udLi7JvhFpARVt0Ymnw0rYFpi&limit=24&rating=G");
    }
    else {
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=O3EGPU7udLi7JvhFpARVt0Ymnw0rYFpi&q=${_search}&limit=25&offset=${_offset}&rating=G&lang=en");
    }

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif", width: 192.8),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              autocorrect: false,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hasFloatingPlaceholder: false,
                filled: true,
                fillColor: Colors.white,
                labelText: "Search",
                labelStyle: TextStyle(color: Color.fromRGBO(166, 166, 166, 1)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0)
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0)
                )
              ),
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch(snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 3.0,
                        ),
                      );
                    default:
                      if(snapshot.hasError) {
                        return Container();
                      }
                      else {
                        return _createGifTable(context, snapshot);
                      }
                  }
                }
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    if(_search == "") {
      return data.length;
    }
    else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    List<dynamic> gifs = snapshot.data["data"];

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _getCount(gifs),
      itemBuilder: (context, index) {
        if(_search == "" || index < gifs.length) {
          return GestureDetector(
            child: Image.network(
              gifs[index]["images"]["fixed_height"]["url"],
              height: 300.0,
              fit: BoxFit.cover
            ),
          );
        }
        else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 55.0),
                  Divider(height: 5.0),
                  Text("More",
                    style: TextStyle(color: Colors.white, fontSize: 17.0),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 25;
                });
              },
            ),
          );
        }
      }
    );
  }
}