import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class inidicator extends StatelessWidget {
 // Centeralized progress indicator

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child:Container(
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.blueGrey),
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.blueGrey.withOpacity(0.3),
          ),
          height: MediaQuery.of(context).size.height/7,
          width: MediaQuery.of(context).size.width/4,
          child:Center(
            child: CircularProgressIndicator(),
          ),)
    );
  }
}

class toastMessage{
  // toastmessage used Easyloading plugin
  toastMessages(String text) {
    EasyLoading.showToast(text, toastPosition: EasyLoadingToastPosition.bottom);
  }
}
