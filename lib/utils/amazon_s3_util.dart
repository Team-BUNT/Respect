import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:aws_common/vm.dart';

class AmazonS3Util {
  Future<void> uploadImage({required File image, required String name}) async {
    final awsFile = AWSFilePlatform.fromFile(image);
    try {
      await Amplify.Storage.uploadFile(
        localFile: awsFile,
        key: name,
      ).result;
    } on StorageException catch (e) {
      safePrint('Error uploading file: ${e.message}');
      rethrow;
    }
  }
}