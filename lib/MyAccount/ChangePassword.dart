import 'dart:math';

import 'package:cloudyml_app2/Providers/AppProvider.dart';
import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/authentication/onboardnew.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final newpasswordController=TextEditingController();
  final oldpasswordController=TextEditingController();
  var newPassword="";
  var oldPassword="";
  final currentuser=FirebaseAuth.instance.currentUser;
  final _formkey=GlobalKey<FormState>();
  bool _isHidden = true;
  void _togglepasswordview() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  @override
   void dispose() {
    newpasswordController.dispose();
    super.dispose();
  }
  changePassword(String? email,String password) async{
          final cred = EmailAuthProvider.credential(email: email.toString(), password: password.toString());
          try{
            currentuser!.reauthenticateWithCredential(cred).then((value) {
              currentuser!.updatePassword(newPassword).then((_) {
                logOut(context);
                Provider.of<AppProvider>(context, listen: false).changeIsLoading();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Onboardew()));
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Your Password has been changed..Login Again!')));
              });
            }).catchError((error){
              Provider.of<AppProvider>(context, listen: false).changeIsLoading();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${error.toString()}')));
              print('dsssd ${error.toString()}');
            });
        }catch(error){
          print(error);
        }
  }
  @override
  Widget build(BuildContext context) {
    final userprovider=Provider.of<UserProvider>(context);
    final appprovider=Provider.of<AppProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: HexColor('7A62DE'),
        leading: BackButton(
          onPressed: () async{
            FocusScope.of(context).requestFocus(new FocusNode());
            await Future.delayed(Duration(milliseconds: 60));
            Navigator.pop(context);
          },
      ),
      ),
      body: Form(
        key: _formkey,
        child: (userprovider.userModel?.authType=='googleAuth' || userprovider.userModel?.authType=='phoneAuth')?
        Center(
          child: Text('You cannot change the password for your account.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
            ),
            textScaleFactor:min(horizontalScale,verticalScale) ,
          ),
        ):
        ListView(
          children:[
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Container(
                  child:Column(
                    children: [
                      SizedBox(height: verticalScale*10,),
                      Text('Use the form below to change the password for your account.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        ),
                        textScaleFactor:min(horizontalScale,verticalScale) ,
                      ),
                      SizedBox(
                        height: verticalScale*20,
                      ),
                      Divider(thickness: 2,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('Email Id: ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),
                          textScaleFactor:min(horizontalScale,verticalScale) ,
                        ),
                      ),
                      SizedBox(height: verticalScale*10,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(userprovider.userModel?.email.toString()??'',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textScaleFactor:min(horizontalScale,verticalScale) ,
                        ),
                      ),
                      SizedBox(height: verticalScale*10,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('Name: ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),
                          textScaleFactor:min(horizontalScale,verticalScale) ,
                        ),
                      ),
                      SizedBox(height: verticalScale*10,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(userprovider.userModel?.name.toString()??'',
                          style: TextStyle(
                            fontSize: 16,
                            //fontWeight: FontWeight.w600
                          ),
                          textScaleFactor:min(horizontalScale,verticalScale) ,
                        ),
                      ),
                      Divider(thickness: 2,),
                      SizedBox(height: verticalScale*10,),
                      Text('Enter Current Password ',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                        ),
                        textScaleFactor:min(horizontalScale,verticalScale) ,
                      ),
                      SizedBox(height: verticalScale*18,),
                      TextFormField(
                        controller: oldpasswordController,
                        decoration: InputDecoration(
                            hintText: 'Enter current Password',
                            hintStyle: TextStyle(
                              fontSize: 20 * min(horizontalScale, verticalScale),
                            ),
                            labelStyle: TextStyle(
                              fontSize: 18 * min(horizontalScale, verticalScale),
                            ),
                            labelText: 'Password',
                            floatingLabelStyle: TextStyle(
                                fontSize: 18 * min(horizontalScale, verticalScale),
                                fontWeight: FontWeight.w500,
                                color: HexColor('7B62DF')),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: HexColor('7B62DF'), width: 2)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: HexColor('7B62DF'), width: 2),
                            ),
                            suffix: InkWell(
                              onTap: _togglepasswordview,
                              child: Icon(
                                _isHidden ? Icons.visibility_off : Icons.visibility,
                                color: HexColor('6153D3'),
                              ),
                            ),
                            errorMaxLines: 2),
                        obscureText: _isHidden,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Set the Password';
                          } else if (!RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                              .hasMatch(value)) {
                            return 'Password must have atleast one Uppercase, one Lowercase, one special character, and one numeric value';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: verticalScale*18,),
                      Text('Enter New Password ',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                        ),
                        textScaleFactor:min(horizontalScale,verticalScale) ,
                      ),
                      SizedBox(height: verticalScale*18,),
                      TextFormField(
                        controller: newpasswordController,
                        decoration: InputDecoration(
                            hintText: 'Enter new Password',
                            hintStyle: TextStyle(
                              fontSize: 20 * min(horizontalScale, verticalScale),
                            ),
                            labelStyle: TextStyle(
                              fontSize: 18 * min(horizontalScale, verticalScale),
                            ),
                            labelText: 'Password',
                            floatingLabelStyle: TextStyle(
                                fontSize: 18 * min(horizontalScale, verticalScale),
                                fontWeight: FontWeight.w500,
                                color: HexColor('7B62DF')),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: HexColor('7B62DF'), width: 2)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: HexColor('7B62DF'), width: 2),
                            ),
                            suffix: InkWell(
                              onTap: _togglepasswordview,
                              child: Icon(
                                _isHidden ? Icons.visibility_off : Icons.visibility,
                                color: HexColor('6153D3'),
                              ),
                            ),
                            errorMaxLines: 2),
                        obscureText: _isHidden,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Set the Password';
                          } else if (!RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                              .hasMatch(value)) {
                            return 'Password must have atleast one Uppercase, one Lowercase, one special character, and one numeric value';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: verticalScale*14,),
                      (appprovider.isLoading)
                      ?Loading()
                      :ElevatedButton(
                        child: Text('Change Password',
                          textScaleFactor:min(horizontalScale,verticalScale) ,
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: HexColor('7A62DE'),
                        ),
                        onPressed: (){
                          if(_formkey.currentState!.validate()){
                            appprovider.changeIsLoading();
                            setState((){
                              newPassword=newpasswordController.text;
                            });
                            changePassword(userprovider.userModel!.email,oldpasswordController.text);
                            //appprovider.changeIsLoading();
                          }
                        },
                      )
                    ],
                  )
              ),
            ),
          ]

        ),
      ),
    );
  }
}

// AuthCredential credential = EmailAuthProvider.credential(email: , password: currentuser.);
// // Reauthenticate
// await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
// await currentuser!.updatePassword(newPassword);
// logOut(context);
// Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Onboardew()));
// ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text('Your Password has been changed..Login Again!')));