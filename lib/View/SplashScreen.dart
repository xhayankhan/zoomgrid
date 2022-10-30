import 'dart:async';
import 'dart:io';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/languages.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:zoomgrid/Controller/AdController.dart';
import 'package:zoomgrid/Controller/EditImageController.dart';
import 'package:zoomgrid/View/HomePage.dart';

import '../Controller/GettingAdds.dart';
import '../Controller/OpenAds.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ImageAndDocumentController documentController=Get.find();

  StreamSubscription? _streamSubscription;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  final supportedLanguages = [
    Languages.english,
    Languages.french,
    Languages.spanish,
    Languages.portuguese,
    Languages.chineseSimplified,
    Languages.arabic,
    Languages.urdu,

  ];
  var anim=true;
  bool isCon=false;

  @override
  void initState(){
    final applicationBloc = Provider.of<get_ads>(context, listen: false);
    documentController.getApis();
    //Show AppOpen Ad After 8 Seconds

    WidgetsBinding.instance.addPostFrameCallback(
          (_) => getads(),
    );
    appOpenAdManager.loadAd();
    super.initState();
  }
  getads() async {
    final applicationBloc = Provider.of<get_ads>(context, listen: false);
    applicationBloc.createInterstitialStartAd();
    applicationBloc.createInterstitialBackAd();
    applicationBloc.createInterstitialAlbumAd();
    applicationBloc.createInterstitialEditorAd();
    appOpenAdManager.loadAd();
    await applicationBloc.create_homepage_banner_ad();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<get_ads>(context);

    return Scaffold(

      body: Container(
        width: double.infinity,
        height:double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/background.png'),fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            children:[
              Container(
                  width: MediaQuery.of(context).size.width*1,
                 // height: MediaQuery.of(context).size.height*0.075,
                  height: 60,
                  child: EasyBannerAd(adSize: AdSize.fullBanner, adNetwork: AdNetwork.admob)),
              // Consumer<get_ads>(
              //   builder: (context, dataa, child) {
              //     return Container(
              //       height: MediaQuery
              //           .of(context)
              //           .size
              //           .height * 0.06,
              //       // height: get_ads.bannerAd.size.height.toDouble(),
              //       // color: Colors.blue,
              //       child:
              //       // Timer(Duration(seconds: 3), () {
              //       //   print("Yeah, this line is printed after 3 second");
              //       // });
              //
              //       // EasyBannerAd(
              //       //     adNetwork: AdNetwork.admob, adSize: AdSize.fullBanner),
              //
              //       dataa.is_homepage_banner_Ready == true
              //           ? AdWidget(ad: dataa.homepage_Banner)
              //           : Container(
              //         color: Colors.amber,
              //             child: const Center(
              //             child: Text(
              //               "Advertisement..",
              //               style: TextStyle(
              //                 color: Colors.black,
              //               ),
              //             )),
              //           ),
              //     );
              //   },
              // ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.14,
                    ),
                    Text('Version 2.1.7',style: GoogleFonts.nunito(textStyle:TextStyle(color: Colors.black,)),),
             InkWell(onTap:(){ _openLanguagePickerDialog();},child: Image.asset('assets/translation.png',height: 35,width: 35,fit: BoxFit.fill,))


                  ],
                ),

              ),
              Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height*0.028,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height*0.068,
                                width: MediaQuery.of(context).size.width*0.7,

                                child: Image.asset('assets/zoomgrid.png',fit: BoxFit.fill,)),
                            Container(
                              height: MediaQuery.of(context).size.height*0.008,
                            ),
                            Container(
                                height: MediaQuery.of(context).size.height*0.068,
                                width: MediaQuery.of(context).size.width*0.7,

                                child: Image.asset('assets/PRO.png',fit: BoxFit.fill,)),

                            Container(
                                height: MediaQuery.of(context).size.height*0.21,
                                width: MediaQuery.of(context).size.width*0.8,

                                child: Image.asset('assets/logo.png',fit: BoxFit.fill,)),
                          ],
                        ),
                        FutureBuilder(
                          future: animation(),

                            builder: (context,data){
                          if(anim==false){
                            return Column(
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height*0.07,
                                ),
                                InkWell(
                                  onTap: ()async{
                                     isCon = await InternetPopup().checkInternet();
                                     if(isCon==true) {

                                       applicationBloc.showInterstitialStartEndAd();
                                        Get.to(()=>const HomePage());
                                     }
                                 else{
                                       InternetPopup().initializeCustomWidget(context: context, widget: Center(
                                         child: Container(
                                           decoration: BoxDecoration(
                                             color: Colors.lightBlue,
                                             borderRadius: BorderRadius.circular(20)
                                           ),
                                           height: MediaQuery.of(context).size.height*0.3,

                                           width: MediaQuery.of(context).size.width*0.82,
                                           child: Padding(
                                             padding: const EdgeInsets.all(15.0),
                                             child: Column(
                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                               children: [
                                                 SizedBox(child: Text('Note!!',style: TextStyle(fontSize: 20),),),
                                                 Text('Do you want to continue without internet connection?\n(Application may lose some of its capabilities due to no internet)',style: TextStyle(fontSize: 18),),
                                                 Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                   children: [
                                                     // InkWell(onTap: (){exit(0);},child: Text('No',style: TextStyle(fontSize: 16),)),
                                                     // InkWell(onTap: (){Navigator.pop(context);Get.to(()=>HomePage());},child: Text('Yes',style: TextStyle(fontSize: 16),))
                                                     ElevatedButton(onPressed: (){exit(0);}, child: Text('No'),style: ButtonStyle(
                                                       backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                                     ),),
                                                     ElevatedButton(onPressed: (){Navigator.pop(context);Get.to(()=>HomePage());}, child: Text('Yes'),style: ButtonStyle(
                                                       backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                                     ),),
                                                   ],
                                                 )
                                               ],
                                             ),
                                           ),
                                         ),
                                       ));
                                   print('no internet');
                                     }
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                          height: MediaQuery.of(context).size.width*0.15,
                                          width: MediaQuery.of(context).size.width*0.15,

                                          child: Image.asset('assets/Start.png',fit: BoxFit.fill,)),
                                      Text('Start'.tr,style: GoogleFonts.nunito(textStyle:TextStyle(color: Colors.white,fontSize: 33)),),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                          else{
                            return Container(
                              height: MediaQuery.of(context).size.height*0.2,
                              child: Center(
                                child: Lottie.asset('assets/loading_line.json'),
                              ),
                            );
                          }
                        }
                        )
                      ],
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.1,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    InkWell(onTap:(){      final Uri url = Uri.parse('https://sites.google.com/view/zoomgridpp/home');

                    documentController.launchUrl1(url);},child: Image.asset('assets/privacy.png',height: 40,width: 40,fit: BoxFit.fill,)),
                    Container(
                      width: MediaQuery.of(context).size.width*0.2,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.2,
                    ),
                  ],
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
    Future animation()async{
     InternetPopup().initialize(context: context,onTapPop: true);
     var ad=   EasyAds.instance.loadAd();
      documentController.fetchNewMedia();
    var fut=  Future.delayed(const Duration(seconds: 6), () async {


       //await documentController.fetchNewMedia();

       anim=false;
       print("Timeout");
     });
///if(fun!=null){
      return fut;
    }
  void _openLanguagePickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.pink),
        child: LanguagePickerDialog(
            languages: supportedLanguages,
            titlePadding: const EdgeInsets.all(8.0),
            title: const Text('Select your language'),
            onValuePicked: (Language language) => setState(() {
              //Constants.currentlang = language.isoCode;
              Get.updateLocale(Locale(language.isoCode));
            }),
            itemBuilder: _buildDialogItem)),
  );
  Widget _buildDialogItem(Language language) => Row(
    children: <Widget>[
      Text(language.name),
      const SizedBox(width: 8.0),
      //Flexible(child: Text("(${language.name})"))
    ],
  );
  // void openCupertinoLanguagePicker(BuildContext context) => showCupertinoModalPopup<void>(
  //     context: context,
  //     builder: (BuildContext context) {final languageBuilder = (language) => Text(language.name);
  //
  // //     return LanguagePickerDropdown(
  // //         itemBuilder: languageBuilder,
  // //           languages: supportedLanguages,
  // //           onValuePicked: (Language language) {
  // //
  // // setState((){
  // //         Get.updateLocale( Locale(language.isoCode));
  // //        });
  // //           });
  //       return  LanguagePickerCupertino(
  //           languages: supportedLanguages,
  //           onValuePicked: (Language language) {
  //            // setState((){
  //               Get.updateLocale( Locale(language.isoCode));
  //             //});
  //             print(language.isoCode);
  //           });
  //       });
  //
  // Widget buildCupertinoItem(Language language) => Row(
  //   children: <Widget>[
  //     Text("+${language.name}"),
  //     SizedBox(width: 8.0),
  //     Flexible(child: Text(language.name))
  //   ],
  // );
}
