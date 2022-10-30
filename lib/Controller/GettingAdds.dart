
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'all_adds_id.dart';

class get_ads extends ChangeNotifier{

  // banner at home page
   late BannerAd homepage_Banner;
   bool is_homepage_banner_Ready = false;

   create_homepage_banner_ad(){
    print("get_banner_add called");
    homepage_Banner= BannerAd(
      // Change Banner Size According to Ur Need
       size: AdSize.largeBanner,
        adUnitId: All_Add_Ids.bannerAdUnitId,
        listener: BannerAdListener(
            onAdLoaded: (_) {
          print("Successfully Load A Banner Ad");
          is_homepage_banner_Ready = true;
          notifyListeners();
            },
            onAdFailedToLoad: (ad, LoadAdError error) {
          print("Failed to Load A Banner Ad = ${error}");
          is_homepage_banner_Ready = false;
          notifyListeners();
          ad.dispose();
        }),
        request: AdRequest()
    );
     homepage_Banner.load();
  }
   //Loading home page banner
   homepage_banner_load(){
     homepage_Banner.load();
     // notifyListeners();
   }

   //banner at DisplayChapters screen
   late BannerAd chapter_banner;
   bool is_chapter_banner_Ready = false;

   creater_chapter_banner_ad(){
     print("get_banner_add called");
     chapter_banner= BannerAd(
       // Change Banner Size According to Ur Need
         size: AdSize.largeBanner,
         adUnitId: All_Add_Ids.bannerAdUnitId,
         listener: BannerAdListener(
             onAdLoaded: (_) {
               print("Successfully Load A Banner Ad");
               is_chapter_banner_Ready = true;

             },
             onAdFailedToLoad: (ad, LoadAdError error) {
               print("Failed to Load A Banner Ad = ${error}");
               is_chapter_banner_Ready = false;
               ad.dispose();
             }),
         request: AdRequest()
     );
   }

   chapter_banner_load(){
     chapter_banner.load();
     // notifyListeners();
   }


   //Banner at display images screen
   late BannerAd images_banner;
   bool is_images_banner_Ready = false;

   create_images_banner_ad(){
     print("get_banner_add called");
     images_banner= BannerAd(
       // Change Banner Size According to Ur Need
         size: AdSize.largeBanner,
         adUnitId: All_Add_Ids.bannerAdUnitId,
         listener: BannerAdListener(
             onAdLoaded: (_) {
               print("Successfully Load A Banner Ad");
               is_images_banner_Ready = true;

             },
             onAdFailedToLoad: (ad, LoadAdError error) {
               print("Failed to Load A Banner Ad = ${error}");
               is_images_banner_Ready = false;
               ad.dispose();
             }),
         request: AdRequest()
     );
   }

   images_banner_load(){
     images_banner.load();
     // notifyListeners();
   }




  //  BannerAd return_banner_ad(){
  //    bannerAd.dispose();
  //    isBannerAdReady = false;
  //   return bannerAd;
  //   notifyListeners();
  // }

   static final AdRequest request = AdRequest(
     keywords: <String>['foo', 'bar'],
     contentUrl: 'http://foo.com/bar.html',
     nonPersonalizedAds: true,
   );

   InterstitialAd? interstitialStartAd;
   InterstitialAd? interstitialAlbumAd;
   InterstitialAd? interstitialEditorAd;
   InterstitialAd? interstitialBackAd;
   int _numInterstitialLoadAttempts = 0;
   int maxFailedLoadAttempts = 3;

