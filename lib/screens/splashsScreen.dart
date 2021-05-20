import 'dart:async';
import 'package:apiflutter/Global/SizeConfig.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 5);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacementNamed(context, '/WelcomeScreen');
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.blockSizeVertical * 35,
              ),
              Container(
                width: SizeConfig.screenWidth * 0.75,
                child: Image.asset("assets/images/logo-instatram.png"),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 27,
              ),
              Container(
                width: SizeConfig.blockSizeHorizontal * 35,
                child: Image.asset("assets/images/Google_Maps_Logo.png"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
