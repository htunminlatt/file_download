import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ExternalFilesScreen extends StatefulWidget {
  @override
  _ExternalFilesScreenState createState() => _ExternalFilesScreenState();
}

class _ExternalFilesScreenState extends State<ExternalFilesScreen> {
  late Directory _externalDir;
  late List<FileSystemEntity> _files = [];

  @override
  void initState() {
    super.initState();
    _getExternalStorageDirectory();
  }

  Future<void> _getExternalStorageDirectory() async {
    Directory? directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    }

    setState(() {
      _externalDir = directory!;
    });
    _listFiles();
  }

  Future<void> _listFiles() async {
    List<FileSystemEntity> files = _externalDir.listSync();
    // debugPrint("File:::$files");
    setState(() {
      _files = files;
    });
  }

  void deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        _listFiles();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(duration: Duration(seconds: 1),content: Text('Delete Success!')));
      } else {
        print('File does not exist');
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  //fetching file
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('External Files'),
      ),
      body: _files.isEmpty
          ? const Center(
              child: Text('no downloaded file to show'),
            )
          : ListView.builder(
              itemCount: _files.length,
              itemBuilder: (context, index) {
                FileSystemEntity file = _files[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      leading: InkWell(
                        onTap: () {
                          deleteFile(file.path);
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      trailing:  InkWell(
                        onTap: () {
                          OpenFile.open(file.path);
                        },
                        child:const Text('view file',style: TextStyle(fontSize: 16),),),
                      title: Text(file.path.split('/').last),
                      onTap: () {},
                    ),
                  ),
                );
              },
            ),
    );
  }
}
