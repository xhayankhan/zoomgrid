
import 'dart:io';
import 'dart:math';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

import 'package:get/get.dart';
import 'package:image/image.dart' as imglib;
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:open_file/open_file.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoomgrid/View/EnchancedImageView.dart';

import 'package:zoomgrid/View/HomePage.dart';

import '../View/LoadingPage.dart';
import '../View/SaveAndSharePage.dart';
class ImageAndDocumentController extends GetxController {
  RxString factor = ''.obs;
  var oldHeight=''.obs;
  var oldWidth=''.obs;
  var newHeight=''.obs;
  var newWidth=''.obs;
  bool two = false;
  bool four = false;
  bool eight = false;
  bool darkTheme = false;
  RxBool isLightTheme = false.obs;
  var mMaxImageThreshold = 9000;
  RxList base = [].obs;
  late File file;
  RxList images = [].obs;
  RxBool connect = false.obs;
  Widget? image;
  List mediaList = [];
  int currentPage = 0;
  int? lastPage;
  XFile? _pickedFile;
  Uint8List? uint8list1;
  // CroppedFile? _croppedFile;
  List filesssss = [];
  List item = [];
  var faceApi=''.obs;
  var otherApi=''.obs;
  RxString inter=''.obs;
  var gal;

  // void initState(){
  //  // getGallery();
  //
  //   super.onInit();
  // }
  // Future getGallery() {
  //   var fut=Future.delayed(Duration(milliseconds: 8)).then((value) => gal=GridGallery());
  //   return fut;
  // }
    getApis() async{

      final String otherApis =
          "http://134.122.15.75/json/zoomgrid_server.txt";
      print(otherApis);

      var request = await http.post(Uri.parse(otherApis));
      otherApi.value=request.body.toString().trim();
      print(otherApi.value);
      final String faceApis =
          "http://134.122.15.75/json/zoomgrid_face_server.txt";
      print(faceApis);

      var request2 = await http.post(Uri.parse(faceApis));
      faceApi.value=request2.body.toString().trim();
      print( faceApi.value);
    }

  handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        fetchNewMedia();
      }
    }
  }

  fetchNewMedia() async {
    //mediaList=[];
    //filesssss=[];
    //await EasyLoading.show(status: 'loading...');

    lastPage = currentPage;
    // final PermissionState ps = await PhotoManager.requestPermissionExtend();
    // PhotoManager.setIgnorePermissionCheck(true);
    // if (ps.isAuth) {
      // success
//load the album list
      List<AssetPathEntity> albums =
      await PhotoManager.getAssetPathList(
        type: RequestType.image,
          onlyAll: true);
      print("/n alb = ");
     // int rang=albums.last;
      print(albums);
      List<AssetEntity> media =
      await albums[0].getAssetListPaged(
          size: 20, page: currentPage); //preloading files
      print(media);
      List<Widget> temp = [];


      for (var asset in media) {
        var g=asset.id;
        Uint8List? uint8list=await asset.thumbnailDataWithSize(ThumbnailSize(1920,1080));
        mediaList.add(uint8list);

      }


    // } else {
    //   PhotoManager.openSetting();
    //   // fail
    //   /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    // }
    //EasyLoading.dismiss();
  }
  //
  // void pickFiles() async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //         type: FileType.custom,
  //         allowedExtensions: ['pdf', 'ppt', 'doc', 'jpg', 'jpeg', 'png']);
  //
  //     if (result != null) {
  //       final picked = result.files.first;
  //       _openFile(picked);
  //     } else {
  //       // User canceled the picker
  //     }
  //
  //     String filePath = file.path;
  //
  //     //Get.to(()=>DocumentViewer(),arguments: filePath);
  //
  //   } on PlatformException catch (e) {
  //     print('Unsupported operation' + e.toString());
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
  //
  // void _openFile(PlatformFile file) {
  //   OpenFile.open(file.path);
  // }

  editImage(Uint8List image) async {
    var editedImage = await Get.off(() =>
        ImageEditor(
          factor: factor,
          SAS: false,
          route: HomePage(),
          savePath: Directory.systemTemp,
          image: image,
        ),);

    // replace with edited image
    if (editedImage != null) {
      image = editedImage;

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

  Future ReadJsonData(File img, String factor) async {

    final String ApiUrl2 =
       // "http://117.20.29.108:5600/upload_file";
        "${otherApi.value}/upload_file";
    print(ApiUrl2);

    var request = http.MultipartRequest("POST", Uri.parse(ApiUrl2));
    request.fields['factor'] = factor;
      print(factor);
    request.files.add(await http.MultipartFile.fromPath('img', img.path));


    request.headers.addAll({'Content-type': 'multipart/formdata'});
    print('Sending request...');

    try {
      var res = await request.send().timeout(const Duration(seconds: 30));

      var responseData = await res.stream.toBytes();

      var responseString = String.fromCharCodes(responseData);
      //print(responseString);
      Map valueMap = json.decode(responseString);
      base.add(valueMap['0']);
          
      images.add(Image.memory(base64Decode(valueMap['0'])));

      res.stream.transform(utf8.decoder).listen((value) {
       // print(value);
      });


      return responseString;
    }
    catch (e) {

   // var alert= Get.defaultDialog(
   //      title: "Super Image Resolution unavailable!",
   //      middleText: "Would you like to continue without the Super Image?",
   //
   //      barrierDismissible: false,
   //      radius: 20.0,
   //      confirm: Container(
   //        width: 80,
   //        child: ElevatedButton(onPressed: () async {
   //
   //          var g = await editImage(uint8list1!);
   //          Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
   //        },
   //          child: Center(child: Text('Yes'),),
   //          style: ButtonStyle(
   //            backgroundColor: MaterialStateProperty.all<Color>(
   //                Colors.red),),),
   //      ),
   //      cancel: Container(width: 80, child: ElevatedButton(onPressed: () {
   //        Get.off(HomePage());
   //      },
   //        child: Center(child: Text('No'),),
   //        style: ButtonStyle(
   //          backgroundColor: MaterialStateProperty.all<Color>(
   //              Colors.transparent),),)),
   //    );

    }
  }


  Future splitImage(Uint8List input, String factor) async {
    // convert image to image from image package
    uint8list1=input;
    if (factor == '0') {
      editImage(input);
    }
    else {
      imglib.Image? image = imglib.decodeImage(input);

      int x = 0,
          y = 0;

      int width = (image!.width / 5).round();
      int height = (image.height / 5).round();
      // split image to parts
      List<imglib.Image> parts = <imglib.Image>[];
      for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
          parts.add(imglib.copyCrop(image, x, y, width, height));

          x += width;
        }
        x = 0;
        y += height;
      }

      // convert image from image package to Image Widget to display
      List<Image> output = [];

      for (var img in parts) {
        output.add(Image.memory(imglib.encodeJpg(img) as Uint8List));
      }

      print(base);
      imglib.Image fullMergeImage;
      List imgs=[];
      int pos = 0;
      fullMergeImage = imglib.Image(width, height);
      for (int i=0;i<base.length;i++) {

        final imag = imglib.decodeImage(base64Decode(base[i]));
        imglib.copyInto(fullMergeImage, imag!, blend: false);
        //pos += image.height + 10;
      }





      var res;
      Uint8List imageInUnit8List = input;// store unit8List image here ;
      final tempDir = await getTemporaryDirectory();
      File filee = await File('${tempDir.path}/image.png').create();
      filee.writeAsBytesSync(imageInUnit8List);
       ReadJsonData(filee, factor);
      for (int i = 0; i < output.length; i++) {
        var fileCon = await imageToFile(parts[i]);
        //res = await ReadJsonData(fileCon, factor);


        //
      }
      if (res.runtimeType == SocketException||res.runtimeType== FormatException) {
        Get.defaultDialog(
          backgroundColor: Colors.lightBlue,
          title: "Super Image Resolution unavailable!",
          middleText: "Would you like to continue without the Super Image?",

          barrierDismissible: false,
          radius: 20.0,
          confirm: Container(
            width: 80,
            child: ElevatedButton(onPressed: () async {
               await editImage(input);
              //Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
            },
              child: Center(child: Text('Yes'),),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.green),),),
          ),
          cancel: Container(width: 80, child: ElevatedButton(onPressed: () {
            Get.off(HomePage());
          },
            child: Center(child: Text('No'),),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.transparent),),)),
        );
        base.clear();
        images.clear();
      }
      else {
        var imtf = await imageToFile(fullMergeImage);

        print('imtf is: $imtf');
//Get.to(()=>enchanced(file: imtf));
        Uint8List uint8list = Uint8List.fromList(
            filee.readAsBytesSync());
        print(input);
        // var thumbnail = imglib.copyResize(image, width: 1080,height: 1920);
//         final tempDir = await getTemporaryDirectory();
//         File file = await File('${tempDir.path}/image.png').create();
//         file.writeAsBytesSync(input);
// var image= await enhance(file,factor);
        //enhanced
       // Get.to(()=>EnchancedImageView(),arguments: [image,oldHeight,oldWidth,newHeight,newWidth]);
        editImage(uint8list);
        base.clear();
        images.clear();
      }


      return output;
    }
  }
  Future<File> enhance(File file,String factor) async {
    if(factor=='0'){
      factor='1';
    }
    ImageProperties properties = await FlutterNativeImage.getImageProperties(file.path);
    File result = await FlutterNativeImage.compressImage(file.path, quality: 100,
        targetWidth: int.parse(factor)*int.parse(properties.width.toString()), targetHeight: int.parse(factor)*int.parse(properties.height.toString()));
    ImageProperties properties2 = await FlutterNativeImage.getImageProperties(result.path);

    // var result = await FlutterImageCompress.compressWithList(
    //   list,
    //   minHeight: 1920,
    //   minWidth: 1080,
    //   quality: 100,
    //
    // );
     print('old Image height:${properties.height},oldImageWidth:${properties.width}');
    print('new Image height:${properties2.height},newImagewidht:${properties2.width}');
    oldHeight.value=properties.height.toString();
    oldWidth.value=properties.width.toString();
    newHeight.value=properties2.height.toString();
    newWidth.value=properties2.width.toString();
    // print(result.length);
    return result;
  }
  imageToFile(imglib.Image image) async {
    Directory? directory = await getApplicationDocumentsDirectory();

    bool directoryExists =
    await Directory('${directory.path}/Pictures').exists();

    if (!directoryExists) {
      print("\n Directory not exist");
      //  navigateToShowPage(path, -1);
      await Directory('${directory.path}/Pictures').create(recursive: true);

      //Getting all images of chapter from firectory

    }

    print("\n direcctoryb = ${directory}");
    final fullPath =
        '${directory.path}/Pictures/ZG${DateTime
        .now()}.png';
    final imgFile = File('$fullPath');
    imgFile.writeAsBytesSync(imglib.encodePng(image));
    return imgFile;
  }

  Future launchUrl1(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication,)) {
      throw 'Could not launch $url';
    }
  }

  void selectionDialogue(BuildContext context, Uint8List uint8list, String fac) async {
    imglib.Image? image = imglib.decodeImage(uint8list);
    var a = image?.width.round();
    print(a);
    var b = image?.height.round();
    var mCompare = max<int>(a!, b!);
    if (mMaxImageThreshold / mCompare < 2) {
      two = true;
      four = false;
      eight = false;
    }
    else if (mMaxImageThreshold / mCompare < 4) {
      two = true;
      four = false;
      eight = false;
    }
    else if (mMaxImageThreshold / mCompare < 8) {
      two = true;
      four = true;
      eight = false;
    }
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: 400),
        transitionBuilder: (BuildContext context, Animation<double> a1,
            Animation<double> a2, Widget child) =>
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(a1),
              child: Dialog(
                backgroundColor: Colors.lightBlue ,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Select Super Image Resolution Scale".tr,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            Obx(() =>
                                RadioListTile(
                                    title: Text("None".tr),
                                    value: "0",
                                    groupValue: factor.value,
                                    onChanged: (value) {
                                      factor.value = value.toString();
                                    }
                                ),
                            ),

                            Obx(() =>
                                RadioListTile(
                                  title: Text("2x Super Resolution".tr),
                                  value: "2",
                                  groupValue: factor.value,
                                  onChanged: (value) {
                                    factor.value = value.toString();
                                  },
                                ),
                            ),

                            Obx(() =>
                                RadioListTile(
                                  title: Text("4x Super Resolution".tr),
                                  value: "4",
                                  groupValue: factor.value,
                                  onChanged: four == false ? null : (value) {
                                    factor.value = value.toString();
                                  },
                                ),
                            ),
                            Obx(() =>
                                RadioListTile(
                                  title: Text("8x Super Resolution".tr),
                                  value: "8",
                                  groupValue: factor.value,
                                  onChanged: eight == false ? null : (value) {
                                    factor.value = value.toString();
                                  },
                                ),
                            ),
                            Obx(() =>
                                RadioListTile(
                                    title: Text(
                                        "16x Super Resolution. (Coming Soon 🔥)".tr),
                                    value: "16",
                                    groupValue: factor.value,
                                    onChanged: null
                                ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    Navigator.pop(context);

                                    await fetchNewMedia();

                                  },
                                  child: Container(
                                    height: 40,
                                    width: 60,
                                    child: Center(
                                      child: Text(
                                          'Cancel'.tr
                                      ),
                                    ),
                                  ),

                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Get.to(() => const loading());

                                    var log = splitImage(
                                        uint8list, factor.value.toString());

                                  },
                                  child: Container(
                                    height: 40,
                                    width: 60,
                                    child: Center(
                                      child: Text(
                                          'Ok'.tr
                                      ),
                                    ),
                                  ),

                                ),


                                //       print(log.runtimeType);
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        pageBuilder: (context, anim1, anim2) {
          return Transform.rotate(
            angle: anim1.value,
          );
        });
  }

  permissionCheck() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera
    ].request();
    print('premission ststus ${statuses[Permission.storage]}');
    return statuses[Permission.storage];
  }

  Future<bool> openDialog(BuildContext context) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SimpleDialog(
              backgroundColor: Colors.lightBlue,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              contentPadding: EdgeInsets.zero,
              children: <Widget>[
                Container(

                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.exit_to_app,
                          size: 30,
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                      Text(
                        'Exit App'.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Are you sure to exit app?'.tr,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 0);
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.cancel,

                        ),
                        margin: EdgeInsets.all(10),
                      ),
                      Text(
                        'Cancel'.tr,
                        style: TextStyle(

                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 1);
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.check_circle,

                        ),
                        margin: EdgeInsets.all(10),
                      ),
                      Text(
                        'Yes'.tr,
                        style: TextStyle(

                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        })) {
      case 0:
       break;
      case 1:
        exit(0);
    }
    return true;
  }
}