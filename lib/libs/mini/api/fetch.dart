import 'package:dio/dio.dart';
import './status.dart';

Future<dynamic> fetch(url) {
  Dio dio = Dio();
  dio.options.connectTimeout = 5000;
  return dio.get(url, options: Options(
    headers: {
      'user-agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1'
    },
  )).then((Response data) {
    return success(data);
  });
}