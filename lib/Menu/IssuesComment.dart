import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helpdesk/Models/Comment.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';

class IssuesComment extends StatefulWidget {
  String news;

  IssuesComment(this.news);

  @override
  _IssuesCommentState createState() => _IssuesCommentState(news);
}

class _IssuesCommentState extends State<IssuesComment> {
  String news;

  _IssuesCommentState(this.news);

  List<Comment> _comment;
  bool _loading;
  SharedPreferences sharedPreferences;
  final double _borderRadius = 25;
  int _currentMax = 10;
  var max;
  var min;
  var formatter = DateFormat.yMd().add_jm();
  ScrollController _scrollController = new ScrollController();
  DateTime time = DateTime.now();
  bool _disposed = false;
  TextEditingController commentController = new TextEditingController();
  File imageFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _commenttext = "";

  static Future<List<Comment>> getComment(String news) async {
    Map data = {
      'issuesid': news,
    };
    const String url = "http://cnmihelpdesk.rama.mahidol.ac.th/api/issues-getComment";
    try {
      final response = await http.post(url, body: data);
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final List<Comment> comment = issuesCommentFromJson(response.body);
          return comment;
        }
      } else {
        return List<Comment>();
      }
    } catch (e) {
      return List<Comment>();
    }
  }

  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      if (!_disposed)
        setState(() {
          time = time.add(Duration(seconds: -1));
        });
    });
    super.initState();
    // _decideImageView();
    _loading = true;
    getComment(news).then((comment) {
      setState(() {
        _comment = comment;
        if (_comment.length == 0) {
          // showAlertNullData();
          _loading = false;
        } else {
          max = _comment.length;
          if (_comment.length > 10) {
            _comment = List.generate(10, (index) => _comment[index]);
          } else {
            _comment = comment;
          }
          min = _comment.length;
          _scrollController.addListener(() {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
              getMoreData();
            }
          });
          _loading = false;
        }
      });
    });
  }

  getMoreData() {
    if (min == 10) {
      for (int i = _currentMax; i < max - 1; i++) {
        getComment(news).then((comment) {
          setState(() {
            _comment = comment;
            _comment.add(_comment[i]);
            _comment.length = max;
            _loading = false;
            if (_comment.isNotEmpty) {
              return _comment.elementAt(0);
            }
          });
        });
      }
      if (_comment.length == max) {
        showAlertLimitData();
      }
    }
    setState(() {});
  }

  showAlertLimitData() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("ข้อมูลสิ้นสุดแค่นี้"),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _disposed = true;
    super.dispose();
  }

  showAlertupdatesuccess() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("อัพเดทสำเร็จ"),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        });
  }

  postcomment(String news, File image) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (image != null) {
      String fileName = image.path.split('/').last;
      if (sharedPreferences.getString("token") != null) {
        var data = FormData.fromMap({
          'issuesid': news,
          'user': sharedPreferences.getString("name"),
          'comment': commentController.text,
          "image": await MultipartFile.fromFile(
            image.path,
            filename: fileName,
          ),
        });
        Dio dio = new Dio();
        await dio
            .post("http://cnmihelpdesk.rama.mahidol.ac.th/api/issues-postComment", data: data)
            .then((response) => print(response))
            .catchError((error) => print(error));
      }
    }else {
      if (sharedPreferences.getString("token") != null) {
        var data = FormData.fromMap({
          'issuesid': news,
          'user': sharedPreferences.getString("name"),
          'comment': commentController.text,
          "image": null,
        });
        Dio dio = new Dio();
        await dio
            .post("http://cnmihelpdesk.rama.mahidol.ac.th/api/issues-postComment", data: data)
            .then((response) => print(response))
            .catchError((error) => print(error));
      }
    }
  }

  poststatuscomment(String commentid) async {
    Map data = {'commentid': commentid};
    var jsonData = null;
    var response = await http
        .post("http://cnmihelpdesk.rama.mahidol.ac.th/api/issues-postStatusComment", body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      if (jsonData != null) {
      }
    } else {
      print(response.body);
    }
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      child: new AlertDialog(
        title: Text('Comment'),
        content: Form(
          key: _formKey,
          autovalidate: true,
          child: Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: <Widget>[
                      new ListView(
                        shrinkWrap: true,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: commentController,
                            decoration: InputDecoration(
                                hintText: "Comment", icon: Icon(Icons.comment)),
                            onSaved: (value)  => _commenttext = value,
                            validator: (value){
                              if (value.length < 4) {
                                return "Enter Comment min 4 character";
                              }
                              if (value.isEmpty) {
                                return "Enter Comment";
                              }else{
                                return null;
                              }
                            },
                          ),
                          _decideImageView(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('SAVE'),
            onPressed: () {
              setState(() {
                if(_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  postcomment(news.toString(), imageFile);
                  // print(news);
                  // print(imageFile.path.split('/').last);
                  Navigator.pop(context);
                  showAlertupdatesuccess();
                }
              });
            },
          ),
          new FlatButton(
            child: new Text('Chosse Image'),
            onPressed: () {
              _showChoiceDialog(context);
            },
          ),
          new FlatButton(
            child: new Text('Close'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _decideImageView() {
    if (imageFile == null) {
      return Padding(
          padding: EdgeInsets.only(top: 100),
          child: Center(child: Text("No Image Selected")));
    } else {
      return Padding(
          padding: EdgeInsets.only(top: 60),
          child: Center(
              child: Image.file(
            imageFile,
            width: 300,
            height: 300,
          )));
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a Choice"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallary"),
                    onTap: () {
                      _openGallry(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _openCamera(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _openGallry(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.pop(context);
    Navigator.pop(context);
    _showDialog();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.pop(context);
    Navigator.pop(context);
    _showDialog();
  }

  _showComment(int index) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      child: new AlertDialog(
        title: Text('Comment : '+_comment[index].comment),
        scrollable: true,
        actions: <Widget>[
          statusComment(index),
          // new FlatButton(
          //   child: new Text('UnActive'),
          //   onPressed: () {
          //     poststatuscomment(_comment[index].commentid.toString());
          //     Navigator.pop(context);
          //     Navigator.pop(context);
          //   },
          // ),
          new FlatButton(
            child: new Text('Close'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        content: _showImageView(index),
      ),
    );
  }

  statusComment(int index){
    if(_comment[index].status == 1){
      return new FlatButton(
        child: new Text('UnActive'),
        onPressed: () {
          poststatuscomment(_comment[index].commentid.toString());
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
    }else{
      return null;
    }
  }

  Widget _showImageView(int index) {
    if (_comment[index].image == null) {
      return Padding(
          padding: EdgeInsets.only(top: 100),
          child: Center(child: Text("No Image")));
    } else {
      return Padding(
          padding: EdgeInsets.only(top: 60),
          child: Center(
              child: Image.network(
                "http://cnmihelpdesk.rama.mahidol.ac.th/storage/"+_comment[index].image,
                width: 300,
                height: 300,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text(_loading ? 'Loading...' : "Comment")),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              _showDialog();
            },
          ),
        ],
        backgroundColor: Color(0xFF34558b),
      ),
      body: (_loading
          ? new Center(
              child: new CircularProgressIndicator(
              backgroundColor: Colors.white70,
            ))
          : _showJsondata()),
      backgroundColor: Color(0xFF34558b),
    );
  }

  Widget _showJsondata() => new RefreshIndicator(
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          itemCount: null == _comment ? 0 : _comment.length + 1,
          itemExtent: 100,
          itemBuilder: (context, index) {
            if (_comment.length == 0) {
              return Center(
                child: Text(
                  "ไม่พบข้อมูลงาน",
                  style: TextStyle(color: Colors.white70, fontSize: 20),
                ),
              );
            } else {
              if (index == _comment.length &&
                  _comment.length > 10 &&
                  index > 10) {
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.white70,
                ));
              } else if (index == _comment.length &&
                  _comment.length <= 10 &&
                  index <= 10) {
                return Center(child: Text(""));
              }
            }
            // New _new[index] = _new[index];
            return GestureDetector(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Color(0xFFf2f6f5),
                          // gradient: LinearGradient(
                          //   colors: [Color(0xFF34558b), Colors.lightBlue],
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          // ),
                        ),
                      ),
                      Positioned.fill(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Cid : " +
                                          _comment[index].commentid.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      "Id : " +
                                          _comment[index].issuesid.toString(),
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextStatus(index),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "Createat : " +
                                        formatter.formatInBuddhistCalendarThai(
                                            _comment[index].createdAt),
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                _showComment(index);
              },
            );
          },
        ),
        onRefresh: _handleRefresh,
      );

  Future<Null> _handleRefresh() async {
    Completer<Null> completer = new Completer<Null>();

    new Future.delayed(new Duration(milliseconds: 2)).then((_) {
      completer.complete();
      setState(() {
        Timer(Duration(seconds: 1), () {
          if (!_disposed)
            setState(() {
              time = time.add(Duration(seconds: -1));
            });
        });
        _loading = true;
        getComment(news).then((comment) {
          setState(() {
            _comment = comment;
            max = _comment.length;
            // _new = List.generate(10, (index) => _new[index]);
            min = _comment.length;
            _scrollController.addListener(() {
              if (_scrollController.position.pixels ==
                  _scrollController.position.maxScrollExtent) {
                getMoreData();
              }
            });
            _loading = false;
          });
        });
      });
    });

    return null;
  }

  TextStatus(int index) {
    if (_comment[index].status == 1) {
      return Text(
        "Status : Active",
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
      );
    } else if (_comment[index].status == 0) {
      return Text(
        "Status : UnActive",
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
      );
    }
  }
}
