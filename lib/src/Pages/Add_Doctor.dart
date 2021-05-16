import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class addDoctor extends StatefulWidget{

  _addDoctorState createState() => new _addDoctorState();
}

class _addDoctorState extends State<addDoctor>{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var _selected;
  var Speciality = ["Pediatrics","Cardiology","Ophthalmology","Gynaecology","Physical Theraphy","General"];
  var _days = [
    {"value":"Monday","key":"Monday"},
    {"value":"Tuesday","key":"Tuesday"},
    {"value":"Wednesday","key":"Wednesday"},
    {"value":"Thursday","key":"Thursday"},
    {"value":"Friday","key":"Friday"},
    {"value":"Saturday","key":"Saturday"},
    {"value":"Sunday","key":"Sunday"},
  ];
  var _daysList;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
          appBar: AppBar(
            title: Text("Add Doctor"),
          ),
          body:new SingleChildScrollView(
            child:Container(
            margin: EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child:TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          hintText: "First Name*",
                        ),
                      ),
                    ),
              Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child:
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        hintText: "Last Name*",
                      ),
                    ),
                    ),
              Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child:
                    TextFormField(
                      keyboardType: TextInputType.numberWithOptions(decimal: false),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        hintText: "Phone Number*",
                      ),
                    ),
                    ),
              Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child:
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        hintText: "Doctor ID*",
                      ),
                    ),
                    ),
              Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child:DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)
                    ),
                    hintText: "Select Specialization"
                  ),
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
                    /*TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        hintText: "Days of Duty*",
                      ),
                    ),*/
                    ),
              Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child:
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        hintText: "No.of Appointments per day*",
                      ),
                    ),
                    ),
                  ],
                )),
          ),
        )
    );
  }
}