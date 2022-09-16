import 'dart:math';

import 'package:cloudyml_app2/authentication/loginform.dart';
import 'package:cloudyml_app2/authentication/onboardbg.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/pages/PhoneName.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class newEnterName extends StatefulWidget {
  const newEnterName({Key? key}) : super(key: key);

  @override
  State<newEnterName> createState() => _newEnterNameState();
}

class _newEnterNameState extends State<newEnterName> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    return Scaffold(
      body: Stack(
        children: [
          Onboardbg(),
          Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: verticalScale * 76,
                  ),
                  Center(
                      child: Image.asset(
                        'assets/logo.png',
                        height: verticalScale * 80,
                        width: horizontalScale * 238,
                      )),
                  SizedBox(
                    height: verticalScale * 50,
                  ),
                  RichText(
                      textAlign: TextAlign.center,
                      textScaleFactor: min(horizontalScale, verticalScale),
                      text: TextSpan(
                          style: TextStyle(
                            fontSize: 25,
                          ),
                          children: [
                            TextSpan(text: "Learn "),
                            TextSpan(
                                text: 'data science \n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "and "),
                            TextSpan(
                                text: 'ML ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "on the go with \nour "),
                            TextSpan(
                                text: 'mobile app ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ])),
                  SizedBox(
                    height: verticalScale * 47.44,
                  ),
                  Container(
                    //color: Colors.black54,
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            width * 0.06)),
                                  ),
                                  child: Text(
                                    'Enter Your Name',
                                    textScaleFactor:
                                    min(horizontalScale, verticalScale),
                                    style: TextStyle(
                                      color: HexColor('6153D3'),
                                      fontSize: 18,
                                    ),
                                  )),
                              // SizedBox(
                              //   width: horizontalScale * 17,
                              // ),
                              // IconButton(
                              //     color: Colors.white,
                              //     onPressed: () {
                              //       // setState(() {
                              //       //   formVisible = false;
                              //       // });
                              //     },
                              //     icon: Icon(Icons.clear))
                            ],
                          ),
                          Container(
                            // decoration: new BoxDecoration(
                            //   boxShadow: [
                            //     // color: Colors.white, //background color of box
                            //     BoxShadow(
                            //       color: HexColor('977EFF'),
                            //       blurRadius: 90.0, // soften the shadow
                            //       offset: Offset(
                            //         0, // Move to right 10  horizontally
                            //         2.0, // Move to bottom 10 Vertically
                            //       ),
                            //     )
                            //   ],
                            // ),
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 200),
                              child: PhoneName(),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                  // SizedBox(
                  //   height: height*0.0705,
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
