
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zoomgrid/Controller/AdController.dart';
import 'package:zoomgrid/View/HomePage.dart';
import 'package:zoomgrid/View/SplashScreen.dart';

import 'Binidng/bindings.dart';
import 'Constants/Constants.dart';
import 'Controller/GettingAdds.dart';
import 'Translations/Languages.dart';


const IAdIdManager adIdManager = AdController();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await MobileAds.instance.initialize()
      .then((initializationStatus) {

    initializationStatus.adapterStatuses.forEach((key, value) {
      debugPrint('Adapter status for $key: ${value.description}');
    });
  });
  await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: ['5DA7BDFCE2454D2BFAA2684F5D1CA485']));
  await EasyAds.instance.initialize(
    adIdManager,
    unityTestMode: true,
    adMobAdRequest: const AdRequest(),
    admobConfiguration: RequestConfiguration(testDeviceIds: [
      // '5DA7BDFCE2454D2BFAA2684F5D1CA485', // Mi Phone
      // '00008030-00163022226A802E',
    ]),
  );

  runApp( MultiProvider(
    providers: [
      // ChangeNotifierProvider(create: (_) => TimerInfo()),
      // ChangeNotifierProvider(create: (_) => DirectoryImage()),
      ChangeNotifierProvider(create: (_) => get_ads()),
      // ChangeNotifierProvider(create: (_) => SNC_Lists()),

    ],
    child: GetMaterialApp( home: const SplashScreen(),
      builder:EasyLoading.init(),

      debugShowCheckedModeBanner: false,
      translations: Languages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      theme: lightTheme,
      initialBinding: defaultBinding(),
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      defaultTransition: Transition.leftToRightWithFade,
    ),
  ));
}