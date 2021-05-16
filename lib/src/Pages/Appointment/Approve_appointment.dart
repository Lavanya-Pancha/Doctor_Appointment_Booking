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

class approveAppointment extends StatefulWidget{
  final Map appoint;

  approveAppointment( {Key key,this.appoint}):super(key: key);

  @override
  _approveAppointmentState createState() => new _approveAppointmentState();
}

class _approveAppointmentState extends State<approveAppointment>{
  final RefreshController _refreshController = RefreshController();
  List appointList=[];
  var doctor;
  var _doctor;
  var customFormat = new DateFormat('dd-MM-yyyy');
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Map Doctors={};
  DateTime selectedDate;
  var postformatdate,selectedday;
  TextEditingController _controller;
  bool loaded=true,check=true,avail;
  getDoctor(String appoint) async{
    await doctorService().getDoctorDetials(appoint).then((val){                 // Gets Specific doctor details with doctor id which got from appointment list
      if(val != "Fail"){
        setState(() {
          doctor=val;
        });
      }
    });
    return "Success";
  }


  //Opens calendar with disabled past dates
  showPicker(BuildContext context) async {
    print(selectedDate);
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


  /*Checks the availability of the doctor on the date which given at the time of appointment creation
  checks with , and doctor available slot and duty days*/
  checkAvail(doctor, count) async{
    print(count);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      check = false;
      var val = await appointmentService().getAllAppoint(doctor);
      print(val);
      if (val != "Fail") {
        setState(() {
          for (var i in val) {
            appointList.add(
                i.map((key, value) => MapEntry(key.toString(), value)));
          }
          var booked = 0;

          for (var i in appointList) {
            if (_controller.text == i['date'] && i['status'] == "Booked") {
              booked += 1;
            }
          }
          if (int.parse(count) > booked) {
            avail = true;
          }
          else {
            avail = false;
          }
          print(check);
        });
      }
      return "Success";
    }
    else{
      toastMessage().toastMessages(widgetPage().ConnectError);
    }
  }