   void createInterstitialStartAd() {
     InterstitialAd.load(
         adUnitId: All_Add_Ids.interstitialStartAdUnitId,
         request: request,
         adLoadCallback: InterstitialAdLoadCallback(
           onAdLoaded: (InterstitialAd ad) {
             print('\n $ad loaded');
             interstitialStartAd = ad;
             _numInterstitialLoadAttempts = 0;
             interstitialStartAd!.setImmersiveMode(true);
           },
           onAdFailedToLoad: (LoadAdError error) {
             print('\nInterstitialAd failed to load: $error.');
             _numInterstitialLoadAttempts += 1;
             interstitialStartAd = null;
             if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
               createInterstitialStartAd();
             }
           },
         ));
   }
   void createInterstitialAlbumAd() {
     InterstitialAd.load(
         adUnitId: All_Add_Ids.interstitialAlbumAdUnitId,
         request: request,
         adLoadCallback: InterstitialAdLoadCallback(
           onAdLoaded: (InterstitialAd ad) {
             print('\n $ad loaded');
             interstitialAlbumAd = ad;
             _numInterstitialLoadAttempts = 0;
             interstitialAlbumAd!.setImmersiveMode(true);
           },
           onAdFailedToLoad: (LoadAdError error) {
             print('\nInterstitialAd failed to load: $error.');
             _numInterstitialLoadAttempts += 1;
             interstitialAlbumAd = null;
             if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {

               createInterstitialAlbumAd();

             }
           },
         ));
   }
   void createInterstitialEditorAd() {
     InterstitialAd.load(
         adUnitId: All_Add_Ids.interstitialEditorAdUnitId,
         request: request,
         adLoadCallback: InterstitialAdLoadCallback(
           onAdLoaded: (InterstitialAd ad) {
             print('\n $ad loaded');
             interstitialEditorAd = ad;
             _numInterstitialLoadAttempts = 0;
             interstitialEditorAd!.setImmersiveMode(true);
           },
           onAdFailedToLoad: (LoadAdError error) {
             print('\nInterstitialAd failed to load: $error.');
             _numInterstitialLoadAttempts += 1;
             interstitialEditorAd = null;
             if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {

               createInterstitialEditorAd();

             }
           },
         ));
   }
   void createInterstitialBackAd() {
     InterstitialAd.load(
         adUnitId: All_Add_Ids.interstitialBackAdID,
         request: request,
         adLoadCallback: InterstitialAdLoadCallback(
           onAdLoaded: (InterstitialAd ad) {
             print('\n $ad loaded');
             interstitialBackAd = ad;
             _numInterstitialLoadAttempts = 0;
             interstitialBackAd!.setImmersiveMode(true);
           },
           onAdFailedToLoad: (LoadAdError error) {
             print('\nInterstitialAd failed to load: $error.');
             _numInterstitialLoadAttempts += 1;
             interstitialBackAd = null;
             if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {

               createInterstitialBackAd();

             }
           },
         ));
   }



   void showInterstitialStartEndAd() {
     if (interstitialStartAd == null) {
       print('\nWarning: attempt to show interstitial before loaded.');
       return;
     }
     interstitialStartAd!.fullScreenContentCallback = FullScreenContentCallback(
       onAdShowedFullScreenContent: (InterstitialAd ad) =>
           print('\nad onAdShowedFullScreenContent.'),
       onAdDismissedFullScreenContent: (InterstitialAd ad) {
         print('$ad onAdDismissedFullScreenContent.');
         ad.dispose();
         createInterstitialStartAd();
       },
       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
         print('$ad onAdFailedToShowFullScreenContent: $error');
         ad.dispose();
         createInterstitialStartAd();
       },
     );
     interstitialStartAd!.show();
     interstitialStartAd = null;
   }



   void showInterstitialAlbumAd() {
     if (interstitialAlbumAd == null) {
       print('\nWarning: attempt to show interstitial before loaded.');
       return;
     }
     interstitialAlbumAd!.fullScreenContentCallback = FullScreenContentCallback(
       onAdShowedFullScreenContent: (InterstitialAd ad) =>
           print('\nad onAdShowedFullScreenContent.'),
       onAdDismissedFullScreenContent: (InterstitialAd ad) {
         print('$ad onAdDismissedFullScreenContent.');
         ad.dispose();
         createInterstitialAlbumAd();
       },
       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
         print('$ad onAdFailedToShowFullScreenContent: $error');
         ad.dispose();
         createInterstitialAlbumAd();
       },
     );
     interstitialAlbumAd!.show();
     interstitialAlbumAd = null;
   }
   void showInterstitialEditorAd() {
     if (interstitialEditorAd == null) {
       print('\nWarning: attempt to show interstitial before loaded.');
       return;
     }
     interstitialEditorAd!.fullScreenContentCallback = FullScreenContentCallback(
       onAdShowedFullScreenContent: (InterstitialAd ad) =>
           print('\nad onAdShowedFullScreenContent.'),
       onAdDismissedFullScreenContent: (InterstitialAd ad) {
         print('$ad onAdDismissedFullScreenContent.');
         ad.dispose();
         createInterstitialAlbumAd();
       },
       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
         print('$ad onAdFailedToShowFullScreenContent: $error');
         ad.dispose();
         createInterstitialAlbumAd();
       },
     );
     interstitialEditorAd!.show();
     interstitialEditorAd = null;
   }
   Future<bool> showBackAd() async {

     if (interstitialBackAd == null) {
       print('\nWarning: attempt to show interstitial before loaded.');
       //return;
     }
     interstitialBackAd!.fullScreenContentCallback = FullScreenContentCallback(
       onAdShowedFullScreenContent: (InterstitialAd ad) =>
           print('\nad onAdShowedFullScreenContent.'),
       onAdDismissedFullScreenContent: (InterstitialAd ad) {
         print('$ad onAdDismissedFullScreenContent.');
         ad.dispose();
         createInterstitialBackAd();
       },
       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
         print('$ad onAdFailedToShowFullScreenContent: $error');
         ad.dispose();
         createInterstitialBackAd();
       },
     );
     interstitialBackAd!.show();
     interstitialBackAd = null;



   return Future.value(true);
   }

}