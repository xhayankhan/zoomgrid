import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class loading extends StatefulWidget {
  const loading({Key? key}) : super(key: key);

  @override
  State<loading> createState() => _loadingState();
}

class _loadingState extends State<loading> {
  var toptextColor=Color(0xFF2980B9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height:double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/background.png'),fit: BoxFit.cover)
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Container(
                  width: MediaQuery.of(context).size.width*1,
                  height: MediaQuery.of(context).size.height*0.075,
                  child: EasyBannerAd(adSize: AdSize.fullBanner, adNetwork: AdNetwork.admob)),
              Container(
                child: Lottie.asset('assets/enchancementLoader.json',repeat: true,animate: true,frameRate: FrameRate(60)),
              ),
              Text('Getting Your Super Image !!!!'.tr,style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
