import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Screens/loginScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

//code to force screen in vertical mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
//code to hide the notification bar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zoomer Management',
      //App main theme data
      theme: ThemeData(
        cursorColor: Color.fromRGBO(248, 78, 105, 1),
        primaryColor: Color.fromRGBO(248, 78, 105, 1),
        primaryColorDark: Color.fromRGBO(50, 50, 50, 1),
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}
