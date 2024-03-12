import 'dart:io';
import 'dart:isolate';
import 'package:http/http.dart' as http;
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
  Dio? _dio;
  CancelToken? _cancelToken;
  double _downloadProgress = 0.0;

  Future<void> _startDownload(String url, String fileName) async {
    setState(() {
      isDownloading = !isDownloading;
    });

    final savePath = await getTemporaryDirectory();
    final file = File('$savePath/$fileName');
    try {
      final response = await _dio?.download(
        url,
        file.path,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
           if (_cancelToken!.isCancelled) return;
          setState(() {
            _downloadProgress = received / total;

            print('........$_downloadProgress');
          });
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Download Complete: ${response?.data}'),
      ));
    } catch (e) {
      print('Download Error: $e');
    }
  }

  void _pauseDownload() {
    _cancelToken!.cancel('Download paused');
  }

  void _resumeDownload(String url, String fileName) {
    _cancelToken = CancelToken();
    _startDownload(url, fileName);
  }

  void _stopDownload() {
    _cancelToken!.cancel('Download stopped');
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
              subtitle: _downloadProgress != 0.0
                  ? Text('Downloaded - $_downloadProgress %')
                  : const Text('Not Downloaded'),
              trailing: IconButton(
                  onPressed: () {
                    _startDownload(widget.data['url']!, widget.data['title']!);
                  },
                  icon: isDownloading
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.download)),
            ),
            // const LinearProgressIndicator(
            //   backgroundColor: Colors.amber,
            //   minHeight: 1,
            // )
          ],
        ),
      ),
    );
  }
}
