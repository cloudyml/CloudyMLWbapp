import 'dart:async';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:cloudyml_app2/models/existing_user.dart';
import 'package:cloudyml_app2/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SignUpform extends StatefulWidget {
  // final List<ExistingUser> listOfAllExistingUser;
  const SignUpform({
    Key? key,
    // required this.listOfAllExistingUser
  }) : super(key: key);

  @override
  State<SignUpform> createState() => _SignUpformState();
}

class _SignUpformState extends State<SignUpform> {
  bool _isHidden = true;
  bool _isLoading = false;
  bool isVerified = false;
  Timer? timer;
  final _signupkey = GlobalKey<FormState>();

  // FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified(User user) async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isVerified) timer?.cancel();
    // print("jsdshd  ${isVerified}");
    if (isVerified) {
      // setState(() {
      //   isVerifyy = true;
      // });
      // print('Is verify ${isVerifyy}');
      ///Should get only those Existing user to which authenticated user's email is matching
      // final getExistingUser = widget.listOfAllExistingUser
      //     .where((element) => (element).email == email.text);

      // ///Getting list of paid courses id
      // final paidCourseNames = getExistingUser.map((e) => e.courseId).toList();

      userprofile(
        name: username.text,
        mobilenumber: mobile.text,
        email: email.text,
        image: '',
        authType: "emailAuth",
        phoneVerified: false,
        listOfCourses: [],
      );
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
      showToast('Account Created Successfully');
      await Future.delayed(Duration(seconds: 7));
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              duration: Duration(milliseconds: 200),
              curve: Curves.bounceInOut,
              type: PageTransitionType.rightToLeftWithFade,
              child: HomePage()),
          (route) => false);
      /*await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1234,
              channelKey: 'image',
              title: 'Welcome to CloudyML',
              body: 'It\'s great to have you on CloudyML',
              bigPicture: 'asset://assets/HomeImage.png',
              largeIcon: 'asset://assets/logo2.png',
              notificationLayout: NotificationLayout.BigPicture,
              displayOnForeground: true));*/
      await Provider.of<UserProvider>(context, listen: false)
          .addToNotificationP(
        title: 'Welcome to CloudyML',
        body: 'It\'s great to have you on CloudyML',
        notifyImage:
            'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/images%2Fhomeimage.png?alt=media&token=2f4abc37-413f-49c3-b43d-03c02696567e',
        NDate: DateFormat('dd-MM-yyyy | h:mm a').format(DateTime.now()),
      );
      // LocalNotificationService.showNotificationfromApp(
      //     title: 'Welcome to CloudyML',
      //     body: 'It\'s great to have you on CloudyML',
      //     payload: 'account'
      // );
    } else {
      // setState(() {
      //   _auth.currentUser=null;
      // });

    }
  }

  void _togglepasswordview() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    return Form(
      key: _signupkey,
      child: Container(
        margin: EdgeInsets.all(min(horizontalScale, verticalScale) * 24),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
                min(horizontalScale, verticalScale) * 25)),
        child: ListView(
          padding: EdgeInsets.fromLTRB(horizontalScale * 25, verticalScale * 36,
              horizontalScale * 24, verticalScale * 36),
          shrinkWrap: true,
          children: [
            TextFormField(
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
            SizedBox(
              height: verticalScale * 12,
            ),
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                  hintText: 'Enter Your Email',
                  hintStyle: TextStyle(
                    fontSize: 20 * min(horizontalScale, verticalScale),
                  ),
                  labelText: 'Email',
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
              height: verticalScale * 12,
            ),
            TextFormField(
              controller: pass,
              decoration: InputDecoration(
                  hintText: 'Set Password',
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
            SizedBox(
              height: verticalScale * 12,
            ),
            TextFormField(
              controller: mobile,
              decoration: InputDecoration(
                  hintText: 'Enter Your Number',
                  hintStyle: TextStyle(
                    fontSize: 20 * min(horizontalScale, verticalScale),
                  ),
                  labelText: 'Phone Number',
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
                    Icons.phone,
                    color: HexColor('6153D3'),
                  )),
              keyboardType: TextInputType.phone,
              maxLength: 10,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Enter Phone No';
                } else if (!RegExp(
                        r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
                    .hasMatch(value)) {
                  return 'Please enter a valid Phone Number';
                } else if (value.length < 10) {
                  return 'Enter 10 digit Phone number';
                }
                return null;
              },
            ),
            SizedBox(
              height: verticalScale * 10,
            ),
            Center(
              child: (_isLoading)
                  ? Loading()
                  : ElevatedButton(
                      child: Text(
                        'SignUp',
                        textScaleFactor: min(horizontalScale, verticalScale),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ),
                      style:
                          ElevatedButton.styleFrom(primary: HexColor('6153D3')),
                      onPressed: () async {
                        // setState(() {
                        //  emailsigned=true;
                        // });
                        // print('Is verify ${emailsigned}');
                        if (_signupkey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          createAccount(
                            email.text,
                            pass.text,
                            pass.text,
                            context,
                          ).then((user) async {
                            if (user != null) {
                              print(user);
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
                                                  height: height * 0.15,
                                                  width: width * 0.5),
                                              Text(
                                                'Verify Your Email',
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
                                              'Verification link has been sent to ',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(),
                                            ),
                                            Text(
                                              '${email.text}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Please check your inbox.Click the link in the email to confirm your email address.',
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
                                          ],
                                        ),
                                      );
                                    });

                                await user.sendEmailVerification();
                                timer = Timer.periodic(Duration(seconds: 3),
                                    (_) => checkEmailVerified(user));
                                print(FirebaseAuth
                                    .instance.currentUser!.displayName);
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: Center(
                                          child: Text(
                                            'Account Creation Failed!',
                                            textScaleFactor: min(
                                                horizontalScale, verticalScale),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'The email address ',
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              '${email.text}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'is already in use by another account.',
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          Center(
                                            child: ElevatedButton(
                                              child: Text('Retry'),
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.red),
                                            ),
                                          )
                                        ]);
                                  });
                              showToast('Account Creation Failed');
                            }
                          });
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
