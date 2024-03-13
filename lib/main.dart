import 'package:file_download/views/bottom_tab_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple,primary: Colors.blue),
        useMaterial3: true,
      ),
      home:const BottomTabView(),
    );
  }
}
