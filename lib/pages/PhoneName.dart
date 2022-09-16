import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/Providers/AppProvider.dart';
import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:cloudyml_app2/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class PhoneName extends StatefulWidget {
  const PhoneName({Key? key}) : super(key: key);

  @override
  State<PhoneName> createState() => _PhoneNameState();
}

class _PhoneNameState extends State<PhoneName> {
  FirebaseFirestore _firestore =FirebaseFirestore.instance;
  final currentUser=FirebaseAuth.instance.currentUser;
  GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final userprovider=Provider.of<UserProvider>(context);
    final appprovider=Provider.of<AppProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.all( min(horizontalScale, verticalScale)*24),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular( min(horizontalScale, verticalScale)*25),
            boxShadow: [
              BoxShadow(
              color: HexColor('977EFF'),
              blurRadius: 10.0, // soften the shadow
              offset: Offset(
                0, // Move to right 10  horizontally
                2.0, // Move to bottom 10 Vertically
              ),
            )
            ],
        ),
        child: ListView(
          padding: EdgeInsets.fromLTRB(horizontalScale*25,  verticalScale*36, horizontalScale*24, verticalScale*36),
          shrinkWrap: true,
          children: [
             Padding(
              padding: EdgeInsets.fromLTRB(horizontalScale*0,verticalScale*5,horizontalScale*0,verticalScale*24),
              child: TextFormField(
                controller: username,
                //inputFormatters: [FilteringTextInputFormatter(RegExp(r'[a-zA-Z]'), allow: true)],
                decoration: InputDecoration(
                    hintText: 'Enter Your Name',
                    hintStyle: TextStyle(
                      fontSize: 20 * min(horizontalScale, verticalScale),
                    ),
                    labelText: 'Name',
                    floatingLabelStyle: TextStyle(
                        fontSize: 18 * min(horizontalScale, verticalScale),
                        fontWeight: FontWeight.w500,
                        color: HexColor('7B62DF')),
                    labelStyle: TextStyle(
                      fontSize: 18 * min(horizontalScale, verticalScale),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: HexColor('7B62DF'), width: 2)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor('7B62DF'), width: 2),
                    ),
                    suffixIcon: Icon(
                      Icons.person,
                      color: HexColor('6153D3'),
                    )),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter Name';
                  } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                    return 'Please enter a valid Name';
                  }
                  return null;
                },
              ),
            ),
            appprovider.isLoading?
            Loading()
                : ElevatedButton(
              onPressed: () async{
                if(_formKey.currentState!.validate()){
                  appprovider.changeIsLoading();
                  _firestore.collection('Users')
                      .doc(userprovider.userModel!.id)
                      .update({
                    'name':username.text,
                  });
                  await Future.delayed(Duration(seconds: 2));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                  currentUser?.updateDisplayName(username.text);
                  appprovider.changeIsLoading();
                }else{

                }

              },
              child: Padding(
                padding:  EdgeInsets.all(min(horizontalScale,verticalScale)*11),
                child: Text(
                  'Continue',
                  textScaleFactor: min(horizontalScale,verticalScale),
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Bold',
                      color: Colors.white
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: HexColor('6153D3'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(min(horizontalScale,verticalScale)*10), // <-- Radius
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
