import 'package:demo_todo_app/product/constants/app_languages_constants.dart';
import 'package:demo_todo_app/product/constants/app_padding_constants.dart';
import 'package:demo_todo_app/product/constants/app_styles_constants.dart';
import 'package:demo_todo_app/widgets/custom_theme_widget.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppLanguagesConstants.appSettingsTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: AppPaddingConstants.allPadding,
            child: Card(
              color: Colors.grey,
              child: Padding(
                padding: AppPaddingConstants.allPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLanguagesConstants.appThemeTitle,
                      style: AppStylesConstants.textStyle,
                    ),
                    const CustomThemeWidget(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
