class UserDetails {
  String userName;
  String userId;
  String emailId;
  String mobilenumber;
  List<String?> paidCoursesId;
  Map<String, Map> payInPartsDetails;
  String role;
  String image;
  String authType;
  bool phoneVerified;

  UserDetails({
    required this.userName,
    required this.userId,
    required this.emailId,
    required this.mobilenumber,
    required this.paidCoursesId,
    required this.payInPartsDetails,
    required this.role,
    required this.authType,
    required this.image,
    required this.phoneVerified,
  });
}
