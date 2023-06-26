import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
class PermissionHandler{
  Future <bool> requestFileAccessPermission() async {
    bool permissionStatus = false;
    PermissionStatus status =await Permission.storage.status;

    if (status.isGranted) {
      print('dfghjkl;');
      // Permission granted
      // Proceed with file access operations
      permissionStatus = true;
    }
    else if (status.isDenied) {
      // Permission denied
      await Permission.storage.request().then((value){
        if(value.isGranted){
          permissionStatus = true;
        }
        else{
          permissionStatus = false;
        }
      });
      // Show an alert or message informing the user
    }
    else if (status.isPermanentlyDenied) {
      permissionStatus = false;
      debugPrint('Permission permanently denied');
      // Show a dialog prompting the user to enable permission manually
    }
    return permissionStatus;
  }
}

