
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/auth_service.dart';


class AuthBloc {
  DatabaseReference database = FirebaseDatabase.instance.ref();
  final authService = AuthService();
  final googleSignIn = GoogleSignIn(scopes: ['email']);
  Stream<User?> get currentUser => authService.currentUser;
  loginGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

       SharedPreferences preference = await SharedPreferences.getInstance();



      //Entrar en Firebase
      final result = await authService.sinInWhitCredential(credential);
      String disp = preference.getString('disp') ?? '1000';

      database.ref.child('disp'+disp).update({
        'name': result.user!.displayName,
        'email': result.user!.email,
        'foto': result.user!.photoURL,
      });

      if (kDebugMode) {
        print('${result.user!.displayName}');
        print('${result.user!.email}');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  logout() {
    authService.logout();
  }
}
