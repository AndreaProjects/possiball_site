import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PermissionComponent extends StatefulWidget {
  const PermissionComponent(
      {super.key,
      required this.name,
      required this.email,
      required this.status});

  final String name;
  final String email;
  final bool status;

  @override
  State<PermissionComponent> createState() => _PermissionComponentState();
}

class _PermissionComponentState extends State<PermissionComponent> {
  void changeState(index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idSocieta = preferences.getString('id-societa');

    CollectionReference collection =
        FirebaseFirestore.instance.collection('Users');
    QuerySnapshot querySnapshot = await collection
        .where('squadra', isEqualTo: idSocieta)
        .where("accountType", whereIn: ["membro", "famiglia"])
        .where("email", isEqualTo: widget.email)
        .get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await collection.doc(documentSnapshot.id).update({
        'access': index == 0 ? true : false,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.1)),
      child: Row(
        children: [
          Expanded(
              child: Row(
            children: [
              Text(
                widget.name,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                width: 20,
                child: Text(
                  "|",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w100),
                ),
              ),
              Text(widget.email),
            ],
          )),
          ToggleSwitch(
            minWidth: 90.0,
            initialLabelIndex: widget.status ? 0 : 1,
            cornerRadius: 7.0,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.black.withOpacity(0.2),
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            icons: const [Icons.check, Icons.close],
            activeBgColors: const [
              [Colors.green],
              [Colors.red]
            ],
            onToggle: (index) => changeState(index),
          ),
        ],
      ),
    );
  }
}

class PermissionComponentContacts extends StatefulWidget {
  const PermissionComponentContacts(
      {super.key,
      required this.name,
      required this.email,
      required this.userEmail,
      required this.status});

  final String name;
  final String email;
  final bool status;
  final String userEmail;

  @override
  State<PermissionComponentContacts> createState() =>
      _PermissionComponentContactsState();
}

class _PermissionComponentContactsState
    extends State<PermissionComponentContacts> {
  Future<void> changeState(index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idSocieta = preferences.getString('id-societa');
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');

    QuerySnapshot querySnapshot =
        await usersCollection.where("email", isEqualTo: widget.userEmail).get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    if (documents.isNotEmpty) {
      QueryDocumentSnapshot document = documents.first;
      String documentId = document.id;
      Map<String, dynamic> newData;
      if (index == 1) {
        newData = {
          'contacts': FieldValue.arrayRemove([widget.email]),
        };
      } else {
        newData = {
          'contacts': FieldValue.arrayUnion([widget.email]),
        };
      }

      await usersCollection.doc(documentId).update(newData);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.1)),
      child: Row(
        children: [
          Expanded(
              child: Row(
            children: [
              Text(
                widget.name,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                width: 20,
                child: Text(
                  "|",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w100),
                ),
              ),
              Text(widget.email),
            ],
          )),
          ToggleSwitch(
            minWidth: 90.0,
            initialLabelIndex: widget.status ? 0 : 1,
            cornerRadius: 7.0,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.black.withOpacity(0.2),
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            icons: const [Icons.check, Icons.close],
            activeBgColors: const [
              [Colors.green],
              [Colors.red]
            ],
            onToggle: (index) => changeState(index),
          ),
        ],
      ),
    );
  }
}

class PermissionComponentAdmin extends StatefulWidget {
  const PermissionComponentAdmin(
      {super.key,
      required this.name,
      required this.email,
      required this.status});

  final String name;
  final String email;
  final bool status;

  @override
  State<PermissionComponentAdmin> createState() =>
      _PermissionComponentAdminState();
}

class _PermissionComponentAdminState extends State<PermissionComponentAdmin> {
  void changeState(index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idSocieta = preferences.getString('id-societa');

    CollectionReference collection =
        FirebaseFirestore.instance.collection('Users');
    QuerySnapshot querySnapshot = await collection
        .where('squadra', isEqualTo: idSocieta)
        .where("accountType", whereIn: ["membro", "famiglia"])
        .where("email", isEqualTo: widget.email)
        .get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await collection.doc(documentSnapshot.id).update({
        'ruolo': index == 0 ? "admin" : "",
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.1)),
      child: Row(
        children: [
          Expanded(
              child: Row(
            children: [
              Text(
                widget.name,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                width: 20,
                child: Text(
                  "|",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w100),
                ),
              ),
              Text(widget.email),
            ],
          )),
          ToggleSwitch(
            minWidth: 90.0,
            initialLabelIndex: widget.status ? 0 : 1,
            cornerRadius: 7.0,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.black.withOpacity(0.2),
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            icons: const [Icons.check, Icons.close],
            activeBgColors: const [
              [Colors.green],
              [Colors.red]
            ],
            onToggle: (index) => changeState(index),
          ),
        ],
      ),
    );
  }
}
