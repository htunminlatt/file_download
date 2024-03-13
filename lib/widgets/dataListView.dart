import 'dart:io';
import 'package:file_download/models/vos/dataVo.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class DataListView extends StatefulWidget {
  DataListView({super.key, required this.data});
  final Map<String, String> data;

  @override
  State<DataListView> createState() => _DataListViewState();
}

class _DataListViewState extends State<DataListView> {
  bool isDownloading = false;
  bool isDownloadFinish = false;
  int _downloadProgress = 0;
  double percentate = 0;
  CancelToken? _cancelToken;
  late Directory _externalDir;

  ///file download
  void downloadFile(String url, String filename, String id) async {
    setState(() {
      isDownloading = !isDownloading;
    });

    Directory? directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    }

    String saveFile = '${directory?.path}/$filename.pdf';
    File file = File(saveFile);
    var dio = Dio();
    String fileUrl = url;
    dio.options.headers['Content-Type'] = 'application/json';
    try {
      dio.download(fileUrl, file.path,
          cancelToken: _cancelToken,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              }), onReceiveProgress: (received, total) {
        setState(() {
          _downloadProgress = (((received / total) * 100).toInt());
          percentate = _downloadProgress / 100;
          if (_downloadProgress == 100) {
            isDownloading = false;
            isDownloadFinish = true;

             ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Downloaded Success!')));
          }
        });
      });

      dataList[int.parse(id)]['downloadurl'] = file.path;

    } catch (e) {
      print(e.toString());
    }
  }

//pause download
  // pauseDownload() {
  //   _cancelToken?.cancel("Download paused");
  // }

  // //resume download
  // resumeDownload(String url, String filename) {
  //   setState(() {
  //     _cancelToken = CancelToken();
  //     downloadFile(url, filename);
  //   });
  // }

//fetching download file
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
    setState(() {
    });

    for (var element in files) {
      String fileString = element.path.split('/').last;

     String text = fileString.split(RegExp(r"(\.+)"))[0];

     if(text == widget.data['title']){
      setState(() {
        isDownloadFinish = true;
      });
     }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getExternalStorageDirectory();
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
                trailing: InkWell(
                  onTap: () {
                    if (_downloadProgress == 100 || isDownloadFinish) {
                      //
                    } else {
                      downloadFile(widget.data['url']!, widget.data['title']!,
                          widget.data['index']!);
                    }
                  },
                  child: isDownloading
                      ? const Icon(Icons.pause)
                      : isDownloadFinish
                          ? const Icon(
                              Icons.download_done,
                              color: Colors.blue,
                            )
                          : const Icon(Icons.download),
                )),
            LinearProgressIndicator(
              minHeight: 1,
              value: isDownloadFinish ? 1 : percentate,
            )
          ],
        ),
      ),
    );
  }
}
