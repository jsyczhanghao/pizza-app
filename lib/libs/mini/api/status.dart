Map success(dynamic data) {
  return {
    'status': 1,
    'data': data,
  };
}

Map error(String err) {
  return {
    'status': 0,
    'err': err,
  };
}