import 'dart:convert';
import 'package:flutter_helpdesk/Menu/IssuesClosed.dart';
import 'package:flutter_helpdesk/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helpdesk/services/Jsondata.dart';
import 'package:validators/validators.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

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

  Widget _logo() => Image.asset(
        ("assets/header_main.png"),
        fit: BoxFit.cover,
      );

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  Widget _buildUsernameInput() => TextFormField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'example@gmail.com',
          icon: Icon(Icons.email),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: _validateEmail,
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
        validator: _validatePassword,
        onSaved: (String value) {},
      );

  signIn(String email, String password) async {
    Map data = {'email': email, 'password': password};
    var jsonData = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response =
        await http.post("http://10.57.34.148:8000/api/login", body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      if (jsonData != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonData['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MainPage()),
            (Route<dynamic> route) => false);
      }
    } else {
      print(response.body);
    }
  }

  Widget _buildSubmitButton() => Container(
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        margin: EdgeInsets.only(top: 30),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: RaisedButton(
          color: Colors.blueAccent,
          onPressed: emailController.text == "" || passwordController.text == "" ? null : () {
            _submit();
//            setState(() {
//              _isLoading = true;
//            });

            signIn(emailController.text, passwordController.text);
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

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return "The Email is Empty.";
    }
    if (!isEmail(value)) {
      return "The Email must be a valid email.";
    }
  }

  String _validatePassword(String value) {
    if (value.length < 8) {
      return "The Password must be at least 8 charactors.";
    }
  }
}
