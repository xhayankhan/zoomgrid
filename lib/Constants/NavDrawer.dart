import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';


import '../Controller/EditImageController.dart';



class NavDrawer extends StatelessWidget {


  ImageAndDocumentController documentController=Get.find();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // key:MainPage().drawerscaffoldkey,
      child: Container(

        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/background.png')
            )
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[

                DrawerHeader(
                child: Image.asset('assets/logo.png'),

            ),

            SizedBox(height: 20,),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'.tr,
                style: TextStyle(color: Colors.white),),
              onTap: () async {
                Navigator.pop(context);
              },
            ),

            // ListTile(
            //   leading: Icon(Icons.help),
            //   title: Text('Help'.tr,
            //     style: TextStyle(color: Colors.white),),
            //   onTap: () async {
            //
            //   },
            // ),





            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Privacy Policy'.tr),
              onTap: () async {
                final Uri url = Uri.parse('https://sites.google.com/view/zoomgridpp/home');

                documentController.launchUrl1(url);
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Terms of Services'.tr,
                style: TextStyle(color: Colors.white),),
              onTap: () async {
                final Uri url = Uri.parse('https://sites.google.com/view/zoomgridtos/home');

                documentController.launchUrl1(url);
              },
            ),
            ListTile(
              leading: Icon(Icons.apps),
              title: Text('More Apps'.tr,
                style: TextStyle(color: Colors.white),),
              onTap: () async {
                final Uri url = Uri.parse('https://play.google.com/store/apps/dev?id=4730059111577040107');

                documentController.launchUrl1(url);
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share App'.tr,
                style: TextStyle(color: Colors.white),),
              onTap: () async {
                Share.share('Try this app,\nhttps://play.google.com/store/apps/details?id=com.appexsoft.zoomgrid.photo.enhance');

              },
            ),
            ListTile(
              leading: Icon(Icons.star,color: Colors.white,),
              title: Text('Rate App'.tr,
                style: TextStyle(color: Colors.white),),
              onTap: () async {
                final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=com.appexsoft.zoomgrid.photo.enhance');

                documentController.launchUrl1(url);
              },
            ),
            ListTile(
              leading: Icon(Icons.rate_review,color: Colors.white,),
              title: Text('Feedback'.tr,
                style: TextStyle(color: Colors.white),),
              onTap: () async {
                final Email email = Email(

                  subject: 'FeedBack For Zoom Grid App ',
                  recipients: ['appexsoft@gmail.com'],

                  isHTML: false,
                );

                await FlutterEmailSender.send(email);
              },
            ),
            // Builder(builder: (context) {
            //
            //
            //
            //   return ListTile(
            //
            //     leading: Get.isDarkMode
            //         ? Icon(Icons.light_mode,color: Colors.white,)
            //         : Icon(Icons.dark_mode,color: Colors.white,),
            //
            //     title: Get.isDarkMode? Text('Light Mode'.tr,
            //       style: TextStyle(color: Colors.white),) : Text('Dark Mode'.tr,
            //       style: TextStyle(color: Colors.white),),
            //     trailing: Container(height: 30, width: 40, child:   ObxValue(
            //           (data) => Switch(
            //         value: documentController.isLightTheme.value,
            //         onChanged: (val) {
            //           documentController.isLightTheme.value = val;
            //           Get.changeThemeMode(
            //             documentController.isLightTheme.value ? ThemeMode.light : ThemeMode.dark,
            //           );
            //
            //         },
            //       ),
            //       false.obs,
            //     ),),
            //   );
            // }),
            // ListTile(
            //   leading: Icon(Icons.monetization_on_rounded,color: Colors.white,),
            //   title: Text('Purchase'.tr,
            //     style: TextStyle(color: Colors.white),),
            //   onTap: () async {
            //     Get.to(DemoPage());
            //
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.exit_to_app,color: Colors.white,),
              title: Text('Exit'.tr,
                style: TextStyle(color: Colors.white),),
              onTap: () async {
                documentController.openDialog(context);

              },
            ),

          ],
        ),
      ),
    );
  }
}
