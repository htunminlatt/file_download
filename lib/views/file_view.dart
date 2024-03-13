import 'package:file_download/models/vos/dataVo.dart';
import 'package:file_download/widgets/dataListView.dart';
import 'package:flutter/material.dart';

class FileView extends StatefulWidget {
  const FileView({super.key});

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('File Downloader'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
            key: const PageStorageKey<String>('page'),
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              var data = dataList[index];
              return DataListView(data: data, );
            }),
      ),
    );
  }
}
