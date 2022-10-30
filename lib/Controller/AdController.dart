import 'dart:io';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:get/get.dart';
import 'package:zoomgrid/Controller/EditImageController.dart';

class AdController extends IAdIdManager{

  const AdController();
  @override
  AppAdIds? get admobAdIds => AppAdIds(
    appId: Platform.isAndroid
        ? 'ca-app-pub-6044006890313003~3141642500'
        : 'ca-app-pub-6044006890313003~2420425142',
    bannerId: Platform.isAndroid ? 'ca-app-pub-6044006890313003/4041475419':'ca-app-pub-6044006890313003/9205325342',
    //interstitialId:  Platform.isAndroid ? 'ca-app-pub-6044006890313003/2672553425':'ca-app-pub-6044006890313003/6196018623',
    //rewardedId: 'ca-app-pub-3940256099942544/5224354917',
  );


  @override
  AppAdIds? get unityAdIds => AppAdIds(
    appId: Platform.isAndroid ? '4374881' : '4374880',
    // bannerId: Platform.isAndroid ? 'Banner_Android' : 'Banner_iOS',
    // interstitialId:
    // Platform.isAndroid ? 'Interstitial_Android' : 'Interstitial_iOS',
    // rewardedId: Platform.isAndroid ? 'Rewarded_Android' : 'Rewarded_iOS',
  );

  @override
  AppAdIds? get appLovinAdIds => AppAdIds(
    appId:
    'LTVla0Ir4MFk1XkJtPoDUfB2qvtJTTFXrNTTf9ROZIQZUtWXBwAZPd4IgfzhqJA2QdhWnzUFo-Z-e6_Wb_z4zy',
    bannerId: Platform.isAndroid ? '162943e817ba1433' : '80c269494c0e45c2',
    interstitialId: '162943e817ba1433',
    rewardedId:
    Platform.isAndroid ? 'ffbed216d19efb09' : 'f4af3e10dd48ee4f',
  );

  @override
  AppAdIds? get fbAdIds => AppAdIds(
    appId: '1229739727786666',
    bannerId:
    Platform.isAndroid ? 'YOUR_PLACEMENT_ID' : 'YOUR_PLACEMENT_ID',
    interstitialId:
    Platform.isAndroid ? 'YOUR_PLACEMENT_ID' : 'YOUR_PLACEMENT_ID',
    rewardedId: 'YOUR_PLACEMENT_ID',
  );
}
