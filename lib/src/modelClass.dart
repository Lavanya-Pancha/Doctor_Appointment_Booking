import 'package:flutter/cupertino.dart';

 patient_model(String fname,String lname,String age,String phone,String pid,String id,){

 Map<String, dynamic> patientMap={
     'firstname': fname,
     'lastname': lname,
     'age': age,
     'phonenumber': phone,
     'patientid': pid,
      'refrenceID':id
  };

  return patientMap;
 }

doctor_model(String fname,String lname,String special,List days,String phone,String did,String count,String id){

  Map<String, dynamic> patientMap={
    'firstname': fname,
    'lastname': lname,
    'specialized': special,
    'days': days,
    'phonenumber': phone,
    'doctorid': did,
    'count': count,
    'refrenceID':id
  };

  return patientMap;
}

appoint_model(String fname, String lname, String pid,String special,String date,String did,String scale,String status,String id){
   Map<String ,dynamic> appointMap={

       'patientname':fname != null && lname != null? fname + " " + lname:null,
     'patientid':pid,
     'specialized':special,
     'date':date,
     'doctorid':did,
     'severity':scale,
     'status':status,
     'refrenceID':id
   };

   return appointMap;
}


