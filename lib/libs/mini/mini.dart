import 'dart:async';
import 'dart:io';
import './bridge.dart';
import './helper.dart';

class Mini {
  static const GITHUB_URL = 'https://github.com';

  static Future<MiniBridge> bootstrap(String id) async {
    await _download(id);
    return MiniBridge(id);
  }

  static MiniBridge instance(String id) {
    return MiniBridge.instances[id];
  }

  static Future<bool> _download(String id) async {
    String _ = await Helper.root(id);
    String zip = '$_.zip';

    File x = File(zip);

    //if (x.existsSync()) return true;
    await Helper.download('$GITHUB_URL/$id/archive/master.zip', zip);
    Helper.uncompress(zip);

    return true;
  }
}
