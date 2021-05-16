import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospital_management/Menu.dart';
import 'package:hospital_management/functions.dart';
import 'package:hospital_management/src/Pages/Appointment/Book_Appointment.dart';
import 'package:hospital_management/src/Pages/Appointment/Update_appointment.dart';
import 'package:hospital_management/src/Pages/Patient/Add_Patient.dart';
import 'package:hospital_management/src/Services/Appointment_Service.dart';
import 'package:hospital_management/src/Services/Patient_Service.dart';
import 'package:hospital_management/src/Widgets.dart';
import 'package:hospital_management/src/modelClass.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../styles.dart';
import 'Update_patient.dart';

class patientList extends StatefulWidget{
  @override
  _patientListState createState() => new _patientListState();
}

class _patientListState extends State<patientList>{
  var _selected;
  int _itemCount = 10;
  var Speciality = widgetPage().Speciality;
  var _days = widgetPage().days;
  var _daysList;
  List _patients = [];
  List appoints = [];
  bool loaded=true,_booked = false;
  var Listtemp = ["item","item","item","item","item","item","item","item"];
  final RefreshController _refreshController = RefreshController();
  TextEditingController _fname = new TextEditingController();
  TextEditingController _lname = new TextEditingController();
  TextEditingController _age = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _pid = new TextEditingController();

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


