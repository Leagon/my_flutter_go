
// os
import 'dart:async' show Future;

// custom
import 'package:my_flutter_go/model/user_info.dart';
import 'package:my_flutter_go/network/adapter.dart';
import 'package:my_flutter_go/network/api.dart';

// 3rd


class Network {
  // 登录获取用户信息
  static Future doLogin(Map<String, String> params) async {
    var response = await Adapter.post(Api.DO_LOGIN, params);
    try {
      UserInformation user = UserInformation.fromJson(response['data']);
      return user;
    } catch (error) {
      return response['message'];
    }
  }
}