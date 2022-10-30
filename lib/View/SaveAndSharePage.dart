import 'dart:io';
import 'dart:typed_data';
import 'package:image_editor_plus/image_editor_plus.dart';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zoomgrid/Controller/EditImageController.dart';
import 'package:zoomgrid/View/AlbumPage.dart';
import 'package:zoomgrid/View/HomePage.dart';
import 'package:image/image.dart' as imglib;

import '../Controller/GettingAdds.dart';
import '../Controller/OpenAds.dart';

class SaveAndShare extends StatefulWidget {
   SaveAndShare({Key? key}) : super(key: key);

  @override
  State<SaveAndShare> createState() => _SaveAndShareState();
}

class _SaveAndShareState extends State<SaveAndShare> with WidgetsBindingObserver {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
   ImageAndDocumentController documentController=Get.find();
  int count=0;
var args=Get.arguments;

   var toptextColor=const Color(0xFF2980B9);
  void initState() {
    super.initState();
    final applicationBloc = Provider.of<get_ads>(context, listen: false);

    // WidgetsBinding.instance.addPostFrameCallback(
    //       (_) => getads(),
    // );
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);
    //documentController.permissionCheck();
    super.initState();


  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }
    if (state == AppLifecycleState.resumed && isPaused&& count==1) {
      print("Resumed==========================");
      appOpenAdManager.showAdIfAvailable();
      isPaused = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<get_ads>(context);

    return WillPopScope(
      onWillPop: () {
        Get.off(const HomePage());
        return applicationBloc.showBackAd();


      },
      child: Scaffold(

        body: Container(
          width: double.infinity,
          height:double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/background.png'),fit: BoxFit.cover)
          ),

          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //
                Container(
                    width: MediaQuery.of(context).size.width*1,
                    height: MediaQuery.of(context).size.height*0.075,
                    child: EasyBannerAd(adSize: AdSize.fullBanner, adNetwork: AdNetwork.admob)),

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     // IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios,size: 33,color: toptextColor,)),
                      IconButton(onPressed: (){
                        applicationBloc.showBackAd();
                        Get.off(const HomePage());
                        }, icon: Icon(Icons.clear,size: 33,color: toptextColor,),),const SizedBox(width: 2,),
                    ],
                  ),
                ),

                Container(
                  height: MediaQuery.of(context).size.height*0.6,
                  child: Image.memory(args[0]),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // InkWell(
                    //   onTap: () async {
                    //     count++;
                    //     print(count);
                    //     if((count%2)==0){
                    //
                    //      editImage(args[0]);
                    //     }
                    //     else{
                    //       applicationBloc.showInterstitialEditorAd();
                    //       editImage(args[0]);
                    //     }
                    //
                    //   },
                    //   child: Column(
                    //     children: [
                    //       Container(
                    //         height: 52,
                    //         width: 52,
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(40),color: Colors.lightBlue,
                    //          // border: Border.all(color: Colors.white,),
                    //         ),
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             const Icon(
                    //               FontAwesomeIcons.edit,
                    //               color: Colors.white,
                    //             ),
                    //
                    //           ],
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         height: 5,
                    //       ),
                    //       Text('Edit'.tr,style: const TextStyle(color: Colors.white),)
                    //     ],
                    //   ),
                    // ),
                InkWell(
                  onTap: () async{

      if(Platform.isIOS){
      Uint8List uint8list = Uint8List.fromList(
      args[0]);
      imglib.Image? image = imglib.decodeImage(uint8list);
      await imgTofile(image!);
      }

        await GallerySaver.saveImage(args[1].path,albumName: 'Zoom Grid');


      Get.snackbar('Success'.tr,'Image Saved Successfully'.tr,duration: const Duration(seconds: 2),backgroundColor: Colors.green,snackPosition: SnackPosition.BOTTOM);
   //await documentController.fetchNewMedia();
      applicationBloc.showInterstitialAlbumAd();
      Get.to(()=> ShowAlbum(SAS: true,));
      },
                  child: Column(
                    children: [
                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),color: Colors.lightBlue,
                          //border: Border.all(color: Colors.white,),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              FontAwesomeIcons.save,
                              color: Colors.white,
                            ),


                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('Save'.tr,style: const TextStyle(color: Colors.white),)
                    ],
                  ),
                ),
                    InkWell(
                      onTap: () {
                        Future.delayed(const Duration(seconds: 2)).then((value) =>  count++);
                        Share.shareFiles(['${args[1].path}'], text: 'Courtesy of Zoom Grid\nhttps://play.google.com/store/apps/details?id=com.appexsoft.zoomgrid.photo.enhance');

                      },
                      child: Column(
                        children: [
                          Container(
                            height: 52,
                            width: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),color: Colors.lightBlue,
                              //border: Border.all(color: Colors.white,),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  FontAwesomeIcons.shareAlt,
                                  color: Colors.white,
                                ),

                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text('Share'.tr,style: const TextStyle(color: Colors.white),)
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        documentController.selectionDialogue(context,args[0],documentController.factor.value);
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 52,
                            width: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),color: Colors.lightBlue,
                              //border: Border.all(color: Colors.white,),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  FontAwesomeIcons.server,
                                  color: Colors.white,
                                ),

                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text('Enhance'.tr,style: const TextStyle(color: Colors.white),)
                        ],
                      ),
                    ),

                  ],
                ),
                const SizedBox(width: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }

   imgTofile(imglib.Image image) async {

     Directory? directory = await getApplicationDocumentsDirectory();

     bool directoryExists =
     await Directory('${directory.path}/Pictures/Saved').exists();

     if (!directoryExists) {
       print("\n Directory not exist");
       //  navigateToShowPage(path, -1);
       await Directory('${directory.path}/Pictures/Saved').create(recursive: true);

       //Getting all images of chapter from firectory

     }

     print("\n direcctoryb = ${directory}");
     final fullPath =
         '${directory.path}/Pictures/Saved/ZG${DateTime
         .now()}.png';
     final imgFile = File('$fullPath');
     imgFile.writeAsBytesSync(imglib.encodePng(image));
     return imgFile;

   }

  editImage(Uint8List image) async {
    var editedImage = await Get.to(() =>
        ImageEditor(
          SAS: true,
          route: SaveAndShare(),
          savePath: Directory.systemTemp,
          image: image,
        ),);

    // replace with edited image
    if (editedImage != null) {
      setState((){      image = editedImage;
      });

      print(editedImage.runtimeType);
      final dir = await getApplicationDocumentsDirectory();
      final myImagePath = dir.path + "/ZG-${DateTime.now()}.png";
      File imageFile = File(myImagePath);
      if (!await imageFile.exists()) {
        imageFile.create(recursive: true);
      }
      imageFile.writeAsBytes(image);
      Get.to(() => SaveAndShare(), arguments: [image, imageFile]);
    }
  }
}
