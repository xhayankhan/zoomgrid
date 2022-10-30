import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:zoomgrid/Controller/EditImageController.dart';


class GridGallery extends StatefulWidget {
  final ScrollController? scrollCtr;

   GridGallery({
    Key? key,
    this.scrollCtr,
  }) : super(key: key);

  @override
  _GridGalleryState createState() => _GridGalleryState();
}

class _GridGalleryState extends State<GridGallery> {
  ImageAndDocumentController documentController=Get.find();


  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        documentController.handleScrollEvent(scroll);
        return false;
      },
      child: GridView.builder(
          controller: widget.scrollCtr,
          itemCount: documentController.mediaList.length>15?15:documentController.mediaList.length,
          gridDelegate:
           SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
               mainAxisSpacing: 10,
               crossAxisSpacing: 7,
              childAspectRatio: MediaQuery.of(context).size.height* 0.65/MediaQuery.of(context).size.height*1.2),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(onTap:()async{
              await EasyLoading.show(status: 'loading...');
               var pickedFile = documentController.mediaList[index];
                        log(documentController.filesssss.toString());
                  // Uint8List uint=Uint8List.fromList(_mediaList[index]);
               //documentController.selectionDialogue(context,documentController.files[index],documentController.factor.value,image1!);
               //documentController.editImage(documentController.files[index]);
               setState((){documentController.selectionDialogue(context,documentController.mediaList[index],documentController.factor.value);});
               EasyLoading.dismiss();
              //  Get.to(()=>CroppingImage(),arguments:files[index]);
              // Get.to(()=>ImageEditorExample(),arguments: files[index]);
            },child:ClipRRect(
                         borderRadius: BorderRadius.circular(20),child:Image.memory(documentController.mediaList[index],fit: BoxFit.fill,))
            );
          }),
    );
  }


}
