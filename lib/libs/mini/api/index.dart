import './toast.dart' as toast;
import './fetch.dart';
import './navigator.dart' as navigator;
import './system.dart' as system;
import '../model.dart';

Function(String id, CallModel model) apiCall;

Future<dynamic> call(String id, CallModel model) {
  switch (model.type) {
    case 'toast.show':
      return toast.show(model.state.context, model.args['message'], model.args['duration']);
      break;

    case 'toast.hide':
      return toast.hide();

    case 'fetch':
      return fetch(model.args['url']);

    case 'navigator.push':
      return navigator.push(model.state.context, id, model.args);

    case 'system.config':
      return system.config(model.state, model.args);

    default: 
      if (apiCall != null) return apiCall(id, model);
      return null;
  }
}

inject (Function(String id, CallModel model) fn) {
  apiCall = fn;
}

