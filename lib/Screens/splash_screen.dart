import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Login.dart'; // Ganti dengan layar utama aplikasi Anda

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  // Fungsi untuk menunggu beberapa detik sebelum pindah ke halaman utama
  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Login()), // Ganti dengan halaman utama Anda
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Sesuaikan warna latar belakang
      body: Center(
        child: Image.asset('images/vigenesia_logo.png'), // Logo aplikasi Anda
      ),
    );
  }
}
