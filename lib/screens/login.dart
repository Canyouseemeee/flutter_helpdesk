import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_helpdesk/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helpdesk/screens/Loading.dart';
import 'package:validators/validators.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  SharedPreferences sharedPreferences;
  bool _disposed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!_disposed) {
      checkLoginStatus();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _disposed = true;
    super.dispose();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MainPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.teal,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView(
                    children: <Widget>[
                      _buildForm(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() => Card(
        margin: EdgeInsets.only(top: 80, left: 30, right: 30),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _logo(),
                SizedBox(
                  height: 22,
                ),
                _buildUsernameInput(),
                SizedBox(
                  height: 8,
                ),
                _buildPasswordInput(),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      );

  Widget _logo() => FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      image:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/CNMI_logo.svg/1200px-CNMI_logo.svg.png");

  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  Widget _buildUsernameInput() => TextFormField(
        controller: usernameController,
        decoration: InputDecoration(
          labelText: 'Username',
          hintText: 'Username',
          icon: Icon(Icons.person),
        ),
        // validator: _validateUsername,
        onSaved: (String value) {},
        onFieldSubmitted: (String value) {},
      );

  Widget _buildPasswordInput() => TextFormField(
        controller: passwordController,
        decoration: InputDecoration(
          labelText: 'Password',
          icon: Icon(Icons.lock),
        ),
        obscureText: true,
        // validator: _validatePassword,
        onSaved: (String value) {},
      );

  signIn(String username, String password) async {
    Map data = {'username': username, 'password': password};
    var jsonData = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await http
        .post("http://cnmihelpdesk.rama.mahidol.ac.th/api/login", body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      // print(jsonData);
      if (jsonData != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonData['token']);
        sharedPreferences.setString(
            "username", username);
        sharedPreferences.setString("name", jsonData['name']);
        postloginlog(sharedPreferences.getString("username"),
            sharedPreferences.getString("token"));
        sharedPreferences.setString("team", jsonData['team']);
        // print(sharedPreferences.getString('email'));
      }
    } else {
      _showAlertDialog();
      print(response.body);
    }
  }

  postloginlog(String username, String token) async {
    sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'username': username,
      'deviceid': sharedPreferences.getString("Deviceid"),
      'ip': sharedPreferences.getString("ipAddress"),
      'token': token,
    };
    var jsonData = null;
    var response = await http
        .post("http://cnmihelpdesk.rama.mahidol.ac.th/api/issues-postlogin", body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      if (jsonData != null) {
        setState(() {
          _isLoading = false;
          sharedPreferences.setString("expired", jsonData['expired']);
          print(sharedPreferences.getString("expired").replaceAll(" ", ""));
          sharedPreferences.setString("image", jsonData['image'].toString());
          // print(sharedPreferences.getString("image").toString());
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MainPage()),
                (Route<dynamic> route) => false);
      }
    } else {
      // print(response.body);
    }
  }

  void _showAlertDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Username หรือ Password ไม่ถูกต้อง"),
            // content: Text("Are you sure"),
            actions: [
              FlatButton(
                onPressed: () {
                  usernameController.clear();
                  passwordController.clear();
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        });
  }

  Widget _buildSubmitButton() => Container(
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        margin: EdgeInsets.only(top: 30),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: RaisedButton(
          color: Colors.blueAccent,
          onPressed: usernameController.text == ""
              ? null
              : () {
                  setState(() {
                    _submit();
                    signIn(usernameController.text, passwordController.text);
                  });
                },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            "Sign In",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );

  void _submit() {
    if (this._formKey.currentState.validate()) {}
  }

  String _validateUsername(String value) {
    if (value.isEmpty) {
      return "The Username is Empty.";
    }
  }

  String _validatePassword(String value) {
    if (value.length < 8) {
      return "The Password must be at least 8 charactors.";
    }
  }
}
