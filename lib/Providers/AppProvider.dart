import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier{
  bool isLoading = false;
  bool isPressed=true;

  void changeIsLoading(){
    isLoading = !isLoading;
    notifyListeners();
  }
  void changeIsPressed(){
    isPressed = !isPressed;
    notifyListeners();
  }
}