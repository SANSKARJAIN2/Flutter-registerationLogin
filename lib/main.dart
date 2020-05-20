import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Qual Task- Sansakar Jain',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(), //(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        //primarySwatch: Colors.blue,

        //),
        home: registerationPage() //MyHomePage(title: 'Flutter Demo Home Page'),
        );
  }
}

class registerationPageState extends State<registerationPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: _buildbody(),
    );
  }

  String name, email, buttontext = "Submit";
  int phone = 0;
  bool allCorrect = true, takeinput = true;

  bool isemail(String email) {
    int index = email.indexOf("@");
    int dot = email.indexOf(".", index + 1);
    if (index < dot && dot != email.length - 1 && dot - index >= 2) {
      return true;
    } else {
      return false;
    }
  }

  Widget _buildbody() {
    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      //autovalidate: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
                labelText: "Name", hintText: ("Please enter your name")),
            initialValue: name,
            enabled: takeinput,
            validator: (value) {
              if (value.isEmpty) {
                allCorrect = false;
                return "Please enter a vald email";
              } else {
                name = value;
                allCorrect = true;
                //    return "Verified";
              }
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
                labelText: "Email", hintText: ("Please enter your Email")),
            initialValue: email,
            enabled: takeinput,
            validator: (value) {
              if (value.isEmpty) {
                allCorrect = false;
                return "Please enter a vald email";
              } else {
                if (isemail(value)) {
                  email = value;
                  allCorrect = true;
                } else {
                  allCorrect = false;
                  return "please enter a valid email";
                }

                //    return "Verified";
              }
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
                labelText: "Phone", hintText: ("Please enter your Phone")),
            initialValue: phone == 0 ? "" : phone.toString(),
            enabled: takeinput,
            validator: (value) {
              if (value.isEmpty || value.length - 1 == 10) {
                allCorrect = false;
                return "Please enter a vald Phone";
              } else {
                try {
                  phone = int.parse(value);
                  allCorrect = true;
                } catch (e) {
                  allCorrect = false;
                  return "Please enter a valid phone number";
                }
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: RaisedButton(
              onPressed: () {
                print("button pressed");
                //print(allCorrect.toString());
                if (_formKey.currentState.validate()) {}
                if (allCorrect) {
                  verifyPhoneNumber("+91" + phone.toString());
                  print(name + " " + email + " " + phone.toString() + "\n");
                  takeinput = false;
                  setState(() {
                    update(phone, email, name);
                    buttontext = "Verifying";
                  });
                  resend().then((value) {
                    setState(() {
                      buttontext = "Resend otp";
                      
                    });
                  });
                }
              },
              child: Text(buttontext),
            ),
          )
        ],
      ),
    );

    /*Padding(
        padding: const EdgeInsets.all(22.0),
        child: Center(

          child: Text("HELLO WORLD"),
        )
    );*/
  }

  void update(int phoneu, String emailu, String nameu) async {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection("user")
        .document(phoneu.toString())
        .setData({
      "name": nameu,
      "phone": phoneu,
      "email": emailu,
    });
    print(phoneu.toString() + " " + emailu + " " + nameu);
  }

  String Verid;
  bool success = false;
  Future<void> verifyPhoneNumber(phoneNumber) async {
    final PhoneVerificationCompleted completed = (AuthCredential authresult) {
      FirebaseAuth.instance.signInWithCredential(authresult);
      success = true;
      print("login Success");
      login();
      //var snackBar = SnackBar(content: Text("Login succesfull & number verified"));
      //Scaffold.of(context).showSnackBar(snackBar);
    };
    PhoneVerificationFailed failed(AuthException exception) {
      print("Login Falied " + exception.message);
    }

    ;
    PhoneCodeSent Sent(String codeSent, [int forced]) {
      this.Verid = codeSent;
      print("code Sent $codeSent");
    }

    ;
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 10),
        verificationCompleted: completed,
        verificationFailed: failed,
        codeSent: Sent,
        codeAutoRetrievalTimeout: null);
  }

  void login() {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => loginPage()));
  }

  Future<void> resend() async {
    await Future.delayed(Duration(seconds: 10));
  }
}

class registerationPage extends StatefulWidget {
  registerationPage({Key key}) : super(key: key);
  @override
  registerationPageState createState() => registerationPageState();
}

class loginPage extends StatefulWidget {
  loginPage({Key key}) : super(key: key);
  @override
  loginPageState createState() => loginPageState();
}

class loginPageState extends State<loginPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("LOGIN"),
      ),
      body: _buildbody(),
    );
  }

  Widget _buildbody() {
    final _formkey = new GlobalKey<FormState>();
    bool takeinput = true, allcorrect = false;
    String buttonText = "Submit";
    int phone = 0;
    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                labelText: "Phone",
                hintText: "Please enter your registered phone number"),
            enabled: takeinput,
            initialValue: phone == 0 ? "" : phone.toString(),
            validator: (value) {
              print(value);
              if (value.isEmpty || value.length != 10) {
                print("empty");
                allcorrect = false;
                return "Please enter a correct value";
              } else {
                try {
                  phone = int.parse(value);
                  allcorrect = true;
                  takeinput = false;
                  print("converted " + phone.toString());
                } catch (e) {
                  allcorrect = false;
                  print("incorrect value");
                  return "please enter a valid phone number";
                }
              }
            },
          ),
          RaisedButton(
            onPressed: () {
              if (_formkey.currentState.validate()) {}
              setState(() {
                buttonText = "Verifying";
                print(buttonText);
                retrive(phone);
              });
              resend().then((value) {
                setState(() {
                  buttonText = "Resend";
                  print(buttonText);
                });
              });
              if (allcorrect) {
                print("sending Code");
                
                
              }
            },
            child: Text(buttonText),
          )
        ],
      ),
    );
  }

  Future<void> showAlert() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid user"),
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                Text("User not registered before please register first"),
              ],
            )),
            actions: <Widget>[
              FlatButton(
                child: Text("Register"),
                onPressed: () {
                  Navigator.of(context).pop();
                  
                },
              )
            ],
          );
        });
  }

  String user;
  bool isRegisteredUser = false;
  void retrive(int phone) async {
    final documnetReference = Firestore.instance;
    var data = await documnetReference
        .collection("user")
        .document(phone.toString())
        .get();
    try {
      user = data["name"];
      isRegisteredUser = true;
      print("verification in progress");
        verifyPhoneNumber(("+91" + phone.toString()));

    } catch (e) {
      print("null");
      isRegisteredUser = false;
      showAlert();      
    }
//print((data?.data??"null").toString())    ;
  }

  Future<void> resend() async {
    await Future.delayed(Duration(seconds: 10));
  }

  String Verid;
  Future<void> verifyPhoneNumber(phoneNumber) async {
    final PhoneVerificationCompleted completed = (AuthCredential authresult) {
      FirebaseAuth.instance.signInWithCredential(authresult);
      print("login Success");
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => dashboard(user = user)));
    };
    PhoneVerificationFailed failed(AuthException exception) {
      print("Login Falied " + exception.message);
    }

    ;
    PhoneCodeSent Sent(String codeSent, [int forced]) {
      this.Verid = codeSent;
      print("code Sent $codeSent");
    }

    ;
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 10),
        verificationCompleted: completed,
        verificationFailed: failed,
        codeSent: Sent,
        codeAutoRetrievalTimeout: null);
  }
}

class dashboard extends StatefulWidget {
  String user;
  @override
  dashboard(this.user);
  _dashboardState createState() => _dashboardState(user = user);
}

class _dashboardState extends State<dashboard> {
  String user;
  _dashboardState(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome"),
        ),
        body: Center(
          child: Text("HELLO $user"),
        ));
  }
}
