import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helpdesk/Menu/IssuesClosed.dart';
import 'package:flutter_helpdesk/Menu/IssuesDefer.dart';
import 'package:flutter_helpdesk/Menu/IssuesNew.dart';
import 'package:flutter_helpdesk/Menu/Menu.dart';
import 'package:flutter_helpdesk/Models/New.dart';
import 'package:flutter_helpdesk/screens/Loading.dart';
import 'package:flutter_helpdesk/services/BadgeIcon.dart';
import 'package:flutter_helpdesk/services/Deviceinfo.dart';
import 'package:flutter_helpdesk/services/Jsondata.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
//  runApp(MyApp());
  Intl.defaultLocale = 'th';
  initializeDateFormatting();
  runApp(
    MyApp4(),
  );
}

class MyApp4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CNMI',
      theme: ThemeData(accentColor: Colors.blue),
      home: Deviceinfo(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences sharedPreferences;
  StreamController<int> _countController = StreamController<int>();
  int _currentIndex = 0;
  int _tabBarCount = 0;
  var formatter = DateFormat.yMd().add_jm();
  List<New> _new;
  bool _loading;

//  MainPage one = new MainPage();
  IssuesNew news = new IssuesNew();
  IssuesDefer defer = new IssuesDefer();
  IssuesClosed closed = new IssuesClosed();
  Menu menu = new Menu();
  List<Widget> pages;
  Widget currantpage;

  @override
  void initState() {
    super.initState();
    pages = [news, defer, closed, menu];
    currantpage = news;
    _loading = true;
    Jsondata.getNew().then((_newss) {
      setState(() {
        _new = _newss;
        _loading = false;
        if (_new.length != 0) {
          _tabBarCount = _new.length;
          _countController.sink.add(_tabBarCount);
        }
        else{
          _tabBarCount = _new.length;
          _countController.sink.add(_tabBarCount);
        }
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          mainAxisSize: MainAxisSize.min,
//          children: [
//            Text(
//              "CNMI Helpdesk",
//            )
//          ],
//        ),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.exit_to_app),
//            onPressed: () {
//              sharedPreferences.clear();
//              sharedPreferences.commit();
//              Navigator.of(context).pushAndRemoveUntil(
//                  MaterialPageRoute(
//                      builder: (BuildContext context) => LoginScreen()),
//                  (Route<dynamic> route) => false);
//            },
//          ),
//        ],
//      ),
      body: currantpage,
      bottomNavigationBar: RefreshIndicator(
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: StreamBuilder(
                  initialData: _tabBarCount,
                  stream: _countController.stream,
                  builder: (_, snapshot) => BadgeIcon(
                    icon: Icon(
                      Icons.new_releases,
                    ),
                    badgeCount: snapshot.data,
                  ),
                ),
                title: const Text("News"),
              ),
              // icon: Icon(Icons.new_releases),
              // title: Text("New"),
              // backgroundColor: Colors.blue),
              BottomNavigationBarItem(
                  icon: Icon(Icons.note),
                  title: Text("Defer"),
                  backgroundColor: Colors.blue),
              BottomNavigationBarItem(
                  icon: Icon(Icons.save),
                  title: Text("Closed"),
                  backgroundColor: Colors.blue),
              BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  title: Text("Menu"),
                  backgroundColor: Colors.blue),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                currantpage = pages[index];
                Jsondata.getNew().then((_newss) {
                  setState(() {
                    _new = _newss;
                    if (_new.length != 0) {
                      _tabBarCount = _new.length;
                      _countController.sink.add(_tabBarCount);
                    }
                    else{
                      _tabBarCount = _new.length;
                      _countController.sink.add(_tabBarCount);
                    }
                  });
                });
              });
            },
          ),
        ),
        onRefresh: _handleRefresh,
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    Completer<Null> completer = new Completer<Null>();

    new Future.delayed(new Duration(milliseconds: 5)).then((_) {
      completer.complete();
      setState(() {
        _loading = true;
        Jsondata.getNew().then((_newss) {
          setState(() {
            _new = _newss;
            _loading = false;
            if (_new.length != 0) {
              _tabBarCount = _new.length;
              _countController.sink.add(_tabBarCount);
            }
            else{
              _tabBarCount = _new.length;
              _countController.sink.add(_tabBarCount);
            }
          });
        });
      });
    });

    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _countController.close();
  }
}

