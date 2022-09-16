import 'package:flutter/cupertino.dart';

TextEditingController email = TextEditingController();
// TextEditingController otp = TextEditingController();
TextEditingController pass = TextEditingController();
TextEditingController mobile = TextEditingController();
TextEditingController username = TextEditingController();
bool isVerified = false;
bool submitting = false;
String? passwordttt;

String? courseId;
String? moduleId;
String? topicId;

const mockUpHeight = 896;
const mockUpWidth = 414;

LinearGradient gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF7860DC),
      Color(0xFFC0AAF5),
      Color(0xFFDDD2FB),
      // Color.fromARGB(255, 241, 18, 186),
    ]);
