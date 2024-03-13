import 'package:file_download/views/external_file.dart';
import 'package:file_download/views/file_view.dart';
import 'package:flutter/material.dart';

class BottomTabView extends StatefulWidget {
  const BottomTabView({super.key});

  @override
  State<BottomTabView> createState() => _BottomTabViewState();
}

class _BottomTabViewState extends State<BottomTabView> {
  int selectedIndex = 0;
  List<Widget> views = [const FileView(), ExternalFilesScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: views[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
          
        },
        items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.file_copy),label: 'Files'),

      ]),
    );
  }
}
