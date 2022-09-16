import 'dart:async';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/Providers/AppProvider.dart';
import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/Services/UserServices.dart';
import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:cloudyml_app2/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ChangeEmail extends StatefulWidget {
final String newEmail;

  const ChangeEmail({Key? key, required this.newEmail}) : super(key: key);

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  bool _isHidden = true;
  String? _email;
  Timer? timer;
  final currentuser=FirebaseAuth.instance.currentUser;
  final _loginkey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  String? _newemailverified;

  void initState() {
    Provider.of<UserProvider>(context, listen: false).reloadUserModel();
    _email=Provider.of<UserProvider>(context, listen: false).userModel?.email.toString();
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  void _togglepasswordview() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  FirebaseFirestore _firestore =FirebaseFirestore.instance;

  //////////////////////////////////////////////////////////////////////////////////////////
  changeEmail(String? newEmail,String? password) async{

    final cred = EmailAuthProvider.credential(email: _email.toString(), password: password.toString());
    try{
      currentuser!.reauthenticateWithCredential(cred).then((value) {
        currentuser!.updateEmail(newEmail.toString()).then((_) async{
          _firestore.collection('Users')
              .doc(Provider.of<UserProvider>(context, listen: false).userModel!.id)
              .update({
            'email':newEmail,
          });
          // ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('Your Email has been updated but not yet verified!Please Verify'),duration: Duration(seconds: 4)));
          showToast('Your Email has been updated but not yet verified!Please Verify');
          setState((){
            isVerified=false;
          });
          final newcred = EmailAuthProvider.credential(email: newEmail.toString(), password: password.toString());
          await currentuser!.reauthenticateWithCredential(newcred).then((value) async{
            if (value.user != null) {
              print(value.user);
              if (!isVerified) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      Future.delayed(Duration(seconds: 13), () {
                        Navigator.of(context).pop(true);
                      });
                      return AlertDialog(
                        title: Center(
                          child: Column(
                            children: [
                              Lottie.asset('assets/email.json',
                                  height:127.5,
                                  width: 196),
                              Text(
                                'Verify Your Email',
                                // textScaleFactor: min(
                                //     horizontalScale,
                                //     verticalScale),
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 22,
                                    fontWeight:
                                    FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Verification link has been sent to ',
                              textAlign: TextAlign.center,
                              style: TextStyle(),
                            ),
                            Text(
                              '${newEmail.toString()}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Please check your inbox.Click the link in the email to confirm your email address.',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height:  10,
                            ),
                            Text(
                              'Didn\'t get the email?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Check entered email or check spam folder.',
                              textAlign: TextAlign.center,
                              style: TextStyle(),
                            ),
                          ],
                        ),
                      );
                    });
                Provider.of<AppProvider>(context, listen: false).changeIsLoading();
                await value.user!.sendEmailVerification();
                timer = Timer.periodic(Duration(seconds: 3),
                        (_) => checkEmailVerified(value.user!));
                print(FirebaseAuth
                    .instance.currentUser!.displayName);
                //Provider.of<AppProvider>(context, listen: false).changeIsLoading();
              }
            }
          });

          Provider.of<UserProvider>(context, listen: false).reloadUserModel();

        }).catchError((error){
          Provider.of<AppProvider>(context, listen: false).changeIsLoading();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${error.toString()}')));
          print('dsssd ${error.toString()}');
        });
      }).catchError((error){
        //Provider.of<AppProvider>(context, listen: false).changeIsLoading();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error.toString()}')));
        print('dsssd ${error.toString()}');
      });
    }catch(error){
      print(error);
    }
  }


  Future checkEmailVerified(User user) async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isVerified) timer?.cancel();
    if (isVerified) {
      AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: true,
        dialogType: DialogType.SUCCES,
        showCloseIcon: true,
        autoHide: Duration(seconds: 6),
        title: 'Verified!',
        desc:
        'You have successfully verified the account.\n Please wait you will be redirected to the HomePage.',
        btnOkOnPress: () {
          debugPrint('OnClcik');
        },
        btnOkIcon: Icons.check_circle,
        onDissmissCallback: (type) {
          debugPrint('Dialog Dissmiss from callback $type');
        },
      ).show();
      //showToast('Account Created Successfully');
      await Future.delayed(Duration(seconds: 7));
          FocusScope.of(context).requestFocus(new FocusNode());
        await Future.delayed(Duration(milliseconds: 60));
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Your Email has been changed and Verified..!'),duration: Duration(seconds: 6),),);
      /*await AwesomeNotifications().createNotification(
          content:NotificationContent(
              id:  1234,
              channelKey: 'image',
              title: 'Email Updated',
              body: 'Your Email has been changed and Verified..!',
              //bigPicture: 'asset://assets/HomeImage.png',
              largeIcon: 'https://thumbs.dreamstime.com/z/envelope-document-round-green-check-mark-icon-successful-e-mail-delivery-email-confirmation-verification-concepts-long-112815065.jpg',
              //notificationLayout: NotificationLayout.BigPicture,
              displayOnForeground: true
          )
      );*/
      await Provider.of<UserProvider>(context, listen: false).addToNotificationP(
        title: 'Email Updated',
        body: 'Your Email has been changed and Verified..!',
        notifyImage: 'https://thumbs.dreamstime.com/z/envelope-document-round-green-check-mark-icon-successful-e-mail-delivery-email-confirmation-verification-concepts-long-112815065.jpg',
        NDate: DateFormat('dd-MM-yyyy | h:mm a').format(DateTime.now()),
      );
      //ScaffoldMessenger.of(context).dispose();
    } else {


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
    return Form(
      key: _loginkey,
      child: Container(
        margin: EdgeInsets.all( min(horizontalScale, verticalScale)*24),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular( min(horizontalScale, verticalScale)*25)),
        child: ListView(
          padding: EdgeInsets.fromLTRB(horizontalScale*25,  verticalScale*36, horizontalScale*24, verticalScale*36),
          shrinkWrap: true,
          children: [
            TextFormField(
              initialValue: _email,
              readOnly: true,
              decoration: InputDecoration(
                  hintText: ' Email',
                  labelText: 'Current Email',
                  floatingLabelStyle: TextStyle(
                      fontSize: 18*min(horizontalScale, verticalScale),
                      fontWeight: FontWeight.w500,
                      color: HexColor('7B62DF')),
                  labelStyle: TextStyle(
                    fontSize: 18*min(horizontalScale, verticalScale),
                  ),
                  // border: OutlineInputBorder(),
                  // focusedBorder: OutlineInputBorder(
                  //     borderSide:
                  //     BorderSide(color: HexColor('7B62DF'), width: 2)),
                  // enabledBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(color: HexColor('7B62DF'), width: 2),
                  // ),
                  suffixIcon: Icon(
                    Icons.email,
                    color: HexColor('6153D3'),
                  )),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter email address';
                } else if (!RegExp(
                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?"
                    r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                    .hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(
              height: verticalScale*16,
            ),
            TextFormField(
              controller: pass,
              decoration: InputDecoration(
                  hintText: 'Enter Password',
                  labelText: 'Password',
                  floatingLabelStyle: TextStyle(
                      fontSize: 18*min(horizontalScale, verticalScale),
                      fontWeight: FontWeight.w500,
                      color: HexColor('7B62DF')),
                  labelStyle: TextStyle(fontSize: 18*min(horizontalScale, verticalScale)),
                  border: OutlineInputBorder(),
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
                  return 'Enter the Password';
                } else if (!RegExp(
                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                    .hasMatch(value)) {
                  return 'Password must have atleast one Uppercase, one Lowercase, one special character, and one numeric value';
                }
                return null;
              },
            ),
            SizedBox(
              height: verticalScale*9,
            ),
            InkWell(
              onTap: (){
                if(_email!.isNotEmpty){
                  auth.sendPasswordResetEmail(email: _email.toString());
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        Future.delayed(Duration(seconds: 13), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          title: Center(
                            child: Column(
                              children: [
                                Lottie.asset('assets/email.json',
                                    height: height * 0.15,
                                    width: width * 0.5),
                                Text(
                                  'Password Reset',
                                  textScaleFactor: min(
                                      horizontalScale,
                                      verticalScale),
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 22,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'An email has been sent to ',
                                textAlign: TextAlign.center,
                                style: TextStyle(),
                              ),
                              Text(
                                '${email.text}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Click the link in the email to change password.',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: verticalScale * 10,
                              ),
                              Text(
                                'Didn\'t get the email?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Check entered email or check spam folder.',
                                textAlign: TextAlign.center,
                                style: TextStyle(),
                              ),
                              TextButton(
                                  child: Text('Retry',
                                    textScaleFactor: min(horizontalScale, verticalScale),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  }),
                            ],
                          ),
                        );
                      });
                }else{
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Center(
                              child: Text(
                                'Error',
                                textScaleFactor: min(horizontalScale, verticalScale),
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            content: Text(
                              'Enter email in the email field or check if the email is valid.',
                              textAlign: TextAlign.center,
                              textScaleFactor: min(horizontalScale, verticalScale),
                              style: TextStyle(fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                  child: Text('Retry'),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  })
                            ]);
                      });
                }
              },
              child: Text(
                'Forgot Password?',
                textScaleFactor: min(horizontalScale, verticalScale),
                textAlign: TextAlign.end,
                style:
                TextStyle(color: HexColor('0047FF'), fontSize: 16),
              ),
            ),
            SizedBox(
              height: verticalScale*12,
            ),
            Center(
              child: (appprovider.isLoading)
                  ? Loading()
                  : ElevatedButton(
                    child: Text(
                        'Update Email',
                        textScaleFactor: min(horizontalScale, verticalScale),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ),
                        style: ElevatedButton.styleFrom(
                          primary: HexColor('6153D3'),
                        ),
                        onPressed: () {
                      if(_loginkey.currentState!.validate()){
                        appprovider.changeIsLoading();
                        //changeEmailafterverifying(widget.newEmail, pass.text);
                        changeEmail(widget.newEmail,pass.text);
                      }

                        },
              ),
            )
          ],
        ),
      ),
    );
  }
}


