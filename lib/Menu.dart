import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hospital_management/functions.dart';
import 'package:hospital_management/src/Pages/Appointment/Appointment_list.dart';
import 'package:hospital_management/src/Pages/Doctor/Doctor_list.dart';
import 'package:hospital_management/src/Pages/Login_page.dart';
import 'package:hospital_management/src/Pages/Patient/Patient_list.dart';
import 'package:hospital_management/src/Services/login_service.dart';
import 'package:hospital_management/src/Widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class menuPage extends StatefulWidget{
  _menuPageState createState()=> new _menuPageState();
}

class _menuPageState extends State<menuPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              child: Image.asset("assets/images/login-background.jpg"),
              backgroundColor: Colors.white,
            ),
            accountName: Text("Admin"),
          ),
          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(MdiIcons.doctor,color:Colors.blueGrey),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text("Doctor List ",style: TextStyle(color: Colors.black,fontSize: 16.0,fontWeight: FontWeight.w600,)),
                )
              ],
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                  doctorList()));
            },
          ),
          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.person,color:Colors.blueGrey),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text("Patient List ",style: TextStyle(color: Colors.black,fontSize: 16.0,fontWeight: FontWeight.w600,)),
                )
              ],
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                  patientList()));
            },
          ),
          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.person,color:Colors.blueGrey),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text("Appointment List ",style: TextStyle(color: Colors.black,fontSize: 16.0,fontWeight: FontWeight.w600,)),
                )
              ],
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                  appointmentList()));

            },
          ),
          Divider(),
          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.power_settings_new_sharp,color:Colors.blueGrey),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text("Sign Out",style: TextStyle(color: Colors.black,fontSize: 16.0,fontWeight: FontWeight.w600,)),
                )
              ],
            ),
            onTap: () {
              //Signout the user
              LoginService(FirebaseAuth.instance).Signout().then((value){
                if(value == "Success"){
                  toastMessage().toastMessages("Logged Out");
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      Login()), (Route<dynamic> route) => false);
                }else if(value == "Fail"){
                  toastMessage().toastMessages("Something Went Wrong");
                }else{
                  toastMessage().toastMessages(widgetPage().ConnectError);
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
