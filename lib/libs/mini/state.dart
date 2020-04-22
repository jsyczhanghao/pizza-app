import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

abstract class MiniBridgeState<T extends StatefulWidget> extends State<T> {
  InAppWebViewController controller;
  setConfigs(Map configs) {}
}