// //////////////////////////////////////////////////////////////////////////////////
// changeEmailafterverifying(String? newEmail,String? password){
//   final cred = EmailAuthProvider.credential(email: _email.toString(), password: password.toString());
//   try{
//     currentuser!.reauthenticateWithCredential(cred).then((value) async{
//       if (value.user != null) {
//         print(value.user);
//         if (!isVerified) {
//           showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 Future.delayed(Duration(seconds: 13), () {
//                   Navigator.of(context).pop(true);
//                 });
//                 return AlertDialog(
//                   title: Center(
//                     child: Column(
//                       children: [
//                         Lottie.asset('assets/email.json',
//                             height:127.5,
//                             width: 196),
//                         Text(
//                           'Verify Your Email',
//                           // textScaleFactor: min(
//                           //     horizontalScale,
//                           //     verticalScale),
//                           style: TextStyle(
//                               color: Colors.red,
//                               fontSize: 22,
//                               fontWeight:
//                               FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         'Verification link has been sent to ',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(),
//                       ),
//                       Text(
//                         '${newEmail.toString()}',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         'Please check your inbox.Click the link in the email to confirm your email address.',
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(
//                         height:  10,
//                       ),
//                       Text(
//                         'Didn\'t get the email?',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         'Check entered email or check spam folder.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(),
//                       ),
//                     ],
//                   ),
//                 );
//               });
//           Provider.of<AppProvider>(context, listen: false).changeIsLoading();
//           // await value.user!.sendEmailVerification();
//           // timer = Timer.periodic(Duration(seconds: 3),
//           //         (_) => checkEmailVerified(value.user!));
//           print(FirebaseAuth
//               .instance.currentUser!.displayName);
//           //Provider.of<AppProvider>(context, listen: false).changeIsLoading();
//         }
//       }
//       print(newEmail);
//
//        await currentuser!.verifyBeforeUpdateEmail(newEmail.toString());
//       timer = Timer.periodic(Duration(seconds: 3),
//               (_) => checkEmailVerified(value.user!,newEmail));
//        //currentuser.email
//       //await Future.delayed(Duration(seconds: 13));
//      // await FirebaseAuth.instance.currentUser!.reload();
//        // if(currentuser!.email==newEmail.toString()){
//        //   //Provider.of<AppProvider>(context, listen: false).changeIsLoading();
//        //   //userprofile(name: username.text, mobilenumber: mobile.text, email: email.text,image: '',authType: "emailAuth",phoneVerified: false);
//        //   AwesomeDialog(
//        //     context: context,
//        //     animType: AnimType.LEFTSLIDE,
//        //     headerAnimationLoop: true,
//        //     dialogType: DialogType.SUCCES,
//        //     showCloseIcon: true,
//        //     autoHide: Duration(seconds: 6),
//        //     title: 'Verified!',
//        //     desc:
//        //     'You have successfully verified the account.\n Please wait you will be redirected to the Account page.',
//        //     btnOkOnPress: () {
//        //       debugPrint('OnClcik');
//        //     },
//        //     btnOkIcon: Icons.check_circle,
//        //     onDissmissCallback: (type) {
//        //       debugPrint('Dialog Dissmiss from callback $type');
//        //     },
//        //   ).show();
//        //   //showToast('Account Created Successfully');
//        //   _firestore.collection('Users')
//        //       .doc(Provider.of<UserProvider>(context, listen: false).userModel!.id)
//        //       .update({
//        //     'email':newEmail,
//        //   });
//        //   await Future.delayed(Duration(seconds: 7));
//        //   Provider.of<UserProvider>(context, listen: false).reloadUserModel();
//        //   FocusScope.of(context).requestFocus(new FocusNode());
//        //   await Future.delayed(Duration(milliseconds: 60));
//        //   Navigator.pop(context);
//        //   ScaffoldMessenger.of(context).showSnackBar(
//        //       SnackBar(content: Text('Your Email has been changed..!')));
//        // }else{
//        //       ScaffoldMessenger.of(context).showSnackBar(
//        //           SnackBar(content: Text('hello hsheedediwjde')));
//        // }
//
//       // await currentuser!.verifyBeforeUpdateEmail(newEmail.toString()).then((value) {
//       //   final newcred = EmailAuthProvider.credential(email: newEmail.toString(), password: password.toString());
//       //   currentuser!.reauthenticateWithCredential(newcred).then((value) async{
//       //     timer = Timer.periodic(Duration(seconds: 3),
//       //             (_) => checkEmailVerified(value.user!));
//       // }).catchError((error){
//       //     Provider.of<AppProvider>(context, listen: false).changeIsLoading();
//       //     ScaffoldMessenger.of(context).showSnackBar(
//       //         SnackBar(content: Text('${error.toString()}')));
//       //     print('dsssd ${error.toString()}');
//       //   });
//       // });
//     }).catchError((error){
//       Provider.of<AppProvider>(context, listen: false).changeIsLoading();
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('${error.toString()}')));
//       print('dsssd ${error.toString()}');
//     });
//   }catch(error){
//     print(error);
//   }
// }




