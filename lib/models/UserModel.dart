import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/models/UserNotificationModel.dart';
import 'package:intl/intl.dart';

class UserModel{
  static const ID='id';
  static const NAME='name';
  static const MOBILE='mobilenumber';
  static const EMAIL='email';
  static const IMAGE='image';
  static const USERNOTIFICATIONS = "usernotification";
  static const AUTHTYPE="authType";
  static const PHONEVERIFIED="phoneVerified";

  //Question mark is for that the _id can be null also
  String? _id;
  String? _mobile;
  String? _email;
  String? _name;
  String? _image;
  String? _authType;
  bool? _phoneVerified;
  String? _role;

  String? get id=> _id;
  String? get mobile=> _mobile;
  String? get email=> _email;
  String? get name=> _name;
  String? get image=> _image;
  String? get authType=> _authType;
  bool? get phoneVerified=> _phoneVerified;
  String? get role=>_role;

  List<UserNotificationModel>? userNotificationList;


  UserModel.fromSnapShot(DocumentSnapshot<Map<String,dynamic>> snapshot){
    _name=(snapshot.data()![NAME]=='')?'Enter name':snapshot.data()![NAME];
    _email=(snapshot.data()![EMAIL]=='')?'Enter email':snapshot.data()![EMAIL];
    _mobile=(snapshot.data()![MOBILE]=='')?'__________':snapshot.data()![MOBILE].toString();
    _id=snapshot.data()![ID];
    _authType=snapshot.data()![AUTHTYPE];
    _role=snapshot.data()!['role'];
    _phoneVerified=snapshot.data()![PHONEVERIFIED];
    _image=(snapshot.data()![IMAGE]=='')?'https://stratosphere.co.in/img/user.jpg':snapshot.data()![IMAGE];
    userNotificationList=_convertNotificationItems(snapshot.data()?[USERNOTIFICATIONS]??[]);
  }

  List<UserNotificationModel>? _convertNotificationItems(List userNotificationList) {
    List<UserNotificationModel> convertedNotificationList=[];
    for(Map notificationItem in userNotificationList){
      convertedNotificationList.add(UserNotificationModel.fromMap(notificationItem));
    }
    return convertedNotificationList;
  }

}

