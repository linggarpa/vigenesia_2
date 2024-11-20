import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:vigenesia_2/Constant/Const.dart';
import 'package:vigenesia_2/Models/Motivasi_Model.dart';

class EditPage extends StatefulWidget {
  final String? id;
  final String? isi_motivasi;
  const EditPage({Key? key, this.id, this.isi_motivasi}) : super(key: key);
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String baseurl = url;
  var dio = Dio();
  Future<dynamic> putPost(String isi_motivasi, String ids) async {
    Map<String, dynamic> data = {"isi_motivasi": isi_motivasi, "id": ids};
    var response = await dio.put('$baseurl/vigenesia/api/dev/PUTmotivasi',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ));
    print("---> ${response.data} + ${response.statusCode}");
    return response.data;
  }

  TextEditingController isiMotivasiC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff300ea1), // Full background color for Scaffold
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Edit Motivasi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xff300ea1), // Purple AppBar color
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Allow scrolling when the keyboard appears
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: FormBuilderTextField(
                      name: "isi_motivasi",
                      controller: isiMotivasiC,
                      decoration: InputDecoration(
                        hintText: "${widget.isi_motivasi}",
                        hintStyle:
                            TextStyle(color: Colors.black), // White label text
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        filled: true,
                        fillColor:
                            Colors.white, // White background for the text field
                      ),
                      style: TextStyle(
                          color: Colors.black), // Black text color in the field
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(
                          0xFFEF5350), // Button color matches AppBar and body background
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    onPressed: () {
                      putPost(isiMotivasiC.text, widget.id!).then((value) {
                        if (value != null) {
                          Navigator.pop(context);
                          Flushbar(
                            message: "Berhasil Update & Refresh Dulu",
                            duration: Duration(seconds: 5),
                            backgroundColor: Colors.green,
                            flushbarPosition: FlushbarPosition.TOP,
                          ).show(context);
                        }
                      });
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text on button
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
