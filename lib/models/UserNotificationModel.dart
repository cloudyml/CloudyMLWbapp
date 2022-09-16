//import 'package:awesome_notifications/awesome_notifications.dart';

class UserNotificationModel{
  static const TITLE='title';
  static const BODY='body';
  static const NOTIFYIMAGE='notifyImage';
  static const NDATE='NDate';

  String? _title;
  String? _body;
  String? _notifyImage;
  String? _NDate;

  String? get title => _title;
  String? get body => _body;
  String? get notifyImage => _notifyImage;
  String? get NDate => _NDate;


  UserNotificationModel.fromMap(Map data){
    _title=data[TITLE];
    _body=data[BODY];
    _notifyImage=data[NOTIFYIMAGE];
    _NDate=data[NDATE];
  }

  Map toMap() => {
    TITLE: _title,
    BODY: _body,
    NOTIFYIMAGE: _notifyImage,
    NDATE:_NDate,
    //INDEX: _index,
  };

}