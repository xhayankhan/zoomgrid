import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class themeToggle extends StatefulWidget {
  const themeToggle({Key? key}) : super(key: key);

  @override
  State<themeToggle> createState() => _themeToggleState();
}

class _themeToggleState extends State<themeToggle> {

  bool darkTheme = false;
  RxBool isLightTheme = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: ObxValue(
            (data) => CupertinoSwitch(
          value: isLightTheme.value,
          onChanged: (val) {
            isLightTheme.value = val;
            Get.changeThemeMode(
              isLightTheme.value ? ThemeMode.light : ThemeMode.dark,
            );
            //saveThemeStatus();
          },
        ),
        false.obs,
      ),




    );
  }
}
