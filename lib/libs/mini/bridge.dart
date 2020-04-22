import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:native2js/native2js.dart';
import './helper.dart';
import './api/index.dart' as api;
import './state.dart';
import './model.dart';

class MiniBridge {
  static Map<String, MiniBridge> instances = Map();
  static String exitRoute = 'home';

  final String id;
  String _root;
  JsEngine _jsEngine;
  List<MiniBridgeState> _links = [];

  MiniBridge(this.id) {
    instances[id] = this;
    _init();
  }

  Future<String> root() async {
    String _ = await Helper.root(id);
    return 'file://$_';
  }

  MiniBridgeState get _link {
    return _links.last;
  }

  _init() async {
    _root = await Helper.root(id);
    _jsEngine = JsEngine(
      injectJs: '$_root/js/backend.js',
    )..register('jsPostMessage2native', _onReceiveBackendMessage);
  }

  _onReceiveBackendMessage(data) {
    if (data['type'] != 'API_CALL') {
      post2client(data);
    } else {
      Map req = jsonDecode(data['data']);

      if (req['method'].toString().indexOf('dom.') == -1) {
        dynamic res = api.call(
          id,
          CallModel(
            type: req['method'],
            args: req['args'],
            state: _link,
          ),
        );

        post2backend({
          'id': 'nativeCallReturn',
          'type': data['id'],
          'data': jsonEncode(res == null ? {} : res),
        });
      } else {
        post2client(data);
      }
    }
  }

  _onReceiveClientMessage(List data) {
    post2backend(data[0]);
  }

  link(MiniBridgeState state) {
    _links.add(state);
    state.controller.addJavaScriptHandler(
      handlerName: 'jsPostMessage2native',
      callback: _onReceiveClientMessage,
    );
  }

  unlink() {
    _links.removeLast();
    if (_links.length == 0) {
      dispose();
    }
  }

  post2client(dynamic data) {
    _link.controller.evaluateJavascript(
      source: 'window.nativePostMessage2js(${jsonEncode(data)})',
    );
  }

  post2backend(dynamic data) {
    _jsEngine.evaluate('self.nativePostMessage2js(${jsonEncode(data)})');
  }

  dispose() {
    instances.remove(id);
    _jsEngine.dispose();
    print('js engine dispose');
  }

  exit() {
    Navigator.popUntil(_link.context, ModalRoute.withName(MiniBridge.exitRoute));
  }
}
