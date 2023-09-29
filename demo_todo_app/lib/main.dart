import 'package:demo_todo_app/product/constants/app_languages_constants.dart';
import 'package:demo_todo_app/datas/themes_data.dart';
import 'package:demo_todo_app/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemesData().createPrefObj();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemesData>(
          create: (BuildContext context) => ThemesData(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemesData>(
      builder: (context, themesData, child) {
        themesData.loadFromSharedPreferences();
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppLanguagesConstants.appName,
          theme: themesData.selectedTheme,
          home: const HomeView(),
        );
      },
    );
  }
}
