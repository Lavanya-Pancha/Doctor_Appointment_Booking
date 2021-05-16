import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospital_management/Menu.dart';
import 'package:hospital_management/functions.dart';
import 'package:hospital_management/src/Pages/Appointment/Approve_appointment.dart';
import 'package:hospital_management/src/Pages/Appointment/Book_Appointment.dart';
import 'package:hospital_management/src/Pages/Appointment/Update_appointment.dart';
import 'package:hospital_management/src/Pages/Patient/Add_Patient.dart';
import 'package:hospital_management/src/Services/Appointment_Service.dart';
import 'package:hospital_management/src/Services/Doctor_Service.dart';
import 'package:hospital_management/src/Services/Patient_Service.dart';
import 'package:hospital_management/src/Widgets.dart';
import 'package:hospital_management/src/modelClass.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../styles.dart';
// import 'Update_patient.dart';

class appointmentList extends StatefulWidget{
  @override
  _appointmentListState createState() => new _appointmentListState();
}

class _appointmentListState extends State<appointmentList>{
  final RefreshController _refreshController = RefreshController();
  int _itemCount = 10;
  List _appoints=[];
  List appointList=[];
  var doctor;
  bool loaded=true,check=true,avail;
  void _refreshFriendList() {
    new Future<dynamic>.delayed(new Duration(seconds: 5)).then((_){
      setState(() {
        _itemCount = _itemCount + 10; // update the item count to notify newly added friend list
      });
    });
  }

  Widget _reachedEnd(){
    _refreshFriendList();
    return const Padding(
      padding: const EdgeInsets.all(20.0),
      child: const Center(
          child:CircularProgressIndicator()
      ),
    );
  }

  getData() async{
    if(_appoints.length != 0){
      _appoints.clear();
    }
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      appointmentService().getappointsList().then((
          doc) async { // Gets all Appointment list from database
        setState(() {
          for (var i in doc) {
            _appoints.add(i.map((key, value) =>
                MapEntry(key.toString(),
                    value))); // Converts QuerySnapshot to List of map
          }
          appointmentService().deleteAppointments(_appoints);               // Deletes the appointment after the scheduled date
          loaded = false;
        });
      });
    }else{
      toastMessage().toastMessages(widgetPage().ConnectError);
      setState(() {
        loaded = false;
      });
    }
  }
  getDoctor(String appoint) async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      await doctorService().getDoctorDetials(appoint).then((
          val) { // Gets Specific doctor details with doctor id which got from appointment list
        if (val != "Fail") {
          setState(() {
            doctor = val;
          });
        }
      });
      return "Success";
    }
    else{
      toastMessage().toastMessages(widgetPage().ConnectError);
    }
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1),() async{
      getData();                                                                // Loads data on page load
    });
    // print(loaded);
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
        title: Text("Appointment List"),

      ),
      body:SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1000));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>appointmentList()));

        },
        child: _appoints.length != 0 && _appoints != null?SingleChildScrollView(
            child:ListView.builder(
                shrinkWrap: true,
                controller: ScrollController(),
                itemCount: _appoints.length>_itemCount?_itemCount+1:_appoints.length,
                itemBuilder:(BuildContext Context,int index){
                  final Widget listTile = (index).toString() == (_itemCount).toString() || (_appoints.length).toString() == index.toString()
                      ? _reachedEnd()
                      :Padding(
                    padding: EdgeInsets.only(top:.5,bottom: .5),
                    child: Card(
                        child:ListTile(
                          title: InkWell(
                            onTap: () async {
                              var val = await getDoctor(_appoints[index]['doctorid']);
                              if(val == "Success") {
                                _appoints[index]['status']=="Pending"?Navigator.pushReplacement(     //Here checks status of appointment if Pending moves to next page otherwise its restricted
                                    context, MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        approveAppointment(appoint:_appoints[index]))):
                                toastMessage().toastMessages("Booked Appointment");
                              }
                            },
                            child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Padding(padding: EdgeInsets.all(10.0),
                                      child:Row(
                                        children: [
                                          Icon(Icons.person,color: Colors.blueGrey,size: 30.0,),
                                          Padding(padding: EdgeInsets.only(left: 10.0)),
                                          Flexible(
                                            child: Text(_appoints[index]['patientname'],style: contenttextStyle,),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(padding: EdgeInsets.all(10.0),
                                      child:Row(
                                        children: [
                                          Icon(MdiIcons.identifier,color: Colors.blueGrey,size: 30.0,),
                                          Padding(padding: EdgeInsets.only(left: 10.0)),
                                          Flexible(
                                            child: Text(_appoints[index]['patientid'],style: contenttextStyle,),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.all(10.0),
                                      child:Row(
                                        children: [
                                          Icon(MdiIcons.listStatus,color: Colors.blueGrey,size: 30.0,),
                                          Padding(padding: EdgeInsets.only(left: 10.0)),
                                          Flexible(
                                            child: Text(_appoints[index]['status'],style: contenttextStyle,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                            ),

                          ),
                          trailing: Padding(padding:EdgeInsets.only(top:40),child: Icon(Icons.arrow_forward_ios)),
                        )
                    ),
                  );
                  return listTile;
                }
            )
        ):Center(
            child:!loaded?Text("Appointment List Empty"):inidicator()
        ),
      ) ,
    );
  }
}
