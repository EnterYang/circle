import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:circle/core/database/base_db_provider.dart';
import 'dart:convert';
import 'model/user_info_simple.dart';

class UserInfoDbProvider extends BaseDbProvider{
  ///表名
  final String name = 'UserInfo';

  final String columnId="id";
  final String columnAvatarJsonString="avatar";
  final String columnUname="name";
  final String columnBio="bio";


  UserInfoDbProvider();

  @override
  tableName() {
    return name;
  }

  @override
  createTableString() {
    return '''
        create table $name (
        $columnId integer primary key,
        $columnUname text not null,
        $columnBio text,
        $columnAvatarJsonString text)
      ''';
  }

  ///查询数据库
  Future _getUserInfoProvider(Database db, int id) async {
    List<Map<String, dynamic>> maps =
    await db.rawQuery("select * from $name where $columnId = $id");
    return maps;
  }

  ///插入到数据库
  Future insert(User model) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await _getUserInfoProvider(db, model.id);
    if (maps != null && maps.length > 0) {
      ///删除数据
      await db.delete(name, where: "$columnId = ?", whereArgs: [model.id]);
    }
    return await db.rawInsert("insert into $name ($columnId,$columnAvatarJsonString,$columnUname,$columnBio) values (?,?,?,?)",[model.id,jsonEncode(model.avatar.toJson())
      ,model.name, model.bio]);
  }

  ///更新数据库
  Future<void> update(User model) async {
    Database database = await getDataBase();
    await database.rawUpdate(
        "update $name set $columnAvatarJsonString = ?,$columnUname = ?,$columnBio = ? where $columnId= ?",[jsonEncode(model.avatar.toJson()),model.name,model.bio,model.id]);
  }

  ///更新数据库 如果没有则插入
  Future<void> updateOrInsert(User model) async {
    UserInfoSimple user = await getUserInfoSimple(model.id);
    if (user != null) {
      if(model.name != user.name || model.avatar.url != user.avatar.url || model.bio != user.bio) await update(model);
    }else {
      await insert(model);
    }
  }

  ///获取事件数据
  Future<UserInfoSimple> getUserInfoSimple(int id) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps  = await _getUserInfoProvider(db, id);
    if (maps != null && maps.length > 0) {
      return UserInfoSimple.fromJson(maps[0]);
    }
    return null;
  }
}