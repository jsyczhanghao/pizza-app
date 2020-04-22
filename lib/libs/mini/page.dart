import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import './mini.dart';
import './bridge.dart';
import './state.dart';
import './icons.dart';

class MiniPage extends StatefulWidget {
  final String page;
  final String id;
  final String name;
  final String image;

  MiniPage({this.id, this.page, this.name, this.image});

  @override
  State<StatefulWidget> createState() {
    return _MiniPageState();
  }
}

class _MiniPageState extends MiniBridgeState<MiniPage> {
  MiniBridge bridge;
  String title = '';
  String url;
  List<double> color;
  InAppWebViewController controller;

  @override
  void initState() {
    super.initState();
    launch();
  }

  launch() async {
    if (widget.page != null) {
      bridge = Mini.instance(widget.id);
    } else {
      try {
        bridge = await Mini.bootstrap(widget.id);
      } catch (e) {
        Navigator.pop(context);
      }
    }

    String root = await bridge.root();

    setState(() {
      url =
          '$root/index.html?${widget.page == null ? 'pages/index/index' : widget.page}';
    });
  }

  @override
  void dispose() {
    if(bridge != null) {
      bridge.unlink();
    }
    
    super.dispose();
  }

  setConfigs(Map configs) {
    setState(() {
      title = configs['navigationBarTitleText'];
      color = configs['navigationBarColor'];
    });
  }

  Widget buildPage() {
    if (url == null) return Container();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.close), onPressed: () => bridge.exit(),)
        ],
      ),
      body: InAppWebView(
        initialUrl: url,
        initialOptions: InAppWebViewWidgetOptions(),
        onWebViewCreated: (InAppWebViewController controller) {
          this.controller = controller;
          bridge.link(this);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return url == null && widget.page == null ? _Loading(name: widget.name, image: widget.image) : buildPage();
  }
}

class _Loading extends StatelessWidget {
  final String image;
  final String name;

  _Loading({this.image, this.name}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            child: IconsWidget(),
          ),
          Container(
            color: Colors.white,
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 100),
            child: Column(
              children: <Widget>[
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  margin: EdgeInsets.only(bottom: 20),
                  child: CircleAvatar(backgroundImage: NetworkImage(image)),
                ),
                Text(
                  name,
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
