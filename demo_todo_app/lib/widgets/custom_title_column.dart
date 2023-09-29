import 'package:demo_todo_app/product/constants/app_languages_constants.dart';
import 'package:demo_todo_app/product/constants/app_styles_constants.dart';
import 'package:flutter/material.dart';

Column customTitleColumn() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text(
        AppLanguagesConstants.appListTitle,
        style: AppStylesConstants.headLineStyle1,
      ),
      Text(
        AppLanguagesConstants.appListSubTitle,
        style: AppStylesConstants.headLineStyle3,
      ),
    ],
  );
}
