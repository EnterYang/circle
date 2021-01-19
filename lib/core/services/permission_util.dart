import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    print('----------------$status');
//    Map<Permission, PermissionStatus> statuses = await [
//      Permission.microphone,
////      Permission.storage,
//    ].request();
//    print(statuses[Permission.location]);
  }
}