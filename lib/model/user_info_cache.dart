
// custom
import 'package:my_flutter_go/data_base/data_manage.dart';

abstract class UserInfoCahce {
  String get username;
  String get password;
}

class UserInfo implements UserInfoCahce {

  String username;
  String password;

  UserInfo({this.username, this.password});
  
  factory UserInfo.fromJson(Map json) {
    return UserInfo(username: json['username'], password: json['password']);
  }

  Object toJson() {
    return {'username': username, 'password': password};
  }

}
  
class UserInfoController {
  final String table = 'userInfo';

  DataManage manage;

  UserInfoController() {
    manage = DataManage.setTable(table);
  }

  Future insert(UserInfo userInfo) {
    var r = manage.insert({'username': userInfo.username, 'password': userInfo.password});
    print("$r");
    return r;
  }

  Future<List<UserInfo>> getAllInfo() async {
    List list = await manage.getByCondition();
    List<UserInfo> resultList = [];
    list.forEach((item) {
      print(item);
      resultList.add(UserInfo.fromJson(item));
    });
    return resultList;
  }

  Future deleteAll() async {
    return await manage.deleteAll();
  }
}

