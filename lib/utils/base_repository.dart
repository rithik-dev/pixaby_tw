import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

mixin BaseRepository {
  @protected
  Dio get dio => _dio;

  static final _dio = Dio();
}
