import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hospital_management/src/Services/Doctor_Service.dart';
import 'package:hospital_management/src/Services/Patient_Service.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

import '../../../Menu.dart';
import '../../../functions.dart';
import '../../../styles.dart';
import '../../Widgets.dart';
import '../../modelClass.dart';
import 'Doctor_list.dart';

class updateDoctor extends StatefulWidget{
  final Map doctor;

  updateDoctor ({ Key key, this.doctor }): super(key: key);

  @override
  _updateDoctorState createState() => new _updateDoctorState();
}

class _updateDoctorState extends State<updateDoctor>{
  Map _doctor;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var _selected;
  var Speciality = widgetPage().Speciality;
  var _days = widgetPage().days;
  var _daysList;
  bool loaded=true;
  TextEditingController _fname = new TextEditingController();
  TextEditingController _lname = new TextEditingController();
  TextEditingController _did = new TextEditingController();
  TextEditingController _day = new TextEditingController();
  TextEditingController _phone = new TextEditingController();

  initialize(){
    _fname.text=_doctor['firstname'];
    _lname.text=_doctor['lastname'];
    _did.text=_doctor['doctorid'];
    _phone.text=_doctor['phonenumber'];
    _day.text=_doctor['count'];
    _selected = _doctor['specialized'];
    _daysList= _doctor['days'];
    setState(() {
      loaded = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _doctor = widget.doctor;
    initialize();
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
          title: Text("Edit Patient"),
        ),
        body:new SingleChildScrollView(
            child:loaded?inidicator():Column(
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
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.0)
                                    ),
                                    hintText: "Select Specialization"
                                ),
                                validator: (e){
                                  if(e == null){
                                    return "This field is required";
                                  }
                                },
                                value: _selected,
                                onChanged: (val){
                                  setState(() {
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
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child:MultiSelectFormField(
                              autovalidate: false,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              chipBackGroundColor: Colors.blueGrey,
                              // chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                              // dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                              checkBoxActiveColor: Colors.blueGrey,
                              checkBoxCheckColor: Colors.white,
                              title: Text(""),
                              validator: (e){
                                if(_daysList == null){
                                  return "This field is required";
                                }
                              },
                              dialogShapeBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              dataSource: _days,
                              textField: 'key',
                              valueField: 'value',
                              okButtonLabel: 'OK',
                              cancelButtonLabel: 'CANCEL',
                              hintWidget: Text('Please choose one or more'),
                              initialValue: _daysList,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
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
                          FocusScope.of(context).unfocus();
                          if(_formKey.currentState.validate()){
                            var data= await doctor_model(_fname.text.trim(),_lname.text.trim(),_selected,_daysList,_phone.text.trim(),_did.text.trim(),_day.text.trim(),widget.doctor['refrenceID']);
                            var result = await doctorService().updateDoctor(data);
                            if(result == "Success") {
                              toastMessage().toastMessages(
                                  "Doctor Updated Successfully");
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
        )
    );
  }
}