  //opens confirmation dialog box to delete the patient
  _alertDialog(String id, patient){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text("Do You Want to Delete Patient Details Permanently?"),
            contentTextStyle: contenttextStyle,
            actions: [
              TextButton(onPressed: () async {
                var response= await appointmentService().findAppointofPatient(patient);        // Checks if any appointment is there for this patient
                if(response.length == 0) {
                  var result = await patientService().deletePatient(id);
                  if (result == "Success") {
                    toastMessage().toastMessages(
                        "Patient Deleted Successfully");
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(
                        builder: (BuildContext context) =>
                            patientList()));
                  }
                  else {
                    toastMessage().toastMessages(
                        "Something Went Wrong");
                  }
                }else{
                  toastMessage().toastMessages(
                      "Patient has Some Appointments");
                }
              },
                  child:Text("Yes, Delete",
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


  //search page for Patient as dialog
  _showDialog(patient){
    return showDialog(context: context,
        barrierDismissible: true,
        builder:(BuildContext context){
          return SimpleDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              // backgroundColor: Colors.=,//this right here
              children:<Widget>[
                Container(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                          child: Container(
                            alignment: FractionalOffset.topRight,
                            child: GestureDetector(child: CircleAvatar(
                              radius: 14.0,
                              backgroundColor: Colors.blueGrey,
                              child: Icon(Icons.close, color: Colors.white,
                              ),),
                              onTap: (){
                                Navigator.pop(context);
                              },),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height/2.3,
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            child:Column(
                              children: [
                                Padding(
                                    padding:EdgeInsets.only(top:30.0,left: 20.0,right: 10.0),
                                    child:Center(
                                        child:Table(
                                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                          columnWidths: {
                                            0:FlexColumnWidth(3),
                                            1:FlexColumnWidth(3),
                                          },
                                          // border: TableBorder.all(color: Colors.black),
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
                                                      child:Center(
                                                        child:Padding(
                                                            padding: EdgeInsets.symmetric(vertical: 15.0),
                                                            child:Text(patient['firstname']+" "+patient['lastname'],style:titletextStyle)),
                                                      )
                                                  )
                                                ]
                                            ),
                                            TableRow(
                                                children: [
                                                  TableCell(
                                                      child:Padding(
                                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                                          child: Text("Patient Age",style:titletextStyle))
                                                  ),
                                                  TableCell(
                                                      child:Center(
                                                          child:Padding(
                                                              padding: EdgeInsets.symmetric(vertical: 15.0),
                                                              child:Text(patient['age'],style:titletextStyle))
                                                      )
                                                  )
                                                ]
                                            ),
                                            TableRow(
                                                children: [
                                                  TableCell(
                                                      child:Padding(
                                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                                          child:Text("Phone Number",style:titletextStyle))
                                                  ),
                                                  TableCell(
                                                      child:Center(
                                                          child:Padding(
                                                              padding: EdgeInsets.symmetric(vertical: 15.0),
                                                              child:Text(patient['phonenumber'],style:titletextStyle))
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
                                                      child:Center(
                                                          child:Padding(
                                                              padding: EdgeInsets.symmetric(vertical: 15.0),
                                                              child:Text(patient['patientid'],style:titletextStyle))
                                                      )
                                                  )
                                                ]
                                            )
                                          ],
                                        )
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top:20.0),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _booked?TextButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateAppointment(patient: patient,appoints:appoints[0])));
                                    },
                                    child:Column(
                                      children: [
                                        Icon(
                                            MdiIcons.calendar
                                        ),
                                        Text('Update', style: dialogbuttonnormal,textAlign: TextAlign.center,softWrap: true,),
                                        Text(' Appointment', style: dialogbuttonnormal,textAlign: TextAlign.center,softWrap: true,)
                                      ],
                                    )
                                ):TextButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>bookAppointment(patient: patient)));
                                    },
                                    child:Column(
                                      children: [
                                        Icon(
                                            MdiIcons.calendar
                                        ),
                                        Text('Create', style: dialogbuttonnormal,textAlign: TextAlign.center,softWrap: true,),
                                        Text(' Appointment', style: dialogbuttonnormal,textAlign: TextAlign.center,softWrap: true,)
                                      ],
                                    )
                                ),
                                TextButton(
                                    onPressed: (){
                                      // inidicator();
                                      Navigator.push(context,MaterialPageRoute(builder: (context)=> updatePatient(patient: patient,)));
                                    },
                                    child:Column(
                                      children: [
                                        Icon(
                                            MdiIcons.accountEdit
                                        ),
                                        Text('Edit', style: dialogbuttonnormal,textAlign: TextAlign.center,)
                                      ],
                                    )
                                ),
                                TextButton(
                                    onPressed: (){
                                      _alertDialog(patient['refrenceID'],patient['patientid']);
                                    },
                                    child:Column(
                                      children: [
                                        Icon(
                                            MdiIcons.trashCanOutline
                                        ),
                                        Text('Delete', style: dialogbuttonnormal,textAlign: TextAlign.center,)
                                      ],
                                    )
                                ),

                              ],
                            )
                        )
                      ],
                    )
                ),
              ]
          );
        }
    );
  }

  _modalBottom(){
    return showDialog(context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return Dialog(
              child:SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                      children:[
                        widgetPage().textField("First Name ",false,_fname),
                        widgetPage().textField("Last Name ",false,_lname),
                        widgetPage().numberField("Patient Age ",false,_age),
                        widgetPage().phoneField("Phone Number ",false,_phone),
                        widgetPage().textField("Patient Hospital ID",false,_pid),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.all(10.0),
                              child: TextButton(
                                child: Text("Clear Search",
                                  style: dialogbuttonnormal,
                                ),
                                onPressed: (){
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    loaded = true;
                                    _fname.text ="";
                                    _lname.text ="";
                                    _age.text ="";
                                    _phone.text ="";
                                    _pid.text ="";
                                  });
                                  Navigator.pop(context);
                                  getData();
                                },
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(10.0),
                              child: TextButton(
                                // style: buttonStyle,
                                child: Text("Search",
                                  style: dialogbuttonnormal,
                                ),
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    loaded = true;
                                  });
                                  Navigator.pop(context);
                                  var data= await patient_model(_fname.text.trim(),_lname.text.trim(),_age.text.trim(),_phone.text.trim(),_pid.text.trim(),null);
                                  getSearchdata(data);
                                },
                              ),
                            )
                          ],
                        )
                      ]
                  ),
                ),
              )
          );
        }
    );
  }

  getData() async{
    if(_patients.length != 0){
      _patients.clear();
    }
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      patientService().getPatient().then((doc) async {
        setState(() {
          for (var i in doc) {
            _patients.add(
                i.map((key, value) => MapEntry(key.toString(), value)));
          }
          loaded = false;
        });
      });
    }else{
      setState(() {
        loaded = true;
      });
      toastMessage().toastMessages(widgetPage().ConnectError);
    }
  }

  getSearchdata(Map<String, dynamic> data) async{
    _patients.clear();
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      patientService().getAPatient(data).then((doc) async {
        setState(() {
          if (doc != "Fail") {
            for (var i in doc) {
              _patients.add(
                  i.map((key, value) => MapEntry(key.toString(), value)));
            }
            loaded = false;
          }
        });
      });
    }else{
      setState(() {
        loaded = true;
      });
      toastMessage().toastMessages(widgetPage().ConnectError);
    }
  }

  getappoints(patient) async {
    await appointmentService().getAppoint(patient).then((val){
      setState(() {
        if(val != "Fail"){
          print(val);
          for (var i in val) {
            appoints.add(
                i.map((key, value) => MapEntry(key.toString(), value)));
            appoints[0]['status'] == "Pending"?_booked = true:_booked=false;
          }
        }
      });
    });

    return appoints;
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1),() async{
      getData();
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
        title: Text("Patient List"),
        actions: [
          new Padding(padding: EdgeInsets.only(right: 20),
              child: IconButton(icon: Icon(Icons.search_rounded),
                  onPressed: () {
                    _modalBottom(); //Opens Modal bottom sheet
                  }
              )
          )
        ],
      ),
      body:SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1000));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => patientList()),
          );

        },
        child: _patients.length != 0 && _patients != null?SingleChildScrollView(
            child:ListView.builder(
                shrinkWrap: true,
                controller: ScrollController(),
                itemCount: _patients.length>_itemCount?_itemCount+1:_patients.length,
                itemBuilder:(BuildContext Context,int index){
                  final Widget listTile = (index).toString() == (_itemCount).toString() || (_patients.length).toString() == index.toString()
                      ? _reachedEnd()
                      :Padding(
                    padding: EdgeInsets.only(top:.5,bottom: .5),
                    child: Card(
                        child:ListTile(
                          title: InkWell(
                            onTap: () async {
                              await getappoints(_patients[index]['patientid']).then((val){
                                print("klo");
                                print(val);
                                _showDialog(_patients[index]);
                              });
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
                                            child: Text(_patients[index]['firstname']+' '+_patients[index]['lastname'],style: contenttextStyle,),
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
                                            child: Text(_patients[index]['patientid'],style: contenttextStyle,),
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
            child:!loaded?Text("Patient List Empty"):inidicator()
        ),
      ) ,

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => addPatient()));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }


}
