import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ButtonStyle buttonStyle = TextButton.styleFrom(
    backgroundColor: Colors.blueGrey,
    elevation: 5.0,
    padding: EdgeInsets.only(left:50.0,top: 15.0,right:50.0,bottom: 15.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),

    ));


ButtonStyle btnWoback =TextButton.styleFrom(
    elevation:4.0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.grey,width:1.0)
    ),
    backgroundColor: Colors.white,
    shadowColor: Colors.grey[300]
);

TextStyle textStyle = TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold);
TextStyle titletextStyle = TextStyle(color: Colors.blueGrey,fontSize: 20.0,fontWeight: FontWeight.bold);
TextStyle contenttextStyle = TextStyle(color: Colors.black,fontSize: 20.0);
TextStyle dialogbuttonred = TextStyle(color: Colors.red,fontSize: 20.0,fontWeight: FontWeight.bold);
TextStyle dialogbuttonnormal = TextStyle(color: Colors.blueGrey,fontSize: 20.0,fontWeight: FontWeight.bold);
// TextStyle content = TextStylee(color: Colors.blueGrey,fontSize: 20.0,fontWeight: FontWeight.bold);

