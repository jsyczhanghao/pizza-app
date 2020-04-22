import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';

class Helper {
  static String hash(String str) {
    var content = new Utf8Encoder().convert(str);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  static Future<String> root(String id) async {
    String local = hash(id);
    String root = (await getApplicationDocumentsDirectory()).path;
    return '$root/_mini_/$local';
  }

  static download(String url, String savePath) async {
    try {
      await Dio().download(url, savePath);
    } catch (e) {
      throw new Error();
    }
  }

  static String uncompress(String zip) {
    final bytes = File(zip).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);
    final _ = zip.replaceFirst(RegExp(r'\.zip$'), '');

    for (final file in archive) {
      List x = file.name.split('/');
      String filename = x.getRange(1, x.length).join('/');

      if (file.isFile) {
        final data = file.content as List<int>;
        File('$_/$filename')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('$_/$filename')..create(recursive: true);
      }
    }

    return _;
  }
}