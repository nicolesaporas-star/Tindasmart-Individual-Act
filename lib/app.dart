
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/report_form_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TindaSmart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      routes: {
        '/report': (context) => const ReportFormScreen(),
      },
      home: const HomeScreen(),
    );
  }
}
