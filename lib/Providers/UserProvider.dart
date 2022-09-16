//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/Services/UserServices.dart';
import 'package:cloudyml_app2/models/UserModel.dart';
import 'package:cloudyml_app2/models/UserNotificationModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Status{Uninitialized,Authenticated,Authenticating,Unauthenticated}

class UserProvider with ChangeNotifier{
  UserServices _userServices=UserServices();
  FirebaseAuth? _auth;
  User? _user;
  UserModel? _userModel;

  User? get user=> _user;
  UserModel? get userModel=> _userModel;

  UserProvider.initialize():
      _auth=FirebaseAuth.instance{
          _auth?.authStateChanges().listen(_onStateChangedme);
  }


  Future<void> _onStateChangedme(User? user) async{
    if(user!=null){
      _user=user;
      _userModel=await _userServices.getUserById(user.uid);
      // splash();
    }else{
      // splash();
    }
      notifyListeners();
  }

  Future<bool> addToNotificationP({String? title,String? body,String? notifyImage,String? NDate}) async{
    try{
      Map notificationItem={
        'title':title,
        'body':body,
        'notifyImage':notifyImage,
        'NDate':NDate,
      };

      UserNotificationModel itemModel=UserNotificationModel.fromMap(notificationItem);
      print('Notification items are: ${notificationItem.toString()}');
      addToNotificationuserservice(userId: _user!.uid,userNotificationModel:itemModel);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }
  Future<bool> removeFromNotificationP({UserNotificationModel? userNotificationModel})async{
    print("THE Notification IS: ${userNotificationModel.toString()}");
    try{
      removeFromNotificationuserservice(userId: _user!.uid,userNotificationModel: userNotificationModel);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  FirebaseFirestore _firestore=FirebaseFirestore.instance;

  void addToNotificationuserservice({String? userId,UserNotificationModel? userNotificationModel})=>
      _firestore.collection('Users').doc(userId).update({
        "usernotification":FieldValue.arrayUnion([userNotificationModel?.toMap()])
      });

  void removeFromNotificationuserservice({String? userId,UserNotificationModel? userNotificationModel})=>
      _firestore.collection('Users').doc(userId).update({
        "usernotification":FieldValue.arrayRemove([userNotificationModel?.toMap()])
      });

  Future<void> reloadUserModel()async{
    _userModel = await _userServices.getUserById(_auth!.currentUser!.uid);
    notifyListeners();
  }
}