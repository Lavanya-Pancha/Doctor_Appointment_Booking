import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hospital_management/src/Services/Patient_Service.dart';

import '../../../Menu.dart';
import '../../../functions.dart';
import '../../../styles.dart';
import '../../Widgets.dart';
import '../../modelClass.dart';
import 'Patient_list.dart';

class updatePatient extends StatefulWidget{
  final Map patient;

  updatePatient ({ Key key, this.patient }): super(key: key);

  @override
  _updatePatientState createState() => new _updatePatientState();
}

class _updatePatientState extends State<updatePatient>{
  Map _patient;
  bool loaded=true;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _fname = new TextEditingController();
  TextEditingController _lname = new TextEditingController();
  TextEditingController _age = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _pid = new TextEditingController();

  initialize(){
    _fname.text=_patient['firstname'];
    _lname.text=_patient['lastname'];
    _age.text=_patient['age'];
    _phone.text=_patient['phonenumber'];
    _pid.text=_patient['patientid'];
    setState(() {
      loaded=false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _patient = widget.patient;
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
                            var data= await patient_model(_fname.text.trim(),_lname.text.trim(),_age.text.trim(),_phone.text.trim(),_pid.text.trim(),widget.patient['refrenceID']);
                            var result = await patientService().updatePatient(data);
                            if(result == "Success") {
                              toastMessage().toastMessages(
                                  "Patient Updated Successfully");
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