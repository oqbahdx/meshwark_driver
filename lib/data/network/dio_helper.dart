import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/constant.dart';

const String applicationJson = "application/json";
const String contentType = "content-type";
const String accept = "accept";
const String authorization = "authorization";
const String defaultLanguage = "language";

class DioHelper {
  static Dio? dio;

  static init() {
    Map<String, String> headers = {
      contentType: applicationJson,
      accept: applicationJson,
      authorization: "Bearer ${Constants.token}",
      defaultLanguage: "en"
    };
    dio = Dio(BaseOptions(
        baseUrl: Constants.baseUrl,
        headers: headers,
        receiveTimeout: const Duration(seconds: Constants.apiTimeOut),
        sendTimeout: const Duration(seconds: Constants.apiTimeOut)));
    dio?.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
    ));
  }

  static Future<Response?> getData(
      {required String endPoint, Map<String, dynamic>? query}) async {
    return await dio?.get(endPoint, queryParameters: query);
  }

  static Future<Response?> updateData(
      {required String endPoint, required Map<String, dynamic> data}) async {
    return await dio?.put(endPoint, data: data);
  }

  static Future<Response?> delete({
    required String endPoint,
  }) async {
    return await dio?.delete(endPoint);
  }

  static Future<Response?> postData(
      {required String endPoint, required Map<String, dynamic> data}) async {
    return await dio?.post(endPoint, data: data);
  }

  static Future<Response?> postDataWithImage(
      {required String endPoint, required FormData data}) async {
    return await dio?.post(endPoint, data: data);
  }

  static Future<Response?> updateDataWithImage(
      {required String endPoint, required FormData data}) async {
    return await dio?.put(endPoint, data: data);
  }
}
