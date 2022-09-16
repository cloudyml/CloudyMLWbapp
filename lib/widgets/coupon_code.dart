import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CouponCodeMixin {
  String whenCouponApplied({required String couponCodeText}) {
    String couponAppliedResponse;
    if (couponCodeText.isNotEmpty) {
      if (couponCodeText.toLowerCase() == 'save10' ||
          couponCodeText.toLowerCase() == 'parts2') {
        couponAppliedResponse = 'Voucher is applied !';
      } else {
        couponAppliedResponse = 'Code is invalid.';
      }
    } else {
      couponAppliedResponse = 'Enter the code to apply';
    }
    return couponAppliedResponse;
  }

  bool whetherCouponApplied({required String couponCodeText}) {
    bool NoCouponApplied = true;
    if (couponCodeText.toLowerCase() == 'save10') {
      NoCouponApplied = false;
    } else if (couponCodeText.toLowerCase() == 'parts2') {
      NoCouponApplied = false;
    }
    return NoCouponApplied;
  }

  String? whichCouponCode({required String couponCodeText}) {
    if (couponCodeText.toLowerCase() == 'parts2') return 'parts2';
  }

  // void applydiscount(
  //     String amountPayable, String discount, String couponCodeText) {
  //   if (couponCodeText.isNotEmpty) {
  //     if (couponCodeText.toLowerCase() == 'save10') {
  //       // setState(() {
  //       finalAmountToPay =
  //           (double.parse(amountPayable) * 0.9).toStringAsFixed(2);
  //       finalamountToDisplay =
  //           '₹${(double.parse(amountPayable) * 0.9).toStringAsFixed(2)} /-';
  //       discountedPrice =
  //           '₹${(double.parse(amountPayable) * 0.1).toStringAsFixed(2)} /-';
  //       // });
  //     }
  //   }
  // }

  String amountToDisplayAfterCCA(
      {required String couponCodeText, required String amountPayable}) {
    String finalamountToDisplay = "";
    if (couponCodeText.isNotEmpty) {
      if (couponCodeText.toLowerCase() == 'save10') {
        finalamountToDisplay =
            '₹${(double.parse(amountPayable) * 0.9).toStringAsFixed(2)} /-';
      } else if (couponCodeText.toLowerCase() == 'parts2') {
        finalamountToDisplay =
            '₹${double.parse(amountPayable).toStringAsFixed(2)} /-';
      }
    }
    return finalamountToDisplay;
  }

  String amountToPayAfterCCA(
      {required String couponCodeText, required String amountPayable}) {
    String finalAmountToPay = "";
    if (couponCodeText.isNotEmpty) {
      if (couponCodeText.toLowerCase() == 'save10') {
        finalAmountToPay =
            (double.parse(amountPayable) * 0.9).toStringAsFixed(2);
      } else if (couponCodeText.toLowerCase() == 'parts2') {
        finalAmountToPay = double.parse(amountPayable).toStringAsFixed(2);
      }
    }
    return finalAmountToPay;
  }

  String discountAfterCCA(
      {required String couponCodeText, required String amountPayable}) {
    String discountedPrice = "";
    if (couponCodeText.isNotEmpty) {
      if (couponCodeText.toLowerCase() == 'save10') {
        discountedPrice =
            '- ₹${(double.parse(amountPayable) * 0.1).toStringAsFixed(2)} /-';
      } else if (couponCodeText.toLowerCase() == 'parts2') {
        discountedPrice = '₹0/-';
      }
    }
    return discountedPrice;
  }

  void updateCouponDetailsToUser(
      {required String courseBaughtId,
      required String couponCodeText,
      required bool NoCouponApplied}) async {
    bool couponCodeDetailsExists = await checkIfCouponDetailsExist();

    print(couponCodeDetailsExists);

    Map map = Map<String, dynamic>();

    // map['couponCodeAppliedOncourseId'] = courseBaughtId;
    map['couponCodeApplied'] = couponCodeText;
    if (!NoCouponApplied) {
      if (!couponCodeDetailsExists) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'couponCodeDetails': {courseBaughtId: map}
        });
      } else {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'couponCodeDetails': {courseBaughtId: map}
        });
      }
    }
  }

  Future<bool> checkIfCouponDetailsExist() async {
    bool couponCodeDetailsExists;
    DocumentSnapshot userDs = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Map userFields = userDs.data() as Map<String, dynamic>;

    if (userFields.containsKey('couponCodeDetails')) {
      couponCodeDetailsExists = true;
    } else {
      couponCodeDetailsExists = false;
    }
    return couponCodeDetailsExists;
  }
}
