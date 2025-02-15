import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Request Contacts Permission
  static Future<bool> requestContactsPermission() async {
    var status = await Permission.contacts.request();
    return status.isGranted;
  }

  // Request All Necessary Permissions
  static Future<void> requestAllPermissions() async {
    await [
      Permission.camera,
      Permission.storage,
      Permission.contacts,
    ].request();
  }
}