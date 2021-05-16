import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospital_management/src/Pages/Doctor/Add_Doctor.dart';
import 'package:hospital_management/src/Services/Appointment_Service.dart';
import 'package:hospital_management/src/Services/Doctor_Service.dart';
import 'package:hospital_management/src/Widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../Menu.dart';
import '../../../functions.dart';
import '../../../styles.dart';
import '../../modelClass.dart';
import 'Update_doctor.dart';

class doctorList extends StatefulWidget{
  @override
  _doctorListState createState() => new _doctorListState();
}

class _doctorListState extends State<doctorList>{
  var _selected;
  int _itemCount = 10;
  var Speciality = widgetPage().Speciality;
  var _days = widgetPage().days;
  var _daysList;
  List _doctors = [];
  bool loaded=true;
  var Listtemp = ["item","item","item","item","item","item","item","item"];
  final RefreshController _refreshController = RefreshController();
  TextEditingController _fname = new TextEditingController();
  TextEditingController _lname = new TextEditingController();
  TextEditingController _did = new TextEditingController();
  TextEditingController _day = new TextEditingController();
  // TextEditingController _phone = new TextEditingController();

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

  //Opens alertbox confirmation for deletion of doctor
  _alertDialog(id){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text("Do You Want to Delete Doctor Details Permanently?"),
            contentTextStyle: contenttextStyle,
            actions: [
              TextButton(onPressed: () async{
                var response = await appointmentService().findAppoint(id);        // Checks if any appointment is there for this doctor
                if(response.length == 0) {
                  var result = await doctorService().deleteDoctor(id);
                  if (result == "Success") {
                    toastMessage().toastMessages(
                        "Doctor Deleted Successfully");
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(
                        builder: (BuildContext context) =>
                            doctorList()));
                  }
                  else {
                    toastMessage().toastMessages(
                        "Something Went Wrong");
                  }
                }else{
                  toastMessage().toastMessages(
                      "Doctor has Some Appointment");
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

  //Opens Search page as dialog box
  _showDialog(doctor){
    String days=doctor['days'].map((part) => "$part").join(', ');
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
                                                        child:Text("Doctor Name",style:titletextStyle)
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                        padding: EdgeInsets.symmetric(vertical: 15.0),
                                                        child:Text(doctor['firstname']+" "+doctor['lastname'],style:titletextStyle)),
                                                  )
                                                ]
                                            ),
                                            TableRow(
                                                children: [
                                                  TableCell(
                                                      child:Padding(
                                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                                          child: Text("Specialized",style:titletextStyle))
                                                  ),
                                                  TableCell(
                                                      child:Padding(
                                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                                          child:Text(doctor['specialized'],style:titletextStyle))
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
                                                      child:Padding(
                                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                                          child:Text(doctor['phonenumber'],style:titletextStyle))
                                                  )
                                                ]
                                            ),
                                            TableRow(
                                                children: [
                                                  TableCell(
                                                      child:Padding(
                                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                                          child:Text("Doctor ID",style:titletextStyle))
                                                  ),
                                                  TableCell(
                                                      child:Padding(
                                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                                          child:Text(doctor['doctorid'],style:titletextStyle))
                                                  )
                                                ]
                                            ),
                                            TableRow(
                                                children: [
                                                  TableCell(
                                                      child:Padding(
                                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                                          child:Text("Duty Days",style:titletextStyle))
                                                  ),
                                                  TableCell(
                                                      child:Padding(
                                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                                          child:Text(days,style:titletextStyle))
                                                  )
                                                ]
                                            ),
                                            TableRow(
                                                children: [
                                                  TableCell(
                                                      child:Padding(
                                                        padding: EdgeInsets.symmetric(vertical: 15.0),
                                                        child:Text("Appointment Can take per day",style:titletextStyle,softWrap: true,),)
                                                  ),
                                                  TableCell(
                                                      child:Padding(
                                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                                          child:Text(doctor['count'],style:titletextStyle))
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
                                TextButton(
                                    onPressed: (){
                                      inidicator();
                                      Navigator.push(context,MaterialPageRoute(builder: (context)=> updateDoctor(doctor: doctor,)));
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
                                      _alertDialog(doctor['refrenceID']);
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
                      widgetPage().textField("Doctor ID ",false,_did),
                      Padding(padding: EdgeInsets.only(top: 20.0,bottom: 10.0),
                          child:DropdownButtonFormField(
                            decoration: InputDecoration(
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
                        padding: EdgeInsets.only(top: 20.0,bottom: 10.0),
                        child:MultiSelectFormField(
                          autovalidate: false,
                          chipBackGroundColor: Colors.blueGrey,
                          checkBoxActiveColor: Colors.blueGrey,
                          checkBoxCheckColor: Colors.white,
                          title: Text(""),
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
                      widgetPage().numberField("Attends No. of Appointments per day",false,_day),

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
                                  _day.text ="";
                                  if(_selected != null) {
                                    _selected = null;
                                  }
                                  if(_daysList != null) {
                                    _daysList.clear();
                                  }
                                  _did.text ="";
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
                                var data= await doctor_model(_fname.text.trim(),_lname.text.trim(),_selected,_daysList,"",_did.text.trim(),_day.text.trim(),null);
                                getSearchdata(data);
                              },
                            ),
                          )
                        ],
                      )
                    ]
                ),
              ),
            ),
          );
        }
    );
  }

  getData() async{
    if (_doctors.length != 0) {
      _doctors.clear();
    }
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      doctorService().getDoctor().then((doc) async {
        setState(() {
          for (var i in doc) {
            _doctors.add(
                i.map((key, value) => MapEntry(key.toString(), value)));
          }
          // print(_doctors);
          loaded = false;
        });
      });
    }else{
      setState(() {
        loaded = false;
      });
      toastMessage().toastMessages(widgetPage().ConnectError);
    }
  }

  getSearchdata(Map<String, dynamic> data) async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      _doctors.clear();

      doctorService().getADoctor(data).then((doc) async {
        setState(() {
          if (doc != "Fail") {
            for (var i in doc) {
              _doctors.add(
                  i.map((key, value) => MapEntry(key.toString(), value)));
            }
            loaded = false;
          }
        });
      });
    }else{
      setState(() {
        loaded = false;
      });
      toastMessage().toastMessages(widgetPage().ConnectError);
    }
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
        title: Text("Doctor List"),
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
                builder: (context) => doctorList()),
          );

        },
        child: _doctors.length != 0 && _doctors != null?SingleChildScrollView(
            child:ListView.builder(
                shrinkWrap: true,
                controller: ScrollController(),
                itemCount: _doctors.length>_itemCount?_itemCount+1:_doctors.length,
                itemBuilder:(BuildContext Context,int index){
                  final Widget listTile = (index).toString() == (_itemCount).toString() || (_doctors.length).toString() == index.toString()
                      ? _reachedEnd()
                      :Padding(
                    padding: EdgeInsets.only(top:.5,bottom: .5),
                    child: Card(
                        child:ListTile(
                          title: InkWell(
                            onTap: (){
                              _showDialog(_doctors[index]);
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
                                            child: Text(_doctors[index]['firstname']+' '+_doctors[index]['lastname'],style: contenttextStyle,),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(padding: EdgeInsets.all(10.0),
                                      child:Row(
                                        children: [
                                          Icon(MdiIcons.badgeAccountOutline,color: Colors.blueGrey,size: 30.0,),
                                          Padding(padding: EdgeInsets.only(left: 10.0)),
                                          Flexible(
                                            child: Text(_doctors[index]['specialized'],style: contenttextStyle,),
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
            child:!loaded?Text("Doctor List Empty"):inidicator()
        ),
      ) ,

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => addDoctor()));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}

