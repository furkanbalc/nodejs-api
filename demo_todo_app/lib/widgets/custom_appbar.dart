import 'package:demo_todo_app/product/constants/app_icon_constants.dart';
import 'package:demo_todo_app/view/settings_view.dart';
import 'package:flutter/material.dart';

AppBar customAppBar(BuildContext context) {
  return AppBar(
    // IconButton(
    //   onPressed: () {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       errorSnackBar(context),
    //     );
    //   },
    //   icon: AppIconConstants.menuIcon,
    // ),
    actions: [
      IconButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsView()));
        },
        icon: AppIconConstants.settingsIcon,
      ),
    ],
  );
}
