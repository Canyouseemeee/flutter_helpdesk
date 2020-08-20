import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:validators/validators.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
//  runApp(MyApp());
//  runApp(MyApp2());
  runApp(MyApp3());
}

class User {
  User() {
    this.email = "";
    this.password = "";
    this.gender = "male";
    this.agreePolicy = false;
    this.receiveEmail = false;
  }

  String email;
  String password;
  String gender;
  bool agreePolicy;
  bool receiveEmail;
}

class MyApp3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String appTitle = "Helpdesk";

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: CumtomForm(),
      ),
    );
  }
}

class CumtomForm extends StatefulWidget {
  @override
  _CumtomFormState createState() => _CumtomFormState();
}

class _CumtomFormState extends State<CumtomForm> {
  final _formKey = GlobalKey<FormState>();
  User user = new User();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: _buildInputDecoration(
                    label: 'Email',
                    hint: 'example@gmail.com',
                    icon: Icons.email),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                onSaved: (String value) {
                  user.email = value;
                },
              ),
              TextFormField(
                decoration:
                    _buildInputDecoration(label: 'Password', icon: Icons.lock),
                obscureText: true,
                validator: _validatePassword,
                onSaved: (String value) {
                  user.password = value;
                },
              ),
              _buildGenderForm(),
              _buildReciveEmailForm(),
              _buildAgreePolicyForm(),
              _buildSubmitButton(),
            ],
          )),
    );
  }

  InputDecoration _buildInputDecoration(
      {String label, String hint, IconData icon}) {
    return InputDecoration(labelText: label, hintText: hint, icon: Icon(icon));
  }

  Widget _buildAgreePolicyForm() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 32),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Checkbox(
            value: user.agreePolicy,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                user.agreePolicy = value;
              });
            },
          ),
          Text("I Agree the "),
          GestureDetector(
            onTap: _launchURL,
            child: Text(
              'Pivacy Policy',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildReciveEmailForm() {
    return Row(
      children: <Widget>[
        Text(
          "Receive Email",
          style: TextStyle(fontSize: 16),
        ),
        Switch(
            activeColor: Colors.blue,
            value: user.receiveEmail,
            onChanged: (select) {
              setState(() {
                user.receiveEmail = select;
              });
            }),
      ],
    );
  }

  Widget _buildGenderForm() {
    final Color activeColor = Colors.blue;
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Row(
        children: <Widget>[
          Text(
            "Gender:",
            style: TextStyle(fontSize: 16),
          ),
          Radio(
              activeColor: activeColor,
              value: "male",
              groupValue: user.gender,
              onChanged: _handleRadioValue),
          Text("Male"),
          Radio(
              activeColor: activeColor,
              value: "female",
              groupValue: user.gender,
              onChanged: _handleRadioValue),
          Text("Female"),
        ],
      ),
    );
  }

  void _handleRadioValue(value) {
    print('value: ${value}');
    setState(() {
      user.gender = value;
    });
  }

  Widget _buildSubmitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 4),
      child: RaisedButton(
        color: Colors.blue,
        onPressed: _submit,
        child: Text(
          "Submit",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _submit() {
    if (this._formKey.currentState.validate()) {
      if (user.agreePolicy == false) {
        showAlertDialog();
      } else {
        _formKey.currentState.save();

        print("Email: ${user.email}");
        print("Password: ${user.password}");
        print("Gender: ${user.gender}");
        print("Receive Email: ${user.receiveEmail}");
        print("Agree Policy: ${user.agreePolicy}");
      }
    }
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Title"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("detail"),
                Text("detail"),
                Text("detail"),
                Icon(Icons.directions_walk)
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.cake), color: Colors.red, onPressed: null),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"))
          ],
        );
      },
    );
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

  _launchURL() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

// Todo TabBar
class Choice {
  final String title;
  final IconData icon;

  const Choice({this.title, this.icon});
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String appTitle = "CNMI";
    return MaterialApp(
        title: appTitle,
        home: DefaultTabController(
          length: choices.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text(appTitle),
//              bottom: TabBar(
//                isScrollable: true,
//                tabs: choices.map((Choice choice) {
//                  return Tab(
////                  text: choice.title,
////                  icon: Icon(choice.icon),
//                    child: Row(
//                      children: <Widget>[
//                        Icon(choice.icon),
//                        Container(
//                          margin: EdgeInsets.only(left: 8),
//                          child: Text(choice.title),
//                        )
//                      ],
//                    ),
//                  );
//                }).toList(),
//              ),
            ),
            body: TabBarView(
                children: choices.map((Choice choice) {
              return Center(
                child: Text(choice.title),
              );
            }).toList()),
            bottomNavigationBar: SafeArea(
              child: Container(
                color: Theme.of(context).primaryColor,
                child: TabBar(
                  isScrollable: true,
                  tabs: choices.map((Choice choice) {
                    return Tab(
                      text: choice.title,
                      icon: Icon(choice.icon),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ));
  }
}

// Todo Image
class MyApp extends StatelessWidget {
  var _title = "CNMI Workshop Layout";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: ListView(
          children: <Widget>[
            headerSection,
            titleSection,
            buttonSection,
            courseSection
          ],
        ),
      ),
    );
  }
}

Widget headerSection =
    Image.network("https://pbs.twimg.com/media/EOGM6S0VUAALbci.jpg");

Widget titleSection = Padding(
  padding: EdgeInsets.all(50),
  child: Row(
    children: <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "CNMI Helpdesk",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "CNMI RAMAMAHIDON",
              style: TextStyle(color: Colors.grey[500]),
            )
          ],
        ),
      ),
      Icon(
        Icons.thumb_up,
        color: Colors.blue,
      ),
      Container(
        margin: EdgeInsets.only(left: 8),
        child: Text("99"),
      )
    ],
  ),
);

Widget buttonSection = Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: <Widget>[
    _buildButtonColumn(icon: Icons.thumb_up, label: "Like"),
    _buildButtonColumn(icon: Icons.comment, label: "Comment"),
    _buildButtonColumn(icon: Icons.share, label: "Share")
  ],
);

Column _buildButtonColumn({IconData icon, String label}) {
  var icColor = Colors.grey.shade500;
  return Column(
    children: <Widget>[
      Icon(
        icon,
        color: icColor,
      ),
      Container(
        margin: EdgeInsets.only(top: 12),
        child: Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 13, color: icColor),
        ),
      )
    ],
  );
}

Widget courseSection = Container(
  margin: EdgeInsets.only(top: 70),
  padding: EdgeInsets.all(8),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.all(8),
        child: Text("CNMI HelpDesk RAMA"),
      ),
      Container(
        height: 120,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            _buildCardListView(
                url:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ0pVCTmKZAo_hhHfE83hu1JSM9HDitC09RyQ&usqp=CAU"),
            _buildCardListView(
                url:
                    "https://med.mahidol.ac.th/sites/default/files/public/img/event/DSC_0073_1.JPG"),
            _buildCardListView(
                url:
                    "https://themomentum.co/wp-content/uploads/2018/01/Content-rama3-06.png"),
            _buildCardListView(
                url:
                    "https://www.ramafoundation.or.th/give/uploads/projects/thumbnail/5f27dd768f95c.jpg")
          ],
        ),
      )
    ],
  ),
);

Card _buildCardListView({String url}) {
  return Card(
    child:
        FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: url),
  );
}

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
