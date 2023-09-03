import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:aws_common/vm.dart';

class AmazonS3Util {
  static String eventPath = "event/";

  static Future<void> uploadImage(
      {required File image, required String eventID}) async {
    final awsFile = AWSFilePlatform.fromFile(image);
    final String key = "$eventPath$eventID/poster.png";
    try {
      await Amplify.Storage.uploadFile(
        localFile: awsFile,
        key: key,
      ).result;
    } on StorageException catch (e) {
      safePrint('Error uploading file: ${e.message}');
      rethrow;
    }
  }
}
