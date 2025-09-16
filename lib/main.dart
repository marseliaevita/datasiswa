import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:datasiswa/page/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://gkitdqwnyavcguuubjza.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdraXRkcXdueWF2Y2d1dXVianphIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc5ODkzODUsImV4cCI6MjA3MzU2NTM4NX0.plniQODP6zhUSbnNet6a55CwmwoQP59RExtRSF0ZWaI',
  );

  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Siswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const HomePage(),
    );
  }
}
