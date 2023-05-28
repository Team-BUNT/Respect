import 'dart:io';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';

class KakaotalkSharingUtil {
  bool isKakaoAvailable = false;

  KakaotalkSharingUtil() {
    _loadKakaoAvailable();
  }

  Future<void> _loadKakaoAvailable() async {
    isKakaoAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();
  }

  Future<void> shareToKakaotalk({
    required File image,
    required String name,
  }) async {
    int templateId = 93547;

    try {
      ImageUploadResult imageUploadResult =
          await ShareClient.instance.uploadImage(image: image);

      if (isKakaoAvailable) {
        try {
          Uri uri = await ShareClient.instance.shareCustom(
            templateId: templateId,
            templateArgs: {
              'THU': imageUploadResult.infos.original.url,
              'NAME': name,
            },
          );
          await ShareClient.instance.launchKakaoTalk(uri);
        } catch (error) {
          // ignore: avoid_print
          print('카카오톡 공유 실패 $error');
        }
      } else {
        try {
          Uri shareUrl = await WebSharerClient.instance.makeCustomUrl(
            templateId: templateId,
            templateArgs: {
              'THU': imageUploadResult.infos.original.url,
              'NAME': name,
            },
          );
          await launchBrowserTab(shareUrl);
        } catch (error) {
          // ignore: avoid_print
          print('카카오톡 공유 실패 $error');
        }
      }
    } catch (error) {
      // ignore: avoid_print
      print('이미지 업로드 실패 $error');
    }
  }
}
