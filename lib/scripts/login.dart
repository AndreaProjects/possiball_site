import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:possiball_site/utils/snackbar.dart';

class Login {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signInWithEmailAndPassword(
      String email, String password, context) async {
    try {
      Query exist = FirebaseFirestore.instance
          .collection("Users")
          .where("email", isEqualTo: email)
          .where("ruolo", isEqualTo: "admin");

      var docs = await exist.get();

      if (docs.docs.length == 1) {
        UserCredential user = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        if (user.user?.email != null) {
          return true;
        }
        return false;
      } else {
        showSnackBar(context, "Devi inserire un account admin");
        return false;
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'INVALID_LOGIN_CREDENTIALS':
            showSnackBar(context, 'Credenziali di accesso errate, riprova.');
            break;
          case 'user-not-found':
            showSnackBar(context,
                'Utente non trovato. Verifica l\'indirizzo email inserito.');
            break;
          case 'wrong-password':
            showSnackBar(
                context, 'Password errata. Verifica la password inserita.');
            break;
          case 'invalid-email':
            showSnackBar(context, 'Inserisci correttamente una email');
          default:
            showSnackBar(context, 'Errore durante il login: ${e.message}');
        }
      } else {
        throw ('Errore sconosciuto durante il login: $e');
      }
      return false;
    }
  }
}
