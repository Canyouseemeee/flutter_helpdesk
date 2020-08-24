import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_helpdesk/services/Jsondata.dart';
import 'package:flutter_helpdesk/Models/Closed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helpdesk/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IssuesClosed extends StatefulWidget {
  @override
  _IssuesClosedState createState() => _IssuesClosedState();
}

class _IssuesClosedState extends State<IssuesClosed> {
  SharedPreferences sharedPreferences;
  List<Closed> _closed;
  bool _loading;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    _loading = true;
    Jsondata.getClosed().then((closed) {
      setState(() {
        _closed = closed;
        _loading = false;
      });
    });
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_loading ? 'Loading...' : 'Closed'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              sharedPreferences.clear();
              sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
      body: new RefreshIndicator(
        child: ListView.builder(
          itemCount: null == _closed ? 0 : _closed.length,
          itemBuilder: (context, index) {
            Closed closed = _closed[index];
            return ListTile(
              title: Text(closed.subject),
              subtitle: Text(closed.issName),
            );
          },
        ),
        onRefresh: _handleRefresh,
      ),
      drawer: Drawer(),
    );
  }

  Widget _headerImageSection() => Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Image.asset(
          "assets/header_main.png",
          height: 100,
        ),
      );

  Future<Null> _handleRefresh() async {
    Completer<Null> completer = new Completer<Null>();

    new Future.delayed(new Duration(seconds: 3)).then((_) {
      completer.complete();
      setState(() {
        _loading = true;
        Jsondata.getClosed().then((closed) {
          setState(() {
            _closed = closed;
            _loading = false;
          });
        });
      });
    });

    return null;
  }
}
