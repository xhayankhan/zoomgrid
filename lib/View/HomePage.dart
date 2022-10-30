import 'dart:async';

import 'dart:io';

import 'dart:typed_data';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';


import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zoomgrid/Constants/Constants.dart';
import 'package:zoomgrid/Controller/EditImageController.dart';
import 'package:zoomgrid/View/SplashScreen.dart';

import 'package:zoomgrid/Widgets/GridViewOfGallery.dart';

import '../Constants/NavDrawer.dart';
import '../Controller/GettingAdds.dart';
import '../Controller/OpenAds.dart';
import 'AlbumPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with WidgetsBindingObserver {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
  ImageAndDocumentController documentController = Get.find();
  File? image1;
  var toptextColor=const Color(0xFF2980B9);
  bool adshown=false;
  int countpic=0;
  int countcam=0;
  String? imageUrl;
  StreamSubscription? _streamSubscription;
  XFile? _pickedFile;

  var gal;
  // CroppedFile? _croppedFile;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var pickedFile;
  ImagePicker imagePicker = ImagePicker();
  @override
  void initState() {

    super.initState();

    final applicationBloc = Provider.of<get_ads>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback(
          (_) => getads(),
    );



    WidgetsBinding.instance.addObserver(this);
    //documentController.fetchNewMedia();
   //documentController.permissionCheck();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    print("didChangeAppLifecycleState called");
    print("adshown = ${adshown} , countpic = ${countpic} , countcam = ${countcam}");
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }

    if (state == AppLifecycleState.resumed && isPaused&&countpic==1||countcam==1) {
      print("Resumed==========================");

      appOpenAdManager.showAdIfAvailable();
      // countpic=1;
      // countcam=1;
      isPaused = false;
      adshown=false;
    }
  }

  getads() async {
    final applicationBloc = Provider.of<get_ads>(context, listen: false);

    appOpenAdManager.loadAd();

  }
  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<get_ads>(context);

    return
      WillPopScope(

      onWillPop: () async{
        var ad=await applicationBloc.showBackAd();
      return ad;
      },
     child:
    Scaffold(
        drawer: NavDrawer(),

        key: scaffoldKey,
          body: Container(
            width: double.infinity,
            height:double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/background.png'),fit: BoxFit.cover)
            ),
            child: SafeArea(
              child: Column(
                children: [

                  Container(

                      width: MediaQuery.of(context).size.width*1,
                      height: MediaQuery.of(context).size.height*0.075,
                      child: const EasyBannerAd(adSize: AdSize.fullBanner, adNetwork: AdNetwork.admob)),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: (){scaffoldKey.currentState?.openDrawer();}, icon: Icon(Icons.list_outlined,size: 33,color: toptextColor,)),
                        Text('Import Picture'.tr,style: TextStyle(fontSize: 22,fontWeight:FontWeight.bold ,color: toptextColor),),
                        IconButton(onPressed: () async{
                           applicationBloc.showBackAd();

                          Get.off(()=>SplashScreen());

                        }, icon: Icon(Icons.arrow_back_ios,size: 28,color: toptextColor,))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OfflineBuilder(
                    connectivityBuilder: (
                    BuildContext context,
                    ConnectivityResult connectivity,
                    Widget child,
                    ) {
                    final connected = connectivity != ConnectivityResult.none;
                    return Stack(
                    children: [
                    child,
                    Positioned(
                    height: 50.0,
                    left: 0.0,
                    right: 0.0,
                    child: AnimatedContainer(
                    duration: const Duration(milliseconds: 2),
                    // color: connected ? const Color(0xFF00EE44) : const Color(0xFFEE4400),
                    child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 2),
                    child: connected
                    ? null
                        : Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height*1,
                            width: MediaQuery.of(context).size.width*1,

                            decoration: const BoxDecoration(
                              color: Colors.white,

                            ),
                      child: const Center(child: const Text('Internet not connected',style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),)),

                    ),
                        )
                    ),
                    ),
                    ),
                    ],
                    );
                    },
                      child:
                      Column(
                          children: [
                          SizedBox(

                                  height: MediaQuery.of(context).size.height * 0.61,
                                  child:   GetBuilder<ImageAndDocumentController>(
                                    init:ImageAndDocumentController(),
    builder: (context) {return GridGallery();})
                                ),

                            SizedBox(
                              height: MediaQuery.of(context).size.height*0.044,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12,right: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [


                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                         // adshown=true;
                                          Future.delayed(const Duration(seconds: 2)).then((value) =>  countpic++);
                                          pickedFile = await imagePicker.pickImage(
                                            source: ImageSource.gallery,
                                            imageQuality: picQuality,);

                                          image1 = File(pickedFile!.path);
                                          Uint8List uint8list = Uint8List.fromList(
                                              image1!.readAsBytesSync());

                                        setState((){documentController.selectionDialogue(context,uint8list,documentController.factor.value);});

                                        },
                                        child: Container(
                                          height: 52,
                                          width: 52,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(40),color: Colors.lightBlue,
                                           // border: Border.all(color: Colors.white,),
                                          ),
                                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                FontAwesomeIcons.image,color: Colors.white,
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text('Gallery'.tr,style: const TextStyle(color: Colors.white))
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height*0.002,
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                    //adshown=true;
                                          Future.delayed(const Duration(seconds: 2)).then((value) =>  countcam++);

                                          var pickedFile = await imagePicker.pickImage(
                                              source: ImageSource.camera,
                                              imageQuality: picQuality);

                                          setState(() {
                                            image1 = File(pickedFile!.path);
                                            Uint8List uint8list = Uint8List.fromList(
                                                image1!.readAsBytesSync());

                                            setState((){documentController.selectionDialogue(context,uint8list,documentController.factor.value);});
                                          });
                                        },
                                        child: Container(
                                          height: 52,
                                          width: 52,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(40),color: Colors.lightBlue,
                                            //border: Border.all(color: Colors.white,),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                FontAwesomeIcons.camera,
                                                color: Colors.white,
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text('Camera'.tr,style: const TextStyle(color: Colors.white),)
                                    ],
                                  ),  SizedBox(
                                    height: MediaQuery.of(context).size.height*0.002,
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {


                                          // if (EasyAds.instance.showAd(AdUnitType.interstitial,adNetwork: AdNetwork.admob)) {
                                          // // Canceling the last callback subscribed
                                          // _streamSubscription?.cancel();
                                          // // Listening to the callback from showInterstitialAd()
                                          // _streamSubscription =
                                          // EasyAds.instance.onEvent.listen((event) {
                                          // if (event.adUnitType == AdUnitType.interstitial &&
                                          // event.type == AdEventType.adDismissed) {
                                          // _streamSubscription?.cancel();
                                          // Get.to(()=>const ShowAlbum());
                                          // }
                                          // });}
                                           applicationBloc.showInterstitialAlbumAd();

                                          Get.to(()=>ShowAlbum(SAS: false,));

                                        },
                                        child: Container(
                                          height: 52,
                                          width: 52,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(40),color: Colors.lightBlue,
                                           // border: Border.all(color: Colors.white,),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                FontAwesomeIcons.images,color: Colors.white,
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height*0.002,
                                      ),
                                      Text('Album'.tr,style: const TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 8.0),
                            //   child: Obx(()=>
                            //       Container(
                            //         decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(20),
                            //             color:documentController.isLightTheme.value==false?blackPearl:darkCayan
                            //
                            //         ),
                            //     height: MediaQuery.of(context).size.height * 0.17,
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Padding(
                            //           padding: const EdgeInsets.all(8.0),
                            //           child: Text(
                            //             'Document'.tr,
                            //             style: TextStyle(fontSize: 16,color: Colors.white),
                            //           ),
                            //         ),
                            //         SizedBox(
                            //           height: MediaQuery.of(context).size.height * 0.005,
                            //         ),
                            //         Row(
                            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //           crossAxisAlignment: CrossAxisAlignment.center,
                            //           children: [
                            //             Column(
                            //               children: [
                            //                 InkWell(
                            //                   onTap: () async {
                            //                     var pickedFile = await imagePicker.pickImage(
                            //                         source: ImageSource.camera,
                            //                         imageQuality: picQuality);
                            //                     setState(() {
                            //                       image1 = File(pickedFile!.path);
                            //                       Uint8List uint8list = Uint8List.fromList(
                            //                           image1!.readAsBytesSync());
                            //
                            //                       setState((){documentController.selectionDialogue(context,uint8list,documentController.factor.value);});
                            //                     });
                            //                   },
                            //                   child: Container(
                            //                     height: 50,
                            //                     width: 50,
                            //                     decoration: BoxDecoration(
                            //                       borderRadius: BorderRadius.circular(20),color: Colors.white10,
                            //                       border: Border.all(color: Colors.white,),
                            //                     ),
                            //                     child: Icon(
                            //                       FontAwesomeIcons.camera,color: Colors.white,
                            //                     ),
                            //                   ),
                            //                 ),
                            //                 SizedBox(
                            //                   height: 5,
                            //                 ),
                            //                 Text('Camera'.tr,style: TextStyle(color: Colors.white))
                            //               ],
                            //             ),
                            //             Column(
                            //               children: [
                            //                 InkWell(
                            //                   onTap: () async {
                            //                     var pickedFile = await imagePicker.pickImage(
                            //                         source: ImageSource.gallery,
                            //                         imageQuality: picQuality);
                            //                     setState(() {
                            //                       image1 = File(pickedFile!.path);
                            //                       Uint8List uint8list = Uint8List.fromList(
                            //                           image1!.readAsBytesSync());
                            //
                            //                       setState((){documentController.selectionDialogue(context,uint8list,documentController.factor.value);});
                            //                     });
                            //                   },
                            //                   child: Container(
                            //                     height: 50,
                            //                     width: 50,
                            //
                            //                     decoration: BoxDecoration(
                            //                       borderRadius: BorderRadius.circular(20),
                            //                       border: Border.all(color: Colors.white,),
                            //                       color: Colors.white10
                            //                     ),
                            //                     child: Icon(
                            //                       FontAwesomeIcons.image,color: Colors.white,
                            //                     ),
                            //                   ),
                            //                 ),
                            //                 SizedBox(
                            //                   height: 5,
                            //                 ),
                            //                 Text('Gallery'.tr,style: TextStyle(color: Colors.white))
                            //               ],
                            //             ),
                            //             Column(
                            //               children: [
                            //                 InkWell(
                            //                   onTap: ()  {
                            //                     documentController.pickFiles();
                            //
                            //                   },
                            //                   child: Container(
                            //                     height: 50,
                            //                     width: 50,
                            //                     decoration: BoxDecoration(
                            //                       borderRadius: BorderRadius.circular(20),
                            //                       color: Colors.white10,
                            //                       border: Border.all(
                            //                         color: Colors.white,
                            //                       ),
                            //                     ),
                            //                     child: Icon(
                            //                       Icons.document_scanner,color: Colors.white,
                            //                     ),
                            //                   ),
                            //                 ),
                            //                 SizedBox(
                            //                   height: 5,
                            //                 ),
                            //                 Text('Document'.tr,style: TextStyle(color: Colors.white))
                            //               ],
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // ),


                          ],
                        )
                      ),
                  ),
                ],
              ),
            ),
          )
    ),
    );
  }




}
