import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DataListView extends StatefulWidget {
  const DataListView({
    super.key,
    required this.data,
  });

  final Map<String, String> data;

  @override
  State<DataListView> createState() => _DataListViewState();
}

class _DataListViewState extends State<DataListView> {
  bool isDownloading = false;
  int _downloadProgress = 0;
  double percentate = 0;
  CancelToken _cancelToken = CancelToken();



///file download
  void downloadFile(String url, String filename) async {
    setState(() {
      isDownloading = !isDownloading;     
    });

    Directory? directory;
    directory = await getTemporaryDirectory();

    File saveFile = File('${directory.path}/$filename');

    var dio = Dio();
    String fileUrl = url;
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Token if present';
    try {
      await dio.download(fileUrl, saveFile.path,cancelToken: CancelToken(),
          onReceiveProgress: (received, total) {
        setState(() {
          _downloadProgress = (((received / total) * 100).toInt());
          percentate = _downloadProgress / 100;
          if(_downloadProgress == 100){
            isDownloading = false;
          }
        });
      });

    } catch (e) {
      print(e.toString());
    }
  }

//pause download
  pauseDownload() {
    _cancelToken.cancel("Download paused");
    _cancelToken = CancelToken();
  }


//resume download
  resumeDownload() {
    _cancelToken = CancelToken();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.data['title']!,
                style: const TextStyle(fontSize: 16),
              ),
              subtitle: _downloadProgress != 0
                  ? Text(
                      'Downloaded - $_downloadProgress %',
                      style: const TextStyle(color: Colors.blue),
                    )
                  : const Text('Not Downloaded'),
              trailing: IconButton(
                  onPressed: () {
                      downloadFile(widget.data['url']!, widget.data['title']!);
                  },
                  icon: isDownloading
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.download)),
            ),
             LinearProgressIndicator(
              minHeight: 1,
              value: percentate,
            )
          ],
        ),
      ),
    );
  }
}
