import 'dart:io';
import 'dart:typed_data';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zoomgrid/Controller/EditImageController.dart';
import 'package:zoomgrid/View/HomePage.dart';

import '../Constants/Constants.dart';
import '../Controller/GettingAdds.dart';
import '../Controller/OpenAds.dart';
import 'SaveAndSharePage.dart';

class AlbumImageView extends StatefulWidget {
  const AlbumImageView({Key? key}) : super(key: key);

  @override
  State<AlbumImageView> createState() => _AlbumImageViewState();
}

class _AlbumImageViewState extends State<AlbumImageView> with WidgetsBindingObserver{
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();

  var args=Get.arguments;
  bool isPaused = false;
  ImageAndDocumentController documentController=Get.find();
  int count=0;
  @override
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
    Uint8List uint8list = Uint8List.fromList(
        args!.readAsBytesSync());
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      // ),
      body: Container(
        width: double.infinity,
        height:double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/background.png'),fit: BoxFit.cover)
        ),
        child: SafeArea(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width*1,
                  height: MediaQuery.of(context).size.height*0.075,
                  child: EasyBannerAd(adSize: AdSize.fullBanner, adNetwork: AdNetwork.admob)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);

                    }, icon: Icon(Icons.arrow_back_ios,size: 28,color: toptextColor,)),
                    Text('Image Preview'.tr,style: TextStyle(color: toptextColor,fontSize: 22,fontWeight: FontWeight.w700),),
                    SizedBox(width: 40,)
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.62,
                width: MediaQuery.of(context).size.width*0.98,
                child: Image.file(args),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  InkWell(
                    onTap: () {
                      editImage(uint8list);

                    },
                    child: Column(
                      children: [
                        Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),color: Colors.lightBlue,
                            //border: Border.all(color: Colors.white,),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.edit,
                                color: Colors.white,
                              ),

                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Edit'.tr,style: TextStyle(color: Colors.white),)
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Future.delayed(const Duration(seconds: 2)).then((value) =>  count++);

                      Share.shareFiles(['${args!.path}'], text: 'Courtesy of Zoom Grid\nhttps://play.google.com/store/apps/details?id=com.appexsoft.zoomgrid.photo.enhance');

                    },
                    child: Column(
                      children: [
                        Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),color: Colors.lightBlue,
                            //border: Border.all(color: Colors.white,),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.shareAlt,
                                color: Colors.white,
                              ),

                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Share'.tr,style: TextStyle(color: Colors.white),)
                      ],
                    ),
                  ),

                  InkWell(
                    onTap: () {

                      File file=args;
                      print(file);
                      Get.defaultDialog(
                        title: 'Are you sure?'.tr,
                        middleText: "Once deleted, The Image will not return".tr,
                        backgroundColor: Colors.lightBlue,
                        barrierDismissible: false,
                        radius: 20.0,
                        confirm: Container(
                          width: 80,
                          child: ElevatedButton(onPressed: () async{
                            await deleteFile(File(file.path));
                           //await documentController.fetchNewMedia();
                           //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ShowAlbum(SAS: false)));
                            Get.off(()=>HomePage());


                          },
                            child:Center(child: Text('Yes'.tr),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),),),
                        ),
                        cancel: Container(width:80,child: ElevatedButton(onPressed: (){Navigator.pop(context);}, child:Center(child: Text('No'),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),),)),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),color: Colors.lightBlue,
                           // border: Border.all(color: Colors.white,),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.trash,
                                color: Colors.white,
                              ),

                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Delete'.tr,style: TextStyle(color: Colors.white),)
                      ],
                    ),
                  ),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete(recursive: true);
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }
  editImage(Uint8List image)async{
    var editedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageEditor(
          SAS: true,
          savePath: Directory.systemTemp,
          image: image,
        ),
      ),
    );

    // replace with edited image
    if (editedImage != null) {

      setState(() {
        image = editedImage;
      });
      print(editedImage.runtimeType);
      final dir = await getApplicationDocumentsDirectory();
      final myImagePath = dir.path + "/ZG-${DateTime.now()}.png";
      File imageFile = File(myImagePath);
      if(! await imageFile.exists())
      {
        imageFile.create(recursive: true);
      }
      imageFile.writeAsBytes(image);
      Get.to(()=>SaveAndShare(),arguments: [image,imageFile]);
    }
  }
}
