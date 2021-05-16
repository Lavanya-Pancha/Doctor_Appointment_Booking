import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class toastMessage{
  toastMessages(String text){
    EasyLoading.showToast(text,toastPosition: EasyLoadingToastPosition.bottom);
  }
}