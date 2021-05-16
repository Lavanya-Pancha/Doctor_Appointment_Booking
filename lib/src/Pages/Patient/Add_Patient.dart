
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospital_management/src/Pages/Doctor/Doctor_list.dart';
import 'package:hospital_management/src/Services/Patient_Service.dart';
import 'package:hospital_management/src/Widgets.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:hospital_management/functions.dart';
import '../../../Menu.dart';
import '../../../styles.dart';
import '../../modelClass.dart';
import 'Patient_list.dart';

class addPatient extends StatefulWidget{

  _addPatientState createState() => new _addPatientState();
}

class _addPatientState extends State<addPatient>{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _fname = new TextEditingController();
  TextEditingController _lname = new TextEditingController();
  TextEditingController _age = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _pid = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        drawer: menuPage(),
        appBar: AppBar(
          title: Text("Add Patient"),
        ),
        body:new SingleChildScrollView(
            child:Column(
              children: [
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          widgetPage().textField("First Name *",true,_fname),
                          widgetPage().textField("Last Name *",true,_lname),
                          widgetPage().numberField("Age (In Years) *",true,_age),
                          widgetPage().phoneField("Phone Number *",true,_phone),
                          widgetPage().textField("Patient Hospital ID *",true,_pid),
                        ],
                      )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.all(10.0),
                      child: TextButton(
                        style: buttonStyle,
                        child: Text("Back",
                          style: textStyle,
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                    ),

                    Padding(padding: EdgeInsets.all(10.0),
                      child: TextButton(
                        style: buttonStyle,
                        child: Text("Submit",
                          style: textStyle,
                        ),
                        onPressed: () async{
                          FocusScope.of(context).unfocus();
                          if(_formKey.currentState.validate()){
                            var data= await patient_model(_fname.text.trim(),_lname.text.trim(),_age.text.trim(),_phone.text.trim(),_pid.text.trim(),null);
                            var result = await patientService().addPatient(data);
                            if(result == "Success") {
                              toastMessage().toastMessages(
                                  "Patient Added Successfully");
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      patientList()));
                            }
                            else{
                              toastMessage().toastMessages(
                                  "Something Went Wrong");
                            }
                          }

                        },
                      ),
                    )
                  ],
                )
              ],
            )
        )
    );
  }
}