// Todo Image
//class MyApp extends StatelessWidget {
//  var _title = "CNMI Workshop Layout";
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: _title,
//      home: Scaffold(
//        appBar: AppBar(
//          title: Text(_title),
//        ),
//        body: ListView(
//          children: <Widget>[
//            headerSection,
//            titleSection,
//            buttonSection,
//            courseSection
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//Widget headerSection =
//    Image.network("https://pbs.twimg.com/media/EOGM6S0VUAALbci.jpg");
//
//Widget titleSection = Padding(
//  padding: EdgeInsets.all(50),
//  child: Row(
//    children: <Widget>[
//      Expanded(
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Text(
//              "CNMI Helpdesk",
//              style: TextStyle(fontWeight: FontWeight.bold),
//            ),
//            Text(
//              "CNMI RAMAMAHIDON",
//              style: TextStyle(color: Colors.grey[500]),
//            )
//          ],
//        ),
//      ),
//      Icon(
//        Icons.thumb_up,
//        color: Colors.blue,
//      ),
//      Container(
//        margin: EdgeInsets.only(left: 8),
//        child: Text("99"),
//      )
//    ],
//  ),
//);
//
//Widget buttonSection = Row(
//  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//  children: <Widget>[
//    _buildButtonColumn(icon: Icons.thumb_up, label: "Like"),
//    _buildButtonColumn(icon: Icons.comment, label: "Comment"),
//    _buildButtonColumn(icon: Icons.share, label: "Share")
//  ],
//);
//
//Column _buildButtonColumn({IconData icon, String label}) {
//  var icColor = Colors.grey.shade500;
//  return Column(
//    children: <Widget>[
//      Icon(
//        icon,
//        color: icColor,
//      ),
//      Container(
//        margin: EdgeInsets.only(top: 12),
//        child: Text(
//          label,
//          style: TextStyle(
//              fontWeight: FontWeight.bold, fontSize: 13, color: icColor),
//        ),
//      )
//    ],
//  );
//}

//Widget courseSection = Container(
//  margin: EdgeInsets.only(top: 70),
//  padding: EdgeInsets.all(8),
//  child: Column(
//    crossAxisAlignment: CrossAxisAlignment.start,
//    children: <Widget>[
//      Padding(
//        padding: EdgeInsets.all(8),
//        child: Text("CNMI HelpDesk RAMA"),
//      ),
//      Container(
//        height: 120,
//        child: ListView(
//          scrollDirection: Axis.horizontal,
//          children: <Widget>[
//            _buildCardListView(
//                url:
//                    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ0pVCTmKZAo_hhHfE83hu1JSM9HDitC09RyQ&usqp=CAU"),
//            _buildCardListView(
//                url:
//                    "https://med.mahidol.ac.th/sites/default/files/public/img/event/DSC_0073_1.JPG"),
//            _buildCardListView(
//                url:
//                    "https://themomentum.co/wp-content/uploads/2018/01/Content-rama3-06.png"),
//            _buildCardListView(
//                url:
//                    "https://www.ramafoundation.or.th/give/uploads/projects/thumbnail/5f27dd768f95c.jpg")
//          ],
//        ),
//      )
//    ],
//  ),
//);

//Card _buildCardListView({String url}) {
//  return Card(
//    child:
//        FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: url),
//  );
//}

//แนวนอนและแนวตั้ง
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: "CM Layout",
//      home: Scaffold(
//        appBar: AppBar(
//          title: Text("CM Layout"),
//        ),
//        body: ListView(
//          scrollDirection: Axis.horizontal,
//          children: <Widget>[
//            Container(
//              alignment: FractionalOffset.center,
//              width: 150,
//              color: Colors.red,
//              child: Text(
//                "A",
//                style: TextStyle(fontSize: 100, color: Colors.white),
//              ),
//            ),
//            Container(
//              alignment: FractionalOffset.center,
//              width: 150,
//              color: Colors.green,
//              child: Text(
//                "B",
//                style: TextStyle(fontSize: 100, color: Colors.white),
//              ),
//            ),
//            Container(
//              alignment: FractionalOffset.center,
//              width: 150,
//              color: Colors.orange,
//              child: Text(
//                "C",
//                style: TextStyle(fontSize: 100, color: Colors.white),
//              ),
//            ),
//            Container(
//              alignment: FractionalOffset.center,
//              width: 150,
//              color: Colors.yellow,
//              child: Text(
//                "D",
//                style: TextStyle(fontSize: 100, color: Colors.white),
//              ),
//            ),
//            Container(
//              alignment: FractionalOffset.center,
//              width: 150,
//              color: Colors.blue,
//              child: Text(
//                "E",
//                style: TextStyle(fontSize: 100, color: Colors.white),
//              ),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//}

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
