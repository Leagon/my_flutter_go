// custom
import 'package:my_flutter_go/data_base/provider.dart';

// 3rd
import 'package:sqflite/sqflite.dart';


class SQLBase {
  Database db;
  final String table = '';
  var query;

  SQLBase(this.db) {
    query = db.query;
  }
}

class DataManage extends SQLBase {
  final String tableName;

  DataManage.setTable(String name) : tableName = name, super(Provider.db);

  Future<List> get() async {
    return await query(tableName);
  }  

  String getTableName() {
    return tableName;
  }

  Future<int> delete(String value, String key) async {
    return await db.delete(tableName, where: "$key = ?", whereArgs: [value]);
  }

  Future<int> deleteAll() async {
    return await db.delete(tableName);
  }

  Future<Map<String, dynamic>> insert(Map<String, dynamic> json) async {
    var id = await this.db.insert(tableName, json);
    json['id'] = id;
    return json;
  }

  Future<List> getByCondition({Map<dynamic, dynamic> conditions}) async {
    return await search(conditions: conditions, mods: 'And');
  }

  ///
  /// 搜索
  /// @param Object condition
  /// @mods [And, Or] default is Or
  /// search({'name': "hanxu', 'id': 1};
  ///
  Future<List> search({Map<String, dynamic> conditions, String mods = 'Or'}) async {
    if (conditions == null || conditions.isEmpty) {
      return this.get();
    }
    String stringConditions = '';
    int index = 0;
    conditions.forEach((key, value) {
      if (value == null) {
        return;
      }

      if (value.runtimeType == String) {
        stringConditions = '$stringConditions $key like "%$value%"';
      }
      if (value.runtimeType == int) {
        stringConditions = '$stringConditions $key = "%$value%"';
      }

      if (index >= 0 && index < conditions.length - 1) {
        stringConditions = '$stringConditions $mods';
      }
      index++;
    });

    print("this is string condition for sql > $stringConditions");
    return await this.query(tableName, where: stringConditions);
  }
}