import './state.dart';

class CallModel {
  final String type;
  final dynamic args;
  final MiniBridgeState state;

  CallModel({this.type, this.args, this.state});
}