import 'package:file_download/models/vos/dataVo.dart';
import 'package:file_download/widgets/dataListView.dart';
import 'package:flutter/material.dart';

class FileView extends StatelessWidget {
 const FileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.amber,title:const Text('File Downloader'),),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              var data = dataList[index];
              return DataListView(data: data);
            }),
      ),
      
    );
  }
}


