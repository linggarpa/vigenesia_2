import 'dart:convert';
import 'package:vigenesia_2/Models/Motivasi_Model.dart';
import 'package:vigenesia_2/Screens/EditPage.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'Login.dart';
import 'package:vigenesia_2/Constant/Const.dart';
import 'package:another_flushbar/flushbar.dart';

class MainScreens extends StatefulWidget {
  final String? iduser;
  final String? nama;
  const MainScreens({
    Key? key,
    this.nama,
    this.iduser,
  }) : super(key: key);
  @override
  _MainScreensState createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  String baseurl = url;
  String? id;
  var dio = Dio();
  bool _isSubmitted =
      false; // Menandakan apakah motivasi sudah disubmit atau belum

  List<MotivasiModel> ass = [];
  TextEditingController titleController = TextEditingController();

  Future<dynamic> sendMotivasi(String isi) async {
    Map<String, dynamic> body = {
      "isi_motivasi": isi,
      "iduser": widget.iduser,
    };
    try {
      Response response = await dio.post(
        "$baseurl/vigenesia/api/dev/POSTmotivasi/",
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      return response;
    } catch (e) {
      print("Error di -> $e");
    }
  }

  List<MotivasiModel> listproduk = [];
  Future<List<MotivasiModel>> getData() async {
    var response = await dio
        .get('$baseurl/vigenesia/api/Get_motivasi?iduser=${widget.iduser}');
    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers =
          getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();
      return listUsers;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> deletePost(String id) async {
    dynamic data = {
      "id": id,
    };
    var response = await dio.delete('$baseurl/vigenesia/api/dev/DELETEmotivasi',
        data: data,
        options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {"Content-type": "application/json"}));
    return jsonDecode(response.data);
  }

  Future<List<MotivasiModel>> getData2() async {
    var response = await dio.get('$baseurl/vigenesia/api/Get_motivasi');
    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers =
          getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();
      return listUsers;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<void> _getData() async {
    setState(() {
      getData();
      listproduk.clear();
    });
  }

  // Fungsi untuk menampilkan dialog konfirmasi sebelum menghapus
  Future<void> _showDeleteConfirmationDialog(String id) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Konfirmasi Penghapusan"),
          content: Text("Apakah Anda yakin ingin menghapus motivasi ini?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Jika pilih "Tidak", tutup dialog
                Navigator.of(context).pop();
              },
              child: Text("Tidak"),
            ),
            TextButton(
              onPressed: () {
                // Jika pilih "Ya", hapus motivasi
                deletePost(id).then((value) {
                  if (value != null) {
                    // Menampilkan Flushbar setelah penghapusan berhasil
                    Flushbar(
                      message: "Berhasil Delete",
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.redAccent,
                      flushbarPosition: FlushbarPosition.TOP,
                    ).show(context);
                  }
                });
                _getData(); // Reload data setelah dihapus
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text("Ya"),
            ),
          ],
        );
      },
    );
  }

  TextEditingController isiController = TextEditingController();
  String? trigger;
  @override
  void initState() {
    super.initState();
    getData();
    getData2();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff300ea1),
      appBar: null, // Menghapus AppBar

      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Welcome ${widget.nama}",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  // Wrap the image with Center to center it
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      'images/vigenesia_logo2.png', // Replace with your image path
                      height: 300,
                      width: 300,
                    ),
                  ),
                ),

                SizedBox(height: 20),
                // Input Text Motivasi
                TextField(
                  controller: isiController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Masukkan Motivasi",
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // Submit Button
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await sendMotivasi(isiController.text).then((value) {
                        if (value != null) {
                          Flushbar(
                            message: "Berhasil Submit",
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.greenAccent,
                            flushbarPosition: FlushbarPosition.TOP,
                          ).show(context);
                        }
                      });
                      setState(() {
                        _isSubmitted =
                            true; // Tandai bahwa motivasi telah disubmit
                        isiController.clear(); // Kosongkan input setelah submit
                      });
                      _getData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEF5350),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text("Submit",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                SizedBox(height: 20),
                // Filter by "Motivasi By All" or "Motivasi By User"
                FormBuilderRadioGroup(
                  onChanged: (value) {
                    setState(() {
                      trigger = value;
                    });
                  },
                  name: "_",
                  activeColor: Colors.white, // Ubah warna aktif menjadi putih
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  options: ["Motivasi By All", "Motivasi By User"]
                      .map((e) => FormBuilderFieldOption(
                          value: e,
                          child:
                              Text(e, style: TextStyle(color: Colors.white))))
                      .toList(),
                ),
                SizedBox(height: 20),
                // Data Motivasi
                trigger == "Motivasi By User"
                    ? FutureBuilder<List<MotivasiModel>>(
                        future: getData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasData && snapshot.data != null) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                var item = snapshot.data![index];
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      title: Text(
                                        item.isiMotivasi.toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Edit Button
                                          IconButton(
                                            icon: Icon(Icons.edit,
                                                color: Color(0xff300ea1)),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          EditPage(
                                                    id: item.id,
                                                    isi_motivasi:
                                                        item.isiMotivasi,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          // Delete Button
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              // Show delete confirmation dialog
                                              _showDeleteConfirmationDialog(
                                                  item.id.toString());
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(child: Text("No Data"));
                          }
                        },
                      )
                    : trigger == "Motivasi By All"
                        ? FutureBuilder<List<MotivasiModel>>(
                            future: getData2(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasData && snapshot.data != null) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var item = snapshot.data![index];
                                    return Card(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 5,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          title: Text(
                                            item.isiMotivasi.toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(child: Text("No Data"));
                              }
                            },
                          )
                        : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
