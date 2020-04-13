import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
    theme: ThemeData(
      hintColor: Colors.white,
      accentColor: Colors.black,
      textSelectionColor: Color.fromRGBO(166, 166, 166, 1),
      textSelectionHandleColor: Color.fromRGBO(120, 120, 120, 1)
    ),
  ));
}
