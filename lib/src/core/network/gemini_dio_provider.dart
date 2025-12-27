import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/env.dart';

final geminiDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://generativelanguage.googleapis.com/v1',
      queryParameters: {'key': Env.geminiKey},
      headers: {'Content-Type': 'application/json'},
    ),
  );
});
