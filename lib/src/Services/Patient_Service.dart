import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class patientService{
  final _patientdb = FirebaseFirestore.instance.collection('Patient_data');


  //Add patient to db
  Future<Object> addPatient(Map data) async{
    try{
      data.remove('refrenceID');
      await _patientdb.add(data);
      return "Success";
    }catch(e){
      print(e);
      return e.toString();
    }
  }


  //Get all patient from db
  getPatient() async{
    List mapData=[];
    try{
      QuerySnapshot patientList =  await _patientdb.get();
      final allData = patientList.docs.map((doc)=>
         doc.data()
      ).toList();

      for(var i in allData){
        var mapTemp = Map<String, dynamic>.from(i);
        for(var j in patientList.docs){
          if(mapEquals(i, j.data())){
            mapTemp["refrenceID"]=j.reference.id;
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


  //Get a patient which matches with conditions
  Future getAPatient(Map<String, dynamic> data) async {
    Query query = _patientdb;
    var allData;
    List mapData = [];
      try {
        data.remove('refrenceID');
        QuerySnapshot patientData = await query
            .where("firstname",
            isEqualTo: data['firstname'] != "" ? data['firstname'] : null)
            .where("lastname",
            isEqualTo: data['lastname'] != "" ? data['lastname'] : null)
            .where("age", isEqualTo: data['age'] != "" ? data['age'] : null)
            .where("phonenumber",
            isEqualTo: data['phonenumber'] != "" ? data['phonenumber'] : null)
            .where("patientid",
            isEqualTo: data['patientid'] != "" ? data['patientid'] : null)
            .get()
            .then((value) {
          final allData = value.docs.map((doc) =>
              doc.data()
          ).toList();

          for (var i in allData) {
            var mapTemp = Map<String, dynamic>.from(i);
            for (var j in value.docs) {
              if (mapEquals(i, j.data())) {
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


  //Update specific patient
  updatePatient(data) async {
    try{
      var id= data['refrenceID'];
      data.remove('refrenceID');
      print(data);
      if(id != null) {
        await _patientdb.doc(id).set(data);
      }
      return "Success";
    }catch(e){
      print(e);
      return e.toString();
    }
  }


  // deletes specific patient
  deletePatient(String id) async {
    try{
      if(id != null){
        await _patientdb.doc(id).delete();
      }
      return "Success";
    }catch(e){
      return e.toString();
    }
  }
}