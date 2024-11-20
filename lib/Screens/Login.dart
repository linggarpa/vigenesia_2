import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dio/dio.dart';
import 'package:vigenesia_2/Constant/Const.dart';
import '../Models/Login_Model.dart';
import 'MainScreens.dart';
import 'Register.dart';
import 'package:flutter/gestures.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with WidgetsBindingObserver {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  // Declare controllers for email and password fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Variables to store user information
  String? nama;
  String? iduser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<LoginModels?> postLogin(String email, String password) async {
    var dio = Dio();
    LoginModels? model;
    String baseurl = url;

    Map<String, dynamic> data = {"email": email, "password": password};
    print("$baseurl/vigenesia/api/login");

    try {
      final response = await dio.post("$baseurl/vigenesia/api/login",
          data: data,
          options: Options(headers: {'Content-type': 'application/json'}));

      print("Response -> ${response.data} + ${response.statusCode}");

      if (response.statusCode == 200) {
        model = LoginModels.fromJson(response.data);
      }
    } catch (e) {
      print("Failed to load $e");
    }

    return model;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff300ea1), Color(0xFFEF5350)],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo
                  Text('Vigenesia',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                  SizedBox(height: 20),
                  // Login card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        children: [
                          Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff300ea1),
                            ),
                          ),
                          SizedBox(height: 20),
                          FormBuilderTextField(
                            name: "email",
                            controller: emailController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.person, color: Colors.grey),
                              labelText: "Username",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          FormBuilderTextField(
                            name: "password",
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: Colors.grey),
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFEF5350),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              minimumSize: Size(double.infinity, 50),
                            ),
                            onPressed: () async {
                              await postLogin(emailController.text,
                                      passwordController.text)
                                  .then((value) => {
                                        if (value != null)
                                          {
                                            setState(() {
                                              nama = value.data!.nama;
                                              iduser = value.data!.iduser;
                                              Navigator.pushReplacement(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          new MainScreens(
                                                              nama: nama!,
                                                              iduser:
                                                                  iduser!)));
                                              Flushbar(
                                                message: "Login Successful",
                                                duration: Duration(seconds: 2),
                                                backgroundColor:
                                                    Colors.greenAccent,
                                                flushbarPosition:
                                                    FlushbarPosition.TOP,
                                              ).show(context);
                                            })
                                          }
                                      });
                            },
                            child: Text("Login",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                          SizedBox(height: 20),
                          Text.rich(
                            TextSpan(
                              text: "Don't have an account? ",
                              children: [
                                TextSpan(
                                  text: "Create Account",
                                  style: TextStyle(
                                    color: Color(0xFFEF5350),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Register()),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
