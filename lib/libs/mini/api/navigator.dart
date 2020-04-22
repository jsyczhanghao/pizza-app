import 'package:flutter/material.dart';
import '../page.dart';

push(BuildContext context, String id, String page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MiniPage(id: id, page: page)));
}