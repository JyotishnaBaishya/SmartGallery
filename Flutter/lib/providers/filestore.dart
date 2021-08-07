import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<Map<String, dynamic>> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      Map<String, dynamic> jsondata = json.decode(contents);
      return jsondata;
    } catch (e) {
      // If encountering an error, return 0
      Map<String, dynamic> jsondata = json.decode('{"null":"OK"}');

      return jsondata;
    }
  }

  Future<void> writeCounter(String x) async {
    final file = await _localFile;

    Map<String, dynamic> cont = await readCounter();
    cont[x] = "OK";
    file.writeAsString(jsonEncode(cont));
  }
}
