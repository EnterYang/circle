import 'package:sqflite/sqlite_api.dart';
import 'package:circle/core/database/base_db_provider.dart';

class FileUrlDbProvider extends BaseDbProvider{
  ///表名
  final String name = 'FileUrl';

  final String columnId="id";
  final String columnFileUrl="url";


  FileUrlDbProvider();

  @override
  tableName() {
    return name;
  }

  @override
  createTableString() {
    return '''
        create table $name (
        $columnId integer primary key,
        $columnFileUrl text not null)
      ''';
  }

  ///查询数据库
  Future _getFileUrlProvider(Database db, int id) async {
    List<Map<String, dynamic>> maps = await db.rawQuery("select * from $name where $columnId = $id");
    return maps;
  }

  ///插入到数据库
  Future insert(int fileId, String fileUrl) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await _getFileUrlProvider(db, fileId);
    if (maps != null && maps.length > 0) {
      ///删除数据
      await db.delete(name, where: "$columnId = ?", whereArgs: [fileId]);
    }
    int res = await db.rawInsert("insert into $name ($columnId,$columnFileUrl) values (?,?)",[fileId,fileUrl]);
    return res;
  }

  ///更新数据库
  Future<void> update(int fileId, String fileUrl) async {
    Database database = await getDataBase();
    await database.rawUpdate(
        "update $name set $columnFileUrl = ? where $columnId= ?",[fileUrl,fileId]);
  }

  ///更新数据库 如果没有则插入
  Future<void> updateOrInsert(int fileId, String fileUrl) async {
    String url = await getFileUrl(fileId);
    if (url != null) {
      if(fileUrl != url) await update(fileId, fileUrl);
    }else {
      await insert(fileId, fileUrl);
    }
  }

  ///获取事件数据
  Future<String> getFileUrl(int id) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps  = await _getFileUrlProvider(db, id);
    if (maps != null && maps.length > 0) {
      return maps[0]['url'];
    }
    return null;
  }
}