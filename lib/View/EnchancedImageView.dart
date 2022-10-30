import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';

class EnchancedImageView extends StatefulWidget {
  const EnchancedImageView({Key? key}) : super(key: key);

  @override
  State<EnchancedImageView> createState() => _EnchancedImageViewState();
}

class _EnchancedImageViewState extends State<EnchancedImageView> {
  var args=Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height:double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/background.png'),fit: BoxFit.cover)
          ),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.2,

              ),
              Container(
                height: MediaQuery.of(context).size.height*0.5,
                width: double.infinity,
                decoration: BoxDecoration(

                ),
                  child: InteractiveViewer(
                      panEnabled: true, // Set it to false
                     // boundaryMargin: EdgeInsets.all(100),
                      minScale: 1,
                      maxScale: 5,
                      child: Image.file(args[0],fit: BoxFit.cover,))
              ),
              SizedBox(height: 20,),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Before Enhancement Image Height x Width: ${args[1]} x ${args[2]}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                  Text('After Enhancement Image Height x Width: ${args[3]} x ${args[4]}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                  //Text('After Enchance: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
                ],
              ),
              ElevatedButton(onPressed: (){
                GallerySaver.saveImage(args[0].path);

              }, child: Text('save'))
            ],
          ),
        ),
      ),
    );
  }
}
