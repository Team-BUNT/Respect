import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:aws_common/vm.dart';

class AmazonS3Util {
  Future<String> uploadImage({required File image, required String name}) async {
    final awsFile = AWSFilePlatform.fromFile(image);
    try {
      final uploadResult = await Amplify.Storage.uploadFile(
        localFile: awsFile,
        key: name,
      ).result;
      return 'https://respect332e182126fd429eb476f3e164260ab731058-dev.s3.ap-northeast-2.amazonaws.com/public/${uploadResult.uploadedItem.key}';
    } on StorageException catch (e) {
      safePrint('Error uploading file: ${e.message}');
      rethrow;
    }
  }
}