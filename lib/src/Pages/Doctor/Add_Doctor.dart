import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospital_management/Menu.dart';
import 'package:hospital_management/src/Pages/Patient/Add_Patient.dart';
import 'package:hospital_management/src/Pages/Patient/Patient_list.dart';
import 'package:hospital_management/src/Services/Doctor_Service.dart';
import 'package:hospital_management/src/Widgets.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

import '../../../functions.dart';
import '../../../styles.dart';
import '../../modelClass.dart';
import 'Doctor_list.dart';

class addDoctor extends StatefulWidget{

  _addDoctorState createState() => new _addDoctorState();
}

class _addDoctorState extends State<addDoctor>{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var _selected;
  var Speciality = widgetPage().Speciality;
  var _days = widgetPage().days;
  var _daysList;
  TextEditingController _fname = new TextEditingController();
  TextEditingController _lname = new TextEditingController();
  TextEditingController _did = new TextEditingController();
  TextEditingController _day = new TextEditingController();
  TextEditingController _phone = new TextEditingController();


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
            title: Text("Add Doctor"),
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
                          widgetPage().phoneField("Phone Number *",true,_phone),
                          widgetPage().textField("Doctor ID *",true,_did),
                          Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                              child:DropdownButtonFormField(
                                validator: (e){
                                  if(e == null){
                                    return "This field is required";
                                  }
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.0)
                                    ),
                                    hintText: "Select Specialization",

                                ),
                                value: _selected,
                                autofocus: false,
                                onChanged: (val){
                                  setState(() {
                                    FocusScope.of(context).unfocus();
                                    _selected = val;
                                  });
                                },
                                items: Speciality.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                          ),
                          // Multiple dropdownfield for days
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child:MultiSelectFormField(
                              autovalidate: false,
                              validator: (val){
                                if(_daysList == null){
                                  return "This field is required";
                                }
                              },
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              chipBackGroundColor: Colors.blueGrey,
                              checkBoxActiveColor: Colors.blueGrey,
                              checkBoxCheckColor: Colors.white,
                              title: Text(""),
                              dialogShapeBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              dataSource: _days,
                              textField: 'key',
                              valueField: 'value',
                              okButtonLabel: 'OK',
                              cancelButtonLabel: 'CANCEL',
                              hintWidget: Text('Please Selected Duty Days *'),
                              initialValue: _daysList,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  _daysList = value;
                                });
                              },
                            ),

                          ),
                          widgetPage().numberField("Attends No. of Appointments per day *",true,_day)
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
                          if(_formKey.currentState.validate()){
                            var data= await doctor_model(_fname.text.trim(),_lname.text.trim(),_selected,_daysList,_phone.text.trim(),_did.text.trim(),_day.text.trim(),null);
                            var result = await doctorService().addDoctor(data);
                            if(result == "Success") {
                              toastMessage().toastMessages(
                                  "Doctor Added Successfully");
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      doctorList()));
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
        ),
    );
  }
}