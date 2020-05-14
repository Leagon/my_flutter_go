
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';


Map<String, String> headers = {
  'accept-language': 'zh-cn',
  'content-type': 'application/json',
};

var dio = new Dio(BaseOptions(connectTimeout: 30000, headers: headers));

class Adapter {
  static Future get(String url, [Map<String, String> params]) async {
    var response;

    // 设置代理 便于本地 charles 抓包
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.findProxy = (uri) {
    //     return "PROXY 30.10.24.79:8889";
    //   };
    // };

    Directory documentsDir = await getApplicationDocumentsDirectory();
    String documentsPath = documentsDir.path;
    var dir = new Directory("$documentsPath/cookies");
    await dir.create();
    if (params != null) {
      response = await dio.get(url, queryParameters: params);
    } else {
      response = await dio.get(url);
    }

    return response.data;
  }

    static Future post(String url, Map<String, dynamic> params) async {

    // // 设置代理 便于本地 charles 抓包
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.findProxy = (uri) {
    //     return "PROXY 30.10.24.79:8889";
    //   };
    // };
    
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String documentsPath = documentsDir.path;
    var dir = new Directory("$documentsPath/cookies");
    await dir.create();
    // dio.interceptors.add(CookieManager(PersistCookieJar(dir: dir.path)));
    var response = await dio.post(url, data: params);
    return response.data;
  }
}