//////////////////////
// Future checkEmailVerified(User user,String? newEmail) async {
//   await FirebaseAuth.instance.currentUser!.reload();
//   // setState(() {
//   //   isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
//   //   print('hellohbdhdahdshfishfih');
//   //   print(isVerified);
//   // });
//
//   if (currentuser!.email==newEmail.toString()) timer?.cancel();
//   // print("jsdshd  ${isVerified}");
//   if (currentuser!.email==newEmail\) {
//     // _firestore.collection('Users')
//     //     .doc(Provider.of<UserProvider>(context, listen: false).userModel!.id)
//     //     .update({
//     //   'email':user.email,
//     // });
//     Provider.of<AppProvider>(context, listen: false).changeIsLoading();
//     //userprofile(name: username.text, mobilenumber: mobile.text, email: email.text,image: '',authType: "emailAuth",phoneVerified: false);
//     AwesomeDialog(
//       context: context,
//       animType: AnimType.LEFTSLIDE,
//       headerAnimationLoop: true,
//       dialogType: DialogType.SUCCES,
//       showCloseIcon: true,
//       autoHide: Duration(seconds: 6),
//       title: 'Verified!',
//       desc:
//       'You have successfully verified the account.\n Please wait you will be redirected to the Account page.',
//       btnOkOnPress: () {
//         debugPrint('OnClcik');
//       },
//       btnOkIcon: Icons.check_circle,
//       onDissmissCallback: (type) {
//         debugPrint('Dialog Dissmiss from callback $type');
//       },
//     ).show();
//     //showToast('Account Created Successfully');
//     _firestore.collection('Users')
//         .doc(Provider.of<UserProvider>(context, listen: false).userModel!.id)
//         .update({
//       'email':user.email,
//     });
//     await Future.delayed(Duration(seconds: 7));
//     Provider.of<UserProvider>(context, listen: false).reloadUserModel();
//     FocusScope.of(context).requestFocus(new FocusNode());
//     await Future.delayed(Duration(milliseconds: 60));
//     Navigator.pop(context);
//     ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Your Email has been changed..!')));
//     // Navigator.pushAndRemoveUntil(
//     //     context,
//     //     PageTransition(
//     //         duration: Duration(milliseconds: 200),
//     //         curve: Curves.bounceInOut,
//     //         type: PageTransitionType.topToBottom,
//     //         child: HomePage()),
//     //         (route) => false);
//     // await AwesomeNotifications().createNotification(
//     //     content:NotificationContent(
//     //         id:  1234,
//     //         channelKey: 'image',
//     //         title: 'Welcome to CloudyML',
//     //         body: 'It\'s great to have you on CloudyML',
//     //         bigPicture: 'asset://assets/HomeImage.png',
//     //         largeIcon: 'asset://assets/logo2.png',
//     //         notificationLayout: NotificationLayout.BigPicture,
//     //         displayOnForeground: true
//     //     )
//     // );
//     // await Provider.of<UserProvider>(context, listen: false).addToNotificationP(
//     //   title: 'Welcome to CloudyML',
//     //   body: 'It\'s great to have you on CloudyML',
//     //   notifyImage: 'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/images%2Fhomeimage.png?alt=media&token=2f4abc37-413f-49c3-b43d-03c02696567e',
//     //   NDate: DateFormat('dd-MM-yyyy | h:mm a').format(DateTime.now()),
//     // );
//     // LocalNotificationService.showNotificationfromApp(
//     //     title: 'Welcome to CloudyML',
//     //     body: 'It\'s great to have you on CloudyML',
//     //     payload: 'account'
//     // );
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Email not verified')));
//     // setState(() {
//     //   _auth.currentUser=null;
//     // });
//
//   }
// }