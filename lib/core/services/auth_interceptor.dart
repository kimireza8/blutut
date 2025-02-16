import 'package:dio/dio.dart';

import '../constants/constant.dart';

class AuthInterceptor extends Interceptor {
  final String baseUrl = Constant.baseUrl;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var defaultHeaders = {
      'Accept': 'application/json, text/javascript, */*; q=0.01',
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
    };

    options.headers.addAll(defaultHeaders);

    if (options.path == '$baseUrl${Constant.loginEndpoint}') {
      options.headers.addAll({
        'Origin': baseUrl,
        'Referer': '$baseUrl/index.php/auth/',
      });
    }

    super.onRequest(options, handler);
  }
}
