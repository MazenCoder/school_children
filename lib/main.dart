import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_children/LogIn.dart';
import 'package:school_children/items/DataModel.dart';
import 'package:school_children/localization/localizations.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:school_children/items/ItemHelper.dart' as helper;

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Locale locale;
  SpecificLocalizationDelegate _specificLocalizationDelegate = SpecificLocalizationDelegate(new Locale('ar'));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: helper.hexToColor('#006233'),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        //app-specific localization
        _specificLocalizationDelegate
      ],
      supportedLocales: [
        const Locale('ar'),
        const Locale('en')
      ],
      home: new SplashScreen(
          seconds: 3,
          navigateAfterSeconds: new LogIn(),
          title: new Text('Welcome In SplashScreen',
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0
            ),),
          image: new Image.asset('images/bg.png', fit: BoxFit.cover,),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 120.0,
          onClick: ()=>print("Flutter Egypt"),
          loaderColor: Colors.red
      ),
    );
  }
}
