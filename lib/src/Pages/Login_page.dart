import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hospital_management/functions.dart';
import 'package:hospital_management/src/Pages/Appointment/Appointment_list.dart';
import 'package:hospital_management/src/Pages/Doctor/Add_Doctor.dart';
import 'package:hospital_management/src/Pages/Patient/Patient_list.dart';
import 'package:hospital_management/src/Services/login_service.dart';
import 'package:provider/provider.dart';

import '../../styles.dart';
import '../Widgets.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoginService>(create: (_)=> LoginService(FirebaseAuth.instance)),               // provides firebase service to LoginService class
        StreamProvider(create:  (context) =>context.read<LoginService>().authStateChanges,)     // Looks for authentication changes
      ],
      child: MaterialApp(
        title: 'Gotham Appointment',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Login(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login> {

  final toastMessage _messageToaster = new toastMessage();
  bool hideText=true,submit=false;
  final _formkey = GlobalKey<FormState>();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();                                 // Gets Authentication state whether signed in already or not on the page loads
    return firebaseUser == null?                                                // If FirebaseUser variable equal to null shows login page otherwise goes to homepage
    WillPopScope(onWillPop: () => Future.value(false),
      child: Scaffold(
        body:Center(
          child:SingleChildScrollView(
          child: Container(
            child:Form(
              key: _formkey,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 140.0,
                      child: Image.asset(
                        "assets/images/login-background.jpg",
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(12.0),
                        child:TextFormField(
                          decoration: InputDecoration(
                          border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                            ),
                            hintText: "Email *",
                          ),
                          controller: _email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            else if(!EmailValidator.validate(value))   //validates email with format
                            {
                              return "Please enter a valid email address.";
                            }
                            return null;
                          },
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.all(12.0),
                        child:TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            hintText: "Password *",
                            suffixIcon:IconButton(
                              onPressed: (){
                                setState(() {
                                  hideText = !hideText;  // Toggle between password visible
                                });
                              },
                              icon: Icon(hideText?Icons.visibility_off:Icons.visibility),
                            )
                          ),
                          controller: _password,
                          obscureText: hideText,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                        )
                    ),
                     !submit?TextButton(
                        style: buttonStyle,
                        child: Text("Sign In",
                          style: textStyle,
                        ),
                       onPressed: (){
                          setState(() {
                            submit=true;
                          });
                         FocusScope.of(context).unfocus();
                          if(_formkey.currentState.validate()){
                            // Check the email and password with service returns success or fail
                            context.read<LoginService>().LogIn(email: _email.text.trim(),password: _password.text.trim()).then((value) {
                              if(value == "Success"){
                                _messageToaster.toastMessages("Logged In");
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                    appointmentList()), (Route<dynamic> route) => false);
                              }
                              else if(value == "Fail"){
                                setState(() {
                                  submit=false;
                                  _email.text="";
                                  _password.text="";
                                });
                                _messageToaster.toastMessages("Invalid Username and Password");
                              }
                              else{
                                setState(() {
                                  submit=false;
                                  _email.text="";
                                  _password.text="";
                                });
                                _messageToaster.toastMessages(widgetPage().ConnectError);  // Gives internet connection error
                              }
                            });
                          }else{
                            setState(() {
                              submit = false;
                            });
                          }
                       },
                      ):Container(
                         child:CircularProgressIndicator(),
                     ),
                  ],
                )
            )
          ),
          )
        )
      ),
    ):appointmentList();
  }
}