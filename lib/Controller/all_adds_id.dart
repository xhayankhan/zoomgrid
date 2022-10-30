import 'dart:io';

class All_Add_Ids {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2408614506049729/5855530943';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6044006890313003/9205325342';
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }


  static String get interstitialOpenAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5633762288203670/1928153903';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5633762288203670/5725026160';
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }


  static String get interstitialStartAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6044006890313003/2672553425';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6044006890313003/6196018623';
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }

  static String get interstitialAlbumAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6044006890313003/7672751828';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6044006890313003/2065201922';
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }
  static String get interstitialEditorAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6044006890313003/8940764098';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6044006890313003/5475879617';
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }
  static String get interstitialBackAdID {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6044006890313003/2611996835';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6044006890313003/2833404404';
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }

}