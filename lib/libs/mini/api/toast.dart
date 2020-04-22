import 'dart:convert';
import 'package:tf_toast/Toast.dart';

show (context, dynamic message, int duration) {
  Toast.show(context, title: jsonEncode(message), duration: duration / 1000);
}

hide () {
  Toast.dismiss();
}