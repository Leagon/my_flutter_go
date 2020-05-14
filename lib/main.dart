// import from os
import 'package:flutter/material.dart';
import 'package:my_flutter_go/data_base/provider.dart';

// import custom
import 'package:my_flutter_go/views/login/login_page.dart';

// import from 3rd
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = Provider();
  await provider.init(true);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  MyApp();

  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  bool hasLogin = false;
  bool isLoading = false;
  int themeColor = 0xFFC91B3A;


  _MyAppState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "titles",
      theme: new ThemeData(
        primaryColor: Color(this.themeColor),
        backgroundColor: Color(0xffefefef),
        accentColor: Color(0xff888888),
        textTheme: TextTheme(bodyText1: TextStyle(color: Color(0xff888888), fontSize: 16)),
        iconTheme: IconThemeData(color: Color(this.themeColor), size: 35),
      ),
      home: new Scaffold(body: showWelcomePage()),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: null,
      // navigatorObservers: null,
    );
  }

  showWelcomePage() {
    print("show welcome page");
    if (isLoading) {
      return Container(
        color: Color(this.themeColor),
        child: Center(child:  SpinKitPouringHourglass(color: Colors.white) ),
      );
    } else {
      return LoginPage();
    }
  }

}