import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class widgetPage{
  var Speciality = ["Pediatrician","Cardiologist","Ophthalmologist","Gynaecologist","Physical Theraphist","General"];
  var days = [
    {"value":"Monday","key":"Monday"},
    {"value":"Tuesday","key":"Tuesday"},
    {"value":"Wednesday","key":"Wednesday"},
    {"value":"Thursday","key":"Thursday"},
    {"value":"Friday","key":"Friday"},
    {"value":"Saturday","key":"Saturday"},
    {"value":"Sunday","key":"Sunday"},
  ];

  var ConnectError="No Internet Connectivity";

  Widget numberField(String text, bool bool, TextEditingController controller){
    return  Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child:TextFormField(
        controller: controller!=null?controller:null,
        readOnly: controller==null?true:false,
        keyboardType: TextInputType.number,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        validator: bool?(val){
          if(val == null || val == ""){
            return "This field is required";
          }
        }:null,
        autofocus: false,
        decoration: InputDecoration(
          border: bool?OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ):null,
          hintText: text,
        ),
      ),
    );
  }

  Widget phoneField(String text, bool bool, TextEditingController controller){
    return Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child:TextFormField(
        controller: controller!=null?controller:null,
        readOnly: controller==null?true:false,
        keyboardType: TextInputType.number,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        validator: bool? (e) {
          Pattern patttern = r'(^(?:[+0]9)?[0-9]{10,15}$)';
          RegExp regExp = new RegExp(patttern);
          if (e.isEmpty) {
            return "This field is requried";
          }
          if(!regExp.hasMatch(e)){
            return "Please enter a valid Mobile Number";
          }
        }:null,
        autofocus: false,
        decoration: InputDecoration(
          border: bool?OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ):null,
          hintText: text,
        ),
      ),
    );
  }

  Widget textField(String text, bool bool, TextEditingController controller){
    return  Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child:TextFormField(
        controller: controller!=null?controller:null,
        readOnly: controller==null?true:false,
        validator: bool?(val){
          if(val == null || val == ""){
            return "This field is required";
          }
        }:null,
        autofocus: false,
        decoration: InputDecoration(
          border: bool?OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ):null,
          hintText: text,
        ),
      ),
    );
  }
}

