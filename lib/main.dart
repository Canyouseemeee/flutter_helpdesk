import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CM Layout",
      home: Scaffold(
        appBar: AppBar(
          title: Text("CM Layout"),
        ),
        body: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
              alignment: FractionalOffset.center,
              width: 150,
              color: Colors.red,
              child: Text(
                "A",
                style: TextStyle(fontSize: 100, color: Colors.white),
              ),
            ),
            Container(
              alignment: FractionalOffset.center,
              width: 150,
              color: Colors.green,
              child: Text(
                "B",
                style: TextStyle(fontSize: 100, color: Colors.white),
              ),
            ),
            Container(
              alignment: FractionalOffset.center,
              width: 150,
              color: Colors.orange,
              child: Text(
                "C",
                style: TextStyle(fontSize: 100, color: Colors.white),
              ),
            ),
            Container(
              alignment: FractionalOffset.center,
              width: 150,
              color: Colors.yellow,
              child: Text(
                "D",
                style: TextStyle(fontSize: 100, color: Colors.white),
              ),
            ),
            Container(
              alignment: FractionalOffset.center,
              width: 150,
              color: Colors.blue,
              child: Text(
                "E",
                style: TextStyle(fontSize: 100, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//แนวตั้งแบบ ListView
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: "CM Layout",
//      home: Scaffold(
//        appBar: AppBar(
//          title: Text("CM Layout"),
//        ),
//        body: Padding(
//          padding: EdgeInsets.all(30),
//          child: ListView(
//            children: <Widget>[
//              FlutterLogo(
//                size: 100,
//              ),
//              Container(
//                margin: EdgeInsets.only(top: 20, bottom: 15),
//                child: Text(
//                  "Flutter Online",
//                  style: TextStyle(fontSize: 30),
//                  textAlign: TextAlign.center,
//                ),
//              ),
//              Text(
//                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\n\n\n"
//                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\n\n\n"
//                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\n\n\n"
//                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
