//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:upi_plugin/upi_plugin.dart';
import 'package:cloudyml_app2/widgets/coupon_code.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloudyml_app2/globals.dart';

class PaymentButton extends StatefulWidget {
  final ScrollController scrollController;
  final String couponCodeText;
  bool isPayButtonPressed;
  final Function changeState;
  final bool NoCouponApplied;
  final String buttonText;
  final String buttonTextForCode;
  final String amountString;
  final String courseName;
  final String courseImageUrl;
  final String courseDescription;
  // final Razorpay razorpay;
  final Function updateCourseIdToCouponDetails;
  final String? whichCouponCode;
  final String outStandingAmountString;
  bool isItComboCourse;

  String courseId;
  // String courseFetchedId;

  PaymentButton(
      {Key? key,
      required this.scrollController,
      required this.isPayButtonPressed,
      required this.changeState,
      required this.NoCouponApplied,
      required this.buttonText,
      required this.courseImageUrl,
      required this.buttonTextForCode,
      required this.amountString,
      required this.courseName,
      required this.courseDescription,
      required this.updateCourseIdToCouponDetails,
      required this.outStandingAmountString,
      required this.courseId,
      required this.couponCodeText,
      required this.isItComboCourse,
      required this.whichCouponCode})
      : super(key: key);

  @override
  State<PaymentButton> createState() => _PaymentButtonState();
}

class _PaymentButtonState extends State<PaymentButton> with CouponCodeMixin {
  bool isPayInPartsPressed = false;
  bool isMinAmountCheckerPressed = false;
  bool isOutStandingAmountCheckerPressed = false;
  bool whetherMinAmtBtnEnabled = true;
  bool whetherOutstandingAmtBtnEnabled = false;
  var order_id;

  Map userData = Map<String, dynamic>();
  var _razorpay = Razorpay();

  Future<String> intiateUpiTransaction(String appName) async {
    String response = await UpiTransaction.initiateTransaction(
      app: appName,
      pa: 'cloudyml@icici',
      pn: 'CloudyML',
      mc: null,
      tr: null,
      tn: null,
      am: amountStringForUPI,
      cu: 'INR',
      url: 'https://www.cloudyml.com/',
      mode: null,
      orgid: null,
    );
    return response;
  }

  String? amountStringForRp;
  String? amountStringForUPI;
  List? courseList = [];
  bool isLoading = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? id;

  
  void loadCourses() async {
    await _firestore.collection("courses").doc(courseId).get().then((value) {
      print(_auth.currentUser!.displayName);
      Map<String, dynamic> groupData = {
        "name": value.data()!['name'],
        "icon": value.data()!["image_url"],
        "mentors": value.data()!["mentors"],
        "student_id": _auth.currentUser!.uid,
        "student_name": _auth.currentUser!.displayName,
      };
      _firestore.collection("groups").add(groupData);
    });
  }

  // void loadCourses() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   await _firestore
  //       .collection("courses")
  //       .where('id', isEqualTo: widget.courseId)
  //       .get()
  //       .then((value) {
  //     print(value.docs);
  //     final courses = value.docs
  //         .map((doc) => {
  //               "id": doc.id,
  //               "data": doc.data(),
  //             })
  //         .toList();
  //     setState(() {
  //       courseList = courses;
  //     });
  //     print('the list is---$courseList');
  //   });
  //   setState(() {
  //     isLoading = false;
  //   });

  //   Map<String, dynamic> groupData = {
  //     "name": courseList![0]["data"]["name"],
  //     "icon": courseList![0]["data"]["image_url"],
  //     "mentors": courseList![0]["data"]["mentors"],
  //     "student_id": _auth.currentUser!.uid,
  //     "student_name": _auth.currentUser!.displayName,
  //   };

  //   // Fluttertoast.showToast(msg: "Creating group...");

  //   await _firestore.collection("groups").add(groupData);
  //   print('group data=$groupData');

  //   // Fluttertoast.showToast(msg: "Group Created");
  // }

