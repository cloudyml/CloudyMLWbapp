class CourseDetails {
  String courseName;
  String courseId;
  String courseDocumentId;
  String coursePrice;
  String courseDescription;
  String createdBy;
  String amountPayable;
  String discount;
  bool isItComboCourse;
  String courseImageUrl;
  String courseLanguage;
  List courses;
  dynamic curriculum;
  String numOfVideos;
  String FcSerialNumber;
  String courseContent;

  CourseDetails({
    required this.courseName,
    required this.courseId,
    required this.coursePrice,
    required this.courseDescription,
    required this.amountPayable,
    required this.discount,
    required this.isItComboCourse,
    required this.courseImageUrl,
    required this.courseLanguage,
    required this.courses,
    required this.curriculum,
    required this.numOfVideos,
    required this.createdBy,
    required this.courseDocumentId,
    required this.FcSerialNumber,
    required this.courseContent
  });
}
