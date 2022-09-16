class ExistingUser {
  String? name;
  String? email;
  String? courseId;

  ExistingUser({
    this.name,
    this.email,
    this.courseId,
  });

  factory ExistingUser.fromJson(dynamic json){
    return ExistingUser(
      courseId: json['courseId'],
      email: json['email'],
      name: json['name']
    );
  }

  Map toJson()=>{
    'name':name,
    'email':email,
    'courseId':courseId
  };
}
