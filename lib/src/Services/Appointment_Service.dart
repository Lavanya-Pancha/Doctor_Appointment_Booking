import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/equality.dart';
import 'package:intl/intl.dart';


class appointmentService{
  final _appointdb = FirebaseFirestore.instance.collection('Appointment_data');

  Future<Object> addappoint(Map data) async{                    // Adds appointment to Appoinment_data
    try{
      data.remove('refrenceID');
      await _appointdb.add(data);
      return "Success";
    }catch(e){
      print(e);
      return e.toString();
    }
  }



//Gets  specific appointment from db
  getAppoint(String id) async {
    Query query = _appointdb;
    List mapData = [];
    try{
      QuerySnapshot appointData = await query
          .where("patientid", isEqualTo: id != "" && id != null ? id : null)
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
      print(mapData);
      return mapData;
    }catch(e){
      return "Fail";
    }
  }


  //Gets all appointment list from db
  getAllAppoint(String id) async {
    Query query = _appointdb;
    List mapData = [];
    try{
      print(id);
      QuerySnapshot appointData = await query
          .where("doctorid", isEqualTo: id != "" && id != null ? id : null)
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
    }catch(e){
      return "Fail";
    }
  }


  //Update a appointment to db
  updateappoint(data) async {
    try{
      var id= data['refrenceID'];
      print(id);
      data.remove('refrenceID');
      if(id != null) {
        await _appointdb.doc(id).set(data);
      }
      return "Success";
    }catch(e){
      print(e);
      return e.toString();
    }
  }


  //Deletes the booking if admin cancels
  cancelBooking(String id) async{
    try{
      if(id != null) {
        await _appointdb.doc(id).delete();
      }
      return "Success";
    }catch(e){
      print(e);
      return e.toString();
    }

  }


  //Gets appoinment list for specific doctor id
  getappointsList() async{
    List mapData=[];
    try{
      QuerySnapshot appointList =  await _appointdb.get();
      final allData = appointList.docs.map((doc)=>
          doc.data()
      ).toList();

      for(var i in allData){
        var mapTemp = Map<String, dynamic>.from(i);
        for(var j in appointList.docs){
          if(DeepCollectionEquality().equals(i, j.data())){
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


  //Changes the status of appointment as booked
  approveApoint(String id, String date,String did) async {
    try{
      if(id != null) {
        await _appointdb.doc(id).update({"status":"Booked","date":date,"doctorid":did});
      }
      return "Success";
    }catch(e){
      print(e);
      return e.toString();
    }
  }


  // Deletes appointment which date is completed
  deleteAppointments(List appoints) {
    try{
      for(var i in appoints)
        {
          DateTime now = DateTime.now();
          DateTime date= DateFormat('dd-MM-yyyy').parse(i['date']);
          print(date);
          var day = DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
          if( day == -1 && i['status'] == "Booked"){
            _appointdb.doc(i['refrenceID']).delete();
          }
        }
    }catch(e){
    return e.toString();
    }
  }

  //find appoint of doctor which prevents a user to delete the doctor
  findAppoint(id) async {
    var data;
    try{
      if(id != null){
        await _appointdb.where("doctorid", isEqualTo: id != "" ?id: null).get().then((value){
          data = value.docs.map((doc) =>
              doc.data()
          ).toList();

        });

      }
      return data;
    }catch (e){
      return e.toString();
    }
  }


  //find appoint of patient which prevents a user to delete the patient
  findAppointofPatient(id) async {
    var data;
    try{
      if(id != null){
        await _appointdb.where("patientid", isEqualTo: id != "" ?id: null).get().then((value){
          data = value.docs.map((doc) =>
              doc.data()
          ).toList();

        });

      }
      return data;
    }catch (e){
      return e.toString();
    }
  }
}