  // Opens alertbox when User cancels the appointment
  _alertDialog(String id){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text("Do You Want to Cancel This Appointment?"),
            contentTextStyle: contenttextStyle,
            actions: [
              TextButton(onPressed: () async {
                var result = await appointmentService().cancelBooking(id);
                if(result == "Success") {
                  toastMessage().toastMessages(
                      "Booking Cancelled");
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(
                      builder: (BuildContext context) =>
                          appointmentList()));
                }
                else{
                  toastMessage().toastMessages(
                      "Something Went Wrong");
                }
              },
                  child:Text("Yes",
                    style: titletextStyle,
                  ) ),
              TextButton(onPressed: (){
                Navigator.pop(context);
              },
                  child:Text("No",
                    style: titletextStyle,
                  ) ),
            ],
          );
        }
    );
  }


  //Opens alertbox for approval of appointment
  _approveDialog(String id, String date,String did){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text("Do You Want to Approve This Appointment?"),
            contentTextStyle: contenttextStyle,
            actions: [
              TextButton(onPressed: () async {
                var result = await appointmentService().approveApoint(id,date,did);
                if(result == "Success") {
                  toastMessage().toastMessages(
                      "Booking Approved");
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(
                      builder: (BuildContext context) =>
                          appointmentList()));
                }
                else{
                  toastMessage().toastMessages(
                      "Something Went Wrong");
                }
              },
                  child:Text("Yes",
                    style: titletextStyle,
                  ) ),
              TextButton(onPressed: (){
                Navigator.pop(context);
              },
                  child:Text("No",
                    style: titletextStyle,
                  ) ),
            ],
          );
        }
    );
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
              doc = i.map((key, value) => MapEntry(key.toString(), value));
              Doctors[doc["refrenceID"]] =
                  doc['firstname'] + " " + doc['lastname'];
            }
            if (widget.appoint["doctorid"] != null && _doctor == null) {
              _doctor = widget.appoint["doctorid"];
            }
            // loaded = false;
          }
        });
      });
    }else{
      toastMessage().toastMessages(widgetPage().ConnectError);
    }
  }

  getDetails(){
    setState(() {
      selectedDate  =customFormat.parse(widget.appoint['date']);
      _controller= TextEditingController(text: widget.appoint['date'].toString());
      selectedday = DateFormat('EEEE').format(selectedDate);                              //  Converts date to day
      var data=appoint_model(null, null, null, null, selectedday, null,null,null, null);
      getDoctors(data);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
    getDoctor(widget.appoint['doctorid']);
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
        title: Text("Approve Appointment"),),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1000));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => approveAppointment(appoint: widget.appoint,)),
          );

        },
        child:doctor == null?inidicator():SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 30.0,left: 15.0,right: 15.0),
                  child:Container(
                      height: MediaQuery.of(context).size.height/2.5,
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
                                    child:Padding(
                                        padding: EdgeInsets.symmetric(vertical: 15.0),
                                        child:Text("Patient Name",style:titletextStyle)
                                    ),
                                  ),
                                  TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 15.0),
                                        child: Text(":",style: dialogbuttonnormal,),
                                      )),
                                  TableCell(
                                      child:Center(
                                        child:Padding(
                                            padding: EdgeInsets.symmetric(vertical: 15.0),
                                            child:Text(widget.appoint['patientname'],style:titletextStyle)),
                                      )
                                  )
                                ]
                            ),

                            TableRow(
                                children: [
                                  TableCell(
                                      child:Padding(
                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                          child: Text("Appointment Date",style:titletextStyle))
                                  ),
                                  TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 15.0),
                                        child: Text(":",style: dialogbuttonnormal,),
                                      )),
                                  TableCell(
                                      child:Center(
                                          child:Padding(
                                              padding: EdgeInsets.symmetric(vertical: 15.0),
                                              child:Text(widget.appoint['date'],style:titletextStyle))
                                      )
                                  )
                                ]
                            ),
                            TableRow(
                                children: [
                                  TableCell(
                                      child:Padding(
                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                          child:Text("Patient ID",style:titletextStyle))
                                  ),
                                  TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 15.0),
                                        child: Text(":",style: dialogbuttonnormal,),
                                      )),
                                  TableCell(
                                      child:Center(
                                          child:Padding(
                                              padding: EdgeInsets.symmetric(vertical: 15.0),
                                              child:Text(widget.appoint['patientid'],style:titletextStyle))
                                      )
                                  )
                                ]
                            ),
                            TableRow(
                                children: [
                                  TableCell(
                                      child:Padding(
                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                          child:Text("Doctor Name",style:titletextStyle))
                                  ),
                                  TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 15.0),
                                        child: Text(":",style: dialogbuttonnormal,),
                                      )),
                                  TableCell(
                                      child:Center(
                                          child:Padding(
                                              padding: EdgeInsets.symmetric(vertical: 15.0),
                                              child:Text(doctor['firstname']+" "+doctor['lastname'],style:titletextStyle))
                                      )
                                  )
                                ]
                            )
                          ],
                        ),
                      )
                  )
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(20),
                        child:TextFormField(
                          // showCursor: true,
                          readOnly: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              hintText: "Select Date",
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
                            var data = doctor_model(null, null, null, [selectedday], null, null, null, null);
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
                              hintText: "Select Doctor"
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
                  ],
                ),
              ),
              Container(),
              //Check doctor Availability
              Padding(padding: EdgeInsets.all(20.0),
                child: !check?CircularProgressIndicator():TextButton(
                  style:btnWoback,
                  child: Padding(padding: EdgeInsets.all(10),
                    child: Text("Check Doctor Availablity",
                      style: dialogbuttonnormal,
                    ),
                  ),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    var val=await checkAvail(_doctor,doctor['count']);
                    print(val);
                    if(val == "Success"){
                      setState(() {
                        check = true;
                      });
                    }
                  },
                ),
              ),
              avail != null?avail?Center(
                child: Text("Available",style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                ),),
              ):Center(
                child: Text("Not Available",style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                ),),
              ):Text(""),
              Padding(padding: EdgeInsets.all(10.0),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(padding: EdgeInsets.all(10),
                        child:TextButton(
                          style: buttonStyle,
                          child: Text("Cancel",
                            style: textStyle,
                          ),
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            _alertDialog(widget.appoint['refrenceID']);
                          },
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10),
                        child:TextButton(
                          style: buttonStyle,
                          child: Text("Approve",
                            style: textStyle,
                          ),
                          onPressed: () async {
                            if(_formKey.currentState.validate()){
                            FocusScope.of(context).unfocus();
                            avail?_approveDialog(widget.appoint['refrenceID'],_controller.text.trim(),_doctor):
                              toastMessage().toastMessages("Try with Changed Date");}
                          },
                        ),
                      ),
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}