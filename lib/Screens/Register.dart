import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dio/dio.dart';
import '../Constant/Const.dart';
import 'Login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String baseurl = url;

  Future postRegister(
      String nama, String profesi, String email, String password) async {
    var dio = Dio();

    dynamic data = {
      "nama": nama,
      "profesi": profesi,
      "email": email,
      "password": password
    };

    try {
      print(data);
      Response response = await dio.post("$baseurl/vigenesia/api/registrasi/",
          data: {
            "nama": nama,
            "profesi": profesi,
            "email": email,
            "password": password
          },
          options: Options(headers: {'Content-type': 'application/json'}));
      print("Respon -> ${response.data} + ${response.statusCode}");
      // print(response);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print("Failed To Load $e");
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController profesiController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Register Your Account",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              FormBuilderTextField(
                                name: "name",
                                controller: nameController,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.person, color: Colors.grey),
                                  labelText: "Name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              FormBuilderTextField(
                                name: "profesi",
                                controller: profesiController,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.work, color: Colors.grey),
                                  labelText: "Profession",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              FormBuilderTextField(
                                name: "email",
                                controller: emailController,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.email, color: Colors.grey),
                                  labelText: "Email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              FormBuilderTextField(
                                obscureText: true,
                                name: "password",
                                controller: passwordController,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.lock, color: Colors.grey),
                                  labelText: "Password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFEF5350),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                  ),
                                  onPressed: () async {
                                    await postRegister(
                                      nameController.text,
                                      profesiController.text,
                                      emailController.text,
                                      passwordController.text,
                                    ).then((value) {
                                      if (value != null) {
                                        Navigator.pop(context);
                                        Flushbar(
                                          message: "Registration Successful",
                                          duration: Duration(seconds: 2),
                                          backgroundColor: Colors.greenAccent,
                                          flushbarPosition:
                                              FlushbarPosition.TOP,
                                        ).show(context);
                                      } else {
                                        Flushbar(
                                          message:
                                              "Please check your details and try again",
                                          duration: Duration(seconds: 5),
                                          backgroundColor: Colors.redAccent,
                                          flushbarPosition:
                                              FlushbarPosition.TOP,
                                        ).show(context);
                                      }
                                    });
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text.rich(
                                TextSpan(
                                  text: "you already have an account? ",
                                  children: [
                                    TextSpan(
                                      text: "Sign-in",
                                      style: TextStyle(
                                        color: Color(0xFFEF5350),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Login()),
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
            ),
          ),
        ],
      ),
    );
  }
}
