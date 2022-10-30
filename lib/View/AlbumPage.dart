import 'dart:io';


import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:zoomgrid/Controller/EditImageController.dart';
import 'package:zoomgrid/View/AlbumImageView.dart';
import 'package:zoomgrid/View/HomePage.dart';

import '../Constants/Constants.dart';
import '../Controller/GettingAdds.dart';

class ShowAlbum extends StatefulWidget {
  bool SAS;
  ShowAlbum({Key? key,required this.SAS}) : super(key: key);

  @override
  State<ShowAlbum> createState() => _ShowAlbumState();
}

class _ShowAlbumState extends State<ShowAlbum> {
  ImageAndDocumentController documentController=Get.find();
  var toptextColor=Color(0xFF2980B9);

  @override
  void initState() {

    super.initState();
    getData();
  }

  List<String> allPagesList = [];
  List<String> allPagesList2 = [];

  var ImagesPath ;
  Directory? dir2 ;
  void getData() async {
    if(Platform.isAndroid){
      ImagesPath =
      "storage/emulated/0/Pictures/Zoom Grid";
      dir2 = Directory(ImagesPath);

    }
    else if(Platform.isIOS){
      var appDir=await getApplicationDocumentsDirectory();
      dir2=Directory('${appDir.path}/Pictures/Saved/');
      ImagesPath='${appDir.path}/Pictures/Saved/';
    }
    bool directoryExists =
    await Directory(ImagesPath).exists();

    if(directoryExists){
    List<FileSystemEntity> files = dir2!.listSync();
    print("\nAll Images inside");

    for (FileSystemEntity f1 in files) {
      allPagesList.add(f1.absolute.path);
      setState((){});
      print(f1.absolute.path);
    }
    allPagesList2=allPagesList.reversed.toList();
    print("allpagesw{${allPagesList2}");

      // setState(() {
    //   editImagePath = allPagesList[0];
    //   editImageIndex = 0;
    //   if (pageIndex != -1) {
    //     gettingResume();
    //   }
    // });

  }
    else if(!directoryExists){
      await Directory('${ImagesPath}').create(recursive: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<get_ads>(context);
    return WillPopScope(
      onWillPop: () {
       return applicationBloc.showBackAd();


      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text("Album".tr),
        // ),
        body: Container(
          width: double.infinity,
          height:double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/background.png'),fit: BoxFit.cover)
          ),
          child: SafeArea(
            child: Column(
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
                        if(widget.SAS==false){
                         applicationBloc.showBackAd();
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePage()));
                      // Get.off(()=>HomePage());
                        }
                        else{
    //applicationBloc.showBackAd();
    Navigator.pop(context);
                        }

                      }, icon: Icon(Icons.arrow_back_ios,size: 28,color: toptextColor,)),
                      Text("Album".tr,style: TextStyle(fontSize: 22,fontWeight:FontWeight.bold ,color: toptextColor),),
                    SizedBox(width: 40,)
                    ],
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if(allPagesList2.isNotEmpty){
                      return Container(
                          padding: const EdgeInsets.only(top: 15),
                           height: double.infinity,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                             ),
                          child:
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0,right: 10),
                                child: GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing:5,
                                      mainAxisSpacing:5,
                                      crossAxisCount: 2,
                                    ),
                                    itemCount: allPagesList2.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          // Utilites.path = "${allPagesList[index]}";
                                          // Utilites.isnetwork = false;
                                          // print("object" + Utilites.path);
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => ImagePainterExample()));
                                                    print(allPagesList2[index]);
                                          Get.to(()=>AlbumImageView(),arguments: File(allPagesList2[index]));
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context).size.height*0.19,
                                              width: MediaQuery.of(context).size.width*0.4,

                                              decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                                            color: Colors.white,
                                                  image: DecorationImage(
                                                  image: FileImage(File(allPagesList2[index])),fit: BoxFit.fill,

                                                ),

                                              ),

                                            ),
                                            Container(

                                                width: MediaQuery.of(context).size.width*0.4,
                                                decoration: BoxDecoration(color: Colors.lightBlue,
                                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20)),
                                                ),
                                                child: Center(child:Platform.isAndroid? Text('${allPagesList2[index]}'.split("/Zoom Grid/")[1].split('.')[0].replaceAll('_', ":").split(".png")[0],style: TextStyle(fontSize: 10),):Text('${allPagesList2[index]}'.split("/Saved/")[1].split('.')[0].replaceAll('_', ":").split(".png")[0],style: TextStyle(fontSize: 10),)))

                                          ],
                                        ),
                                      );
                                    }),
                              ),

                          );
                    }
                    else{
                      return Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Lottie.asset('assets/notFound.json',repeat: true,frameRate: FrameRate(60)),
                                  SizedBox(height: 10,),
                                  Text("There are no Images saved by us,\nGo Edit and Save some Images".tr,style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,

                                  ),),
                                ],
                              ),


                            ],
                          ),
                        ),
                      );
                      }
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
