import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospital_management/src/Widgets.dart';

class LoginService{
  final FirebaseAuth _firebaseAuth;

  LoginService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();


  //Let user to sign in
  Future<String> LogIn({String email,String password}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      try {
        var res = await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        print("sign");
        print(res);
        return "Success";
      } on FirebaseAuthException catch (e) {
        print(e);
        return "Fail";
      }
    }else{
      return widgetPage().ConnectError;
    }
  }


  // Let user to sign out
  Future Signout() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      try {
        await _firebaseAuth.signOut();
        return "Success";
      } catch (E) {
        return "Fail";
      }
    } else {
      return widgetPage().ConnectError;
    }
  }
}