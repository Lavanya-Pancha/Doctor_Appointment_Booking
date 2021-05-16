import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hospital_management/Menu.dart';
import 'package:hospital_management/src/Pages/Appointment/Appointment_list.dart';
import 'package:hospital_management/src/Pages/Patient/Patient_list.dart';
import 'package:hospital_management/src/Services/Appointment_Service.dart';
import 'package:hospital_management/src/Services/Doctor_Service.dart';
import 'package:hospital_management/src/modelClass.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';
import '../../../functions.dart';
import '../../../styles.dart';
import '../../Widgets.dart';

class bookAppointment extends StatefulWidget{
  final Map patient;

  bookAppointment({Key key,this.patient}):super(key: key);

  @override
  _bookAppointmentState createState() => new _bookAppointmentState();
}

class _bookAppointmentState extends State<bookAppointment>{
  final GlobalKey<FormState> _formkey = new GlobalKey<FormState>();

  final RefreshController _refreshController = RefreshController();
  var _selected;
  var Speciality = widgetPage().Speciality;
  var _days = widgetPage().days;
  var _doctor;
  Map Doctors={};
  var customFormat = new DateFormat('dd-MM-yyyy');
  DateTime selectedDate;
  var postformatdate,selectedday;
  TextEditingController _controller;
  TextEditingController _scale = new TextEditingController();

//Opens calendar with disabled past dates
  showPicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate:selectedDate==null?DateTime.now():selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 0)),
      lastDate: DateTime(DateTime.now().year + 90),
      helpText: 'Select booking date', // Can be used as title
      cancelText: 'Not now',
      confirmText: 'Book',
    );

    if (picked != null){
      setState(() {
        selectedDate = picked;
        postformatdate='${customFormat.format(selectedDate)}';
        var value1='${customFormat.format(selectedDate)}';
        print(selectedDate);
        _controller = TextEditingController(text: value1);
      });
    }

  }

  // Get doctor list depending selected date and specialization
  getDoctors(Map<String, dynamic> data) async{
    Map doc;
    if(Doctors != null) {
      Doctors.clear();
    }
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      await doctorService().getADoctor(data).then((value) {
        setState(() {
          if (value != "Fail") {
            for (var i in value) {
              print(i);
              doc = i.map((key, value) => MapEntry(key.toString(), value));
              Doctors[doc["refrenceID"]] =
                  doc['firstname'] + " " + doc['lastname'];
              print(Doctors);
            }
            // loaded = false;
          }
        });
      });
    }else{
      toastMessage().toastMessages(widgetPage().ConnectError);
    }
  }

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
          title: Text("Book Appointment"),

        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: () async {
            await Future.delayed(Duration(milliseconds: 1000));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => bookAppointment(patient: widget.patient,)),
            );

          },
          child:widget.patient != null && widget.patient.length != 0?SingleChildScrollView(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 30.0,left: 15.0,right: 15.0),
                    child:Container(
                        height: 200.0,
                        width: 400.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.blueGrey[100],
                          border: Border.all(color: Colors.blueGrey,width: 0.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 4.0,
                            ),
                          ],
                        ),

                        child:Padding(padding: EdgeInsets.all(15.0),
                          child: Table(
                            columnWidths: {
                              0:FlexColumnWidth(2.5),
                              1:FlexColumnWidth(.2),
                              2:FlexColumnWidth(2.5),
                            },
                            // border: TableBorder.all(color:Colors.black),
                            children: [
                              TableRow(
                                  children: [
                                    TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                          child: Text("Patient Name",style: dialogbuttonnormal,),
                                        )),
                                    TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                          child: Text(":",style: dialogbuttonnormal,),
                                        )),
                                    TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 15.0),

                                          child:Text(
                                            widget.patient['firstname']+" "+widget.patient['lastname'],
                                            style: dialogbuttonnormal,softWrap: true,
                                          ),
                                        )),
                                  ]
                              ),
                              TableRow(
                                  children: [
                                    TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                          child: Text("Patient ID",style: dialogbuttonnormal,),
                                        )),
                                    TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                          child: Text(":",style: dialogbuttonnormal,),
                                        )),
                                    TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                          child: Text(widget.patient['patientid'],style: dialogbuttonnormal,),
                                        )),
                                  ]
                              ),
                              TableRow(
                                  children: [
                                    TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                          child: Text("Phone Number",style: dialogbuttonnormal,),
                                        )),
                                    TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                          child: Text(":",style: dialogbuttonnormal,),
                                        )),
                                    TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                          child: Text(widget.patient['phonenumber'],style: dialogbuttonnormal,),
                                        )),
                                  ]
                              ),
                            ],
                          ),
                        )
                    )
                ),
                SizedBox(),
                Form(
                    key: _formkey,
                    child: Column(
                  children: [
                    Padding(padding: EdgeInsets.all(20),
                        child:DropdownButtonFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0)
                              ),
                              hintText: "Select Specialization *"
                          ),
                          value: _selected,
                          validator: (e){
                            if(e == null){
                              return "This field is required";
                            }
                          },
                          onChanged: (val){
                            setState(() {
                              _selected = val;
                              var data;
                              if(selectedday != null){
                                data= doctor_model(null, null, _selected, [selectedday], null, null, null, null);
                              }else{
                                data = doctor_model(null, null, _selected, null, null, null, null, null);
                              }
                              getDoctors(data);
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
                        padding: EdgeInsets.all(20),
                        child:TextFormField(
                          // showCursor: true,
                          readOnly: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              hintText: "Select Date *",
                              suffixIcon: Icon(MdiIcons.calendar)
                          ),
                          controller: _controller,
                          validator: (e) {
                            var time= DateFormat('kk').format(DateTime.now());
                            if (e.isEmpty) {
                              return "This field is requried";
                            }else if(e == (customFormat.format(DateTime.now())).toString() && 22 > int.parse(time)  ){
                              return "Schedule date should be future date";
                            }
                          },
                          onTap: () async
                          {
                            await showPicker(context);
                            setState(()  {
                              selectedday = DateFormat('EEEE').format(customFormat.parse(_controller.text));
                            });
                            var data = doctor_model(null, null, _selected, [selectedday], null, null, null, null);
                            getDoctors(data);
                          },
                        )
                    ),
                    Padding(padding: EdgeInsets.all(20),
                        child:DropdownButtonFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0)
                              ),
                              hintText: "Select Doctor *"
                          ),
                          validator: (e){
                            if(e == null){
                              return "This field is required";
                            }
                          },
                          value: _doctor,
                          onChanged: (val){
                            setState(() {
                              _doctor = val;
                            });
                          },
                          items: Doctors != null? Doctors
                              .map((key, value) {
                            return MapEntry(
                                key,
                                DropdownMenuItem(
                                  value: key,
                                  child: Text(value),
                                ));
                          })
                              .values
                              .toList()??[]:[{'id':'','name':'Item Not Found'}].map((value) {
                            return new DropdownMenuItem<String>(
                                value: value['id'],
                                child: new Container(
                                    width: 250.0,
                                    child: new Text(
                                        value['name'].trimLeft(),
                                        overflow: TextOverflow.ellipsis,
                                        style: new TextStyle(fontSize: 13.0)
                                    )
                                )
                            );
                          }).toList(),
                        )
                    ),
                    Padding(padding: EdgeInsets.only(left: 20,right: 20),
                      child:widgetPage().numberField("Severity [1 - 5] (if 1- Most Severe) *", true, _scale),

                    ),
                  ],
                )),
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
                          child: Text("Create",
                            style: textStyle,
                          ),
                          onPressed: () async{
                            FocusScope.of(context).unfocus();
                            if(_formkey.currentState.validate()) {
                              var data = await appoint_model(
                                  widget.patient['firstname'],
                                  widget.patient['lastname'],
                                  widget.patient['patientid'],
                                  _selected,
                                  _controller.text.trim(),
                                  _doctor,
                                  _scale.text.trim(),
                                  "Pending",
                                  null);
                              var result = await appointmentService()
                                  .addappoint(data);
                              if (result == "Success") {
                                toastMessage().toastMessages(
                                    "Appointment Added");
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        appointmentList()));
                              }
                              else {
                                toastMessage().toastMessages(
                                    "Something Went Wrong");
                              }
                            }
                          }
                      ),
                    )
                  ],
                )
              ],
            ),
          ):inidicator(),
        )
    );
  }
}