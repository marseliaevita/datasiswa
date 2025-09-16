import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:datasiswa/page/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Data Siswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(), // << pakai Poppins
      ),
      home: const HomePage(),
    );
  }
}
