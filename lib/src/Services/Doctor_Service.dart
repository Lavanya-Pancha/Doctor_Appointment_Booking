import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/equality.dart';
import 'package:hospital_management/src/Widgets.dart';


class doctorService{
  final _doctordb = FirebaseFirestore.instance.collection('Doctor_data');


  //adds doctor to db
  Future<Object> addDoctor(Map data) async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
    try{
      data.remove('refrenceID');
      await _doctordb.add(data);
      return "Success";
    }catch(e){
      print(e);
      return e.toString();
    }
    }else{
      return widgetPage().ConnectError;
    }
  }

  // get Doctor from db
  getDoctor() async{
    List mapData=[];
    try{
      QuerySnapshot doctorList =  await _doctordb.get();
      final allData = doctorList.docs.map((doc)=>
          doc.data()
      ).toList();

      for(var i in allData){
        var mapTemp = Map<String, dynamic>.from(i);
        for(var j in doctorList.docs){
          if(DeepCollectionEquality().equals(i, j.data())){
            mapTemp["refrenceID"]=j.reference.id;                             //This line refrence to get document id and also adds to the converted map
            mapData.add(mapTemp);
          }
        }
      }
      return mapData;
    }catch(e){
      print(e);
      return e.toString();
    }
  }


  //Get a doctor with completing all conditions
  Future getADoctor(Map<String, dynamic> data) async {
    Query query = _doctordb;
    var allData;
    List mapData = [];
      try {
        data.remove('refrenceID');
        QuerySnapshot doctorData = await query
            .where("firstname", isEqualTo: data['firstname'] != "" ? data['firstname'] : null)
            .where("lastname", isEqualTo: data['lastname'] != "" ? data['lastname'] : null)
            .where("specialized", isEqualTo: data['specialized'] != "" ? data['specialized'] : null)
            .where("days", arrayContainsAny: data['days'] != "" ? data['days'] : null)
            .where("count", isEqualTo: data['count'] != "" ? data['count'] : null)
            .where("doctorid", isEqualTo: data['doctorid'] != "" ? data['doctorid'] : null)
            .get()
            .then((value) {
          final allData = value.docs.map((doc) =>
              doc.data()
          ).toList();

          for (var i in allData) {
            var mapTemp = Map<String, dynamic>.from(i);
            for (var j in value.docs) {
              if (DeepCollectionEquality().equals(i, j.data())) {
                mapTemp["refrenceID"] = j.reference.id;
                mapData.add(mapTemp);
              }
            }
          }
        });
        return mapData;
      } catch (e) {
        return "Fail";
      }
  }


  //Updates a doctor with document id
  updateDoctor(data) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      try {
        print(data['days']);
        var id = data['refrenceID'];
        data.remove('refrenceID');
        if (id != null) {
          await _doctordb.doc(id).set(data);
        }
        return "Success";
      } catch (e) {
        print(e);
        return e.toString();
      }
    }else{
      return widgetPage().ConnectError;
    }
  }


  //deletes the doctor with document id
  deleteDoctor(String id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      try {
        if (id != null) {
          await _doctordb.doc(id).delete();
        }
        return "Success";
      } catch (e) {
        return e.toString();
      }
    }else{
      return widgetPage().ConnectError;
    }
  }


  //Get doctor details with specific id
  getDoctorDetials(String id) async{
    var allData;
    Map mapTemp;
    try{
      if(id != null){
         allData=await _doctordb.doc(id).get();

      }
      return allData.data();
    }catch(e){
      return "Fail";
    }
  }
}