  void updateAmoutStringForUPI(bool isPayInPartsPressed,
      bool isMinAmountCheckerPressed, bool isOutStandingAmountCheckerPressed) {
    if (isPayInPartsPressed) {
      if (isMinAmountCheckerPressed) {
        setState(() {
          amountStringForUPI = '1000.00';
        });
      } else if (isOutStandingAmountCheckerPressed) {
        setState(() {
          amountStringForUPI = widget.outStandingAmountString;
        });
      }
    } else {
      amountStringForUPI =
          (double.parse(widget.amountString) / 100).toStringAsFixed(2);
    }
  }

  void updateAmoutStringForRP(bool isPayInPartsPressed,
      bool isMinAmountCheckerPressed, bool isOutStandingAmountCheckerPressed) {
    if (isPayInPartsPressed) {
      if (isMinAmountCheckerPressed) {
        setState(() {
          amountStringForRp = '100000';
        });
      } else if (isOutStandingAmountCheckerPressed) {
        setState(() {
          amountStringForRp =
              (double.parse(widget.outStandingAmountString) * 100)
                  .toStringAsFixed(2);
        });
      }
    } else {
      setState(() {
        amountStringForRp = widget.amountString;
      });
    }
  }

  Future<String> generateOrderId(
      String key, String secret, String amount) async {
    var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));

    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };

    var data =
        '{ "amount": $amount, "currency": "INR", "receipt": "receipt#R1", "payment_capture": 1 }'; // as per my experience the receipt doesn't play any role in helping you generate a certain pattern in your Order ID!!

    var res = await http.post(Uri.parse('https://api.razorpay.com/v1/orders'),
        headers: headers, body: data);
    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    print('ORDER ID response => ${res.body}');

    // setState(() {
    //   order_id=json.decode(res.body)['id'].toString();
    // });

    order_id = json.decode(res.body)['id'].toString();

    print(order_id);

    return json.decode(res.body)['id'].toString();
  }

  //  generateOrderId('rzp_test_b1Dt1350qiF6cr',
  //       '4HwrQR9o2OSlzzF0MzJmaDdq', amountStringForRp!);

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getPayInPartsDetails();
    updateAmoutStringForUPI(isPayInPartsPressed, isMinAmountCheckerPressed,
        isOutStandingAmountCheckerPressed);
    updateAmoutStringForRP(isPayInPartsPressed, isMinAmountCheckerPressed,
        isOutStandingAmountCheckerPressed);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showToast("Payment failed");
    print("Payment Fail");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External wallet");
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    showToast("Payment successful");
    addCoursetoUser(widget.courseId);
    loadCourses();
    updateCouponDetailsToUser(
      couponCodeText: widget.couponCodeText,
      courseBaughtId: widget.courseId,
      NoCouponApplied: widget.NoCouponApplied,
    );
    updatePayInPartsDetails(
      isPayInPartsPressed,
      isMinAmountCheckerPressed,
      isOutStandingAmountCheckerPressed,
    );
    
    pushToHome();

    // disableMinAmtBtn();
    // enableoutStandingAmtBtn();
    print("Payment Done");
    /*await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 12345,
            channelKey: 'image',
            title: widget.courseName,
            body: 'You bought ${widget.courseName}.Go to My courses.',
            bigPicture: widget.courseImageUrl,
            largeIcon: 'asset://assets/logo2.png',
            notificationLayout: NotificationLayout.BigPicture,
            displayOnForeground: true));*/
    await Provider.of<UserProvider>(context, listen: false).addToNotificationP(
      title: widget.courseName,
      body: 'You bought ${widget.courseName}.Go to My courses.',
      notifyImage: widget.courseImageUrl,
      NDate: DateFormat('dd-MM-yyyy | h:mm a').format(DateTime.now()),
      //index:
    );
  }

  // void disableMinAmtBtn() {
  //   if (isMinAmountCheckerPressed) {
  //     setState(() {
  //       whetherMinAmtBtnEnabled = !whetherMinAmtBtnEnabled;
  //     });
  //   }
  // }

  // void enableoutStandingAmtBtn() {
  //   if (isOutStandingAmountCheckerPressed) {
  //     setState(() {
  //       whetherOutstandingAmtBtnEnabled = !whetherOutstandingAmtBtnEnabled;
  //     });
  //   }
  // }

  void getPayInPartsDetails() async {
    DocumentSnapshot userDs = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      userData = userDs.data() as Map<String, dynamic>;
    });
  }

  void pushToHome() {
    // Navigator.push(
    //   context,
    //   PageTransition(
    //     duration: Duration(milliseconds: 400),
    //     curve: Curves.bounceInOut,
    //     type: PageTransitionType.topToBottom,
    //     child: HomePage(),
    //   ),
    // );
    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          duration: Duration(milliseconds: 200),
          curve: Curves.bounceInOut,
          type: PageTransitionType.rightToLeftWithFade,
          child: HomePage(),
        ),
        (route) => false);
    print('pushedtohome');
  }

  bool stateOfMinAmtBtn() {
    bool? returnBool;
    if (userData['payInPartsDetails'][widget.courseId] == null) {
      if (userData['payInPartsDetails'][widget.courseId]['minAmtPaid']) {
        returnBool = false;
      }
      returnBool = true;
    }
    return returnBool!;
  }

  void updatePayInPartsDetails(
      bool isPayInPartsPressed,
      bool isMinAmountCheckerPressed,
      bool isOutStandingAmountCheckerPressed) async {
    if (isPayInPartsPressed) {
      Map map = Map<String, dynamic>();

      if (isMinAmountCheckerPressed) {
        map['minAmtPaid'] = true;
        map['outStandingAmtPaid'] = false;
        map['startDateOfLimitedAccess'] = DateTime.now().toString();
        map['endDateOfLimitedAccess'] =
            DateTime.now().add(Duration(days: 21)).toString();
        // map['endDateOfLimitedAccess'] =
        //     DateTime.now().add(Duration(seconds: 60)).toString();
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'payInPartsDetails.${widget.courseId}': map});
      } else if (isOutStandingAmountCheckerPressed) {
        // DocumentSnapshot userDs = await FirebaseFirestore.instance
        //     .collection('Users')
        //     .doc(FirebaseAuth.instance.currentUser!.uid)
        //     .get();
        // Map userFields = userDs.data() as Map<String, dynamic>;
        // print(userFields['payInPartsDetails']['${widget.courseId}']
        //     ['minAmtPaid']);
        // final oldmap = Map<String, dynamic>();

        // oldmap['minAmtPaid'] = FieldValue.delete();
        // oldmap['startDateOfLimitedAccess'] = FieldValue.delete();
        // oldmap['endDateOfLimitedAccess'] = FieldValue.delete();
        // oldmap['outStandingAmtPaid'] = FieldValue.delete();

        map['minAmtPaid'] = true;
        map['startDateOfLimitedAccess'] = await userData['payInPartsDetails']
            ['${widget.courseId}']['startDateOfLimitedAccess'];
        map['endDateOfLimitedAccess'] = await userData['payInPartsDetails']
            ['${widget.courseId}']['endDateOfLimitedAccess'];
        map['outStandingAmtPaid'] = true;
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update(
                {'payInPartsDetails.${widget.courseId}': FieldValue.delete()});
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'payInPartsDetails.${widget.courseId}': map});
      }
    }
  }

  void addCoursetoUser(String id) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'paidCourseNames': FieldValue.arrayUnion([id])
    });
  }

  // void initState() {
  //   super.initState();
  //   updateAmoutStringForRP(
  //       widget.isPayInPartsPressed,
  //       widget.isMinAmountCheckerPressed,
  //       widget.isOutStandingAmountCheckerPressed);
  //   updateAmoutStringForUPI(
  //       widget.isPayInPartsPressed,
  //       widget.isMinAmountCheckerPressed,
  //       widget.isOutStandingAmountCheckerPressed);
  // }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context);
    return Container(
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey.shade100,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                widget.isPayButtonPressed = !widget.isPayButtonPressed;
              });
              // widget.changeState;
              if (widget.isPayButtonPressed) {
                Future.delayed(Duration(milliseconds: 150), () {
                  widget.scrollController.animateTo(
                      widget.scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeIn);
                });
              } else {
                Future.delayed(Duration(milliseconds: 150), () {
                  widget.scrollController.animateTo(
                      widget.scrollController.position.minScrollExtent,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeIn);
                });
              }
            },
            child: Center(
              child: Container(
                width: 253,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color:
                            Color.fromRGBO(48, 209, 151, 0.20000000298023224),
                        offset: Offset(0, 10),
                        blurRadius: 8)
                  ],
                  color: Color.fromRGBO(49, 209, 152, 1),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.NoCouponApplied
                          ? widget.buttonText
                          : widget.buttonTextForCode,
                      style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.bold,
                          height: 1),
                    ),
                  ),
                ),
              ),
            ),
          ),
          widget.isPayButtonPressed
              ? Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    (widget.isItComboCourse &&
                            (widget.whichCouponCode == 'parts2'))
                        ? Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(25, 10, 245, 10),
                                  child: Text('Pay in parts'),
                                ),
                                Container(
                                  width: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                      width: 1.1,
                                    ),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isPayInPartsPressed =
                                                !isPayInPartsPressed;
                                          });
                                          // widget.pressPayInPartsButton();
                                        },
                                        child: Container(
                                          height: 60,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                              width: 1.1,
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                child: Icon(Icons.pie_chart,
                                                    size: 43),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Pay in parts',
                                                      style: TextStyle(
                                                          fontSize: 17),
                                                    ),
                                                    Text(
                                                      'Pay min ₹1000 to get limited access of 20 days after that pay the rest and enjoy lifetime access',
                                                      style: TextStyle(
                                                          fontSize: 9,
                                                          color: Colors
                                                              .grey.shade500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      isPayInPartsPressed
                                          ? Container(
                                              //this container will expand onTap
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 180,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: Colors
                                                            .grey.shade200,
                                                        width: 1.1,
                                                      ),
                                                      color: userData['payInPartsDetails']
                                                                  [widget
                                                                      .courseId] !=
                                                              null
                                                          ? Colors.grey.shade100
                                                          : Colors.white,
                                                      // color:if(userData[
                                                      //                   'payInPartsDetails']
                                                      //               [widget.courseId]==null){
                                                      //                 Colors.white
                                                      //               }else if(userData[
                                                      //                   'payInPartsDetails']
                                                      //               [widget.courseId]['isMinAmtPaid']){
                                                      //                 Colors.grey.shade100
                                                      //               }
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20),
                                                          child: Text(
                                                              'Pay  ₹1000.0/-'),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            if (userData[
                                                                        'payInPartsDetails']
                                                                    [widget
                                                                        .courseId] !=
                                                                null) return;
                                                            setState(() {
                                                              isMinAmountCheckerPressed =
                                                                  !isMinAmountCheckerPressed;
                                                            });
                                                            updateAmoutStringForUPI(
                                                                isPayInPartsPressed,
                                                                isMinAmountCheckerPressed,
                                                                isOutStandingAmountCheckerPressed);
                                                            updateAmoutStringForRP(
                                                                isPayInPartsPressed,
                                                                isMinAmountCheckerPressed,
                                                                isOutStandingAmountCheckerPressed);
                                                            print(
                                                                isMinAmountCheckerPressed);
                                                            print(
                                                                "Print payinparts:${isPayInPartsPressed}");
                                                            print(
                                                                amountStringForUPI);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 20),
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  width: 3,
                                                                ),
                                                                color: isMinAmountCheckerPressed
                                                                    ? Color(
                                                                        0xFFaefb2a)
                                                                    : Colors
                                                                        .grey
                                                                        .shade100,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    width: 180,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: Colors
                                                            .grey.shade200,
                                                        width: 1.1,
                                                      ),
                                                      color: !(userData[
                                                                      'payInPartsDetails']
                                                                  [widget
                                                                      .courseId] ==
                                                              null)
                                                          ? Colors.white
                                                          : Colors
                                                              .grey.shade100,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20),
                                                          child: Text(
                                                              'Pay ₹${widget.outStandingAmountString}/-'),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            if (userData[
                                                                        'payInPartsDetails']
                                                                    [widget
                                                                        .courseId] ==
                                                                null) return;
                                                            setState(() {
                                                              isOutStandingAmountCheckerPressed =
                                                                  !isOutStandingAmountCheckerPressed;
                                                            });
                                                            updateAmoutStringForUPI(
                                                                isPayInPartsPressed,
                                                                isMinAmountCheckerPressed,
                                                                isOutStandingAmountCheckerPressed);
                                                            updateAmoutStringForRP(
                                                                isPayInPartsPressed,
                                                                isMinAmountCheckerPressed,
                                                                isOutStandingAmountCheckerPressed);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 20),
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  width: 3,
                                                                ),
                                                                color: isOutStandingAmountCheckerPressed
                                                                    ? Color(
                                                                        0xFFaefb2a)
                                                                    : Colors
                                                                        .grey
                                                                        .shade100,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(25, 10, 240, 10),
                    //   child: Text('Pay with UPI'),
                    // ),
                    // Container(
                    //   width: 300,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     border: Border.all(
                    //       color: Colors.grey.shade200,
                    //       width: 1.1,
                    //     ),
                    //     color: Colors.white,
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       InkWell(
                    //         onTap: () {
                    //           intiateUpiTransaction(UpiApps.GooglePay);
                    //         },
                    //         child: Container(
                    //           height: 60,
                    //           child: Row(
                    //             // mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Padding(
                    //                 padding: const EdgeInsets.only(
                    //                   top: 10,
                    //                   left: 20,
                    //                   right: 15,
                    //                 ),
                    //                 child: Image.asset(
                    //                   'assets/Google_Pay.png',
                    //                   width: 45,
                    //                   height: 45,
                    //                 ),
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.only(
                    //                   top: 10,
                    //                 ),
                    //                 child: Text(
                    //                   'Google Pay',
                    //                   style: TextStyle(fontSize: 17),
                    //                 ),
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.only(
                    //                   left: 100,
                    //                   top: 10,
                    //                 ),
                    //                 child: Icon(
                    //                   Icons.keyboard_arrow_right,
                    //                   color: Colors.grey.shade300,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       Divider(),
                    //       InkWell(
                    //         onTap: () {
                    //           intiateUpiTransaction(UpiApps.PhonePe);
                    //         },
                    //         child: Container(
                    //           height: 60,
                    //           child: Row(
                    //             // mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Padding(
                    //                 padding: const EdgeInsets.only(
                    //                   bottom: 10,
                    //                   left: 20,
                    //                   right: 15,
                    //                 ),
                    //                 child: Image.asset(
                    //                   'assets/phonepe.png',
                    //                   width: 45,
                    //                   height: 45,
                    //                 ),
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.only(
                    //                   bottom: 10,
                    //                 ),
                    //                 child: Text(
                    //                   'PhonePe',
                    //                   style: TextStyle(fontSize: 17),
                    //                 ),
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.only(
                    //                   left: 116,
                    //                   bottom: 10,
                    //                 ),
                    //                 child: Icon(
                    //                   Icons.keyboard_arrow_right,
                    //                   color: Colors.grey.shade300,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(25, 10, 170, 10),
                    //   child: Text('Other payment methods'),
                    // ),
                    InkWell(
                      onTap: () async {
                        // setState(() {
                        //   widget.courseId = widget.courseFetchedId;
                        // });

                        updateAmoutStringForRP(
                            isPayInPartsPressed,
                            isMinAmountCheckerPressed,
                            isOutStandingAmountCheckerPressed);
                        widget.updateCourseIdToCouponDetails();
                        order_id= await generateOrderId('rzp_live_ESC1ad8QCKo9zb',
                            'D5fscRQB6i7dwCQlZybecQND', amountStringForRp!);

                        print('order id is out--$order_id');
                        // Future.delayed(const Duration(milliseconds: 300), () {
                          print('order id is --$order_id');
                          var options = {
                            'key': 'rzp_live_ESC1ad8QCKo9zb',
                            'amount':
                                amountStringForRp, //amount is paid in paises so pay in multiples of 100

                            'name': widget.courseName,
                            'description': widget.courseDescription,
                            'timeout': 300, //in seconds
                            'order_id': order_id,
                            'prefill': {
                              'contact': userprovider.userModel!.mobile,
                              // '7003482660', //original number and email
                              'email': userprovider.userModel!.email,
                              // 'cloudyml.com@gmail.com'
                              // 'test@razorpay.com'
                              'name':userprovider.userModel!.name
                            },
                            'notes':{
                              'contact': userprovider.userModel!.mobile,
                              'email': userprovider.userModel!.email,
                              'name':userprovider.userModel!.name
                            }
                          };
                          _razorpay.open(options);
                        // });
                      },
                      child: Container(
                        height: 60,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                      'assets/razorpay1.jpg',
                                      width: 45,
                                      height: 45,
                                    ),
                              Text(
                                'Razorpay',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
