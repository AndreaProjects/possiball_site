import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:possiball_site/components/managecontactcomponent.dart';
import 'package:possiball_site/components/permission.dart';
import 'package:possiball_site/screens/enablecontacts.dart';
import 'package:possiball_site/utils/custompagetransitions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ManageContactsScreen extends StatefulWidget {
  const ManageContactsScreen({super.key});

  @override
  State<ManageContactsScreen> createState() => _ManageContactsScreenState();
}

class _ManageContactsScreenState extends State<ManageContactsScreen> {
  String? _userEmail;
  bool forEmail = true;

  Future<String?> getSocieta() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('id-societa');
  }

  Future<QuerySnapshot<Map<String, dynamic>>>? society() async {
    try {
      return FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .where('accountType', isEqualTo: 'societa')
          .get();
    } catch (e) {
      print(e);
      throw "erorre";
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>>? allFalseUsers(
      String? societa) async {
    if (_userEmail == null) {
      return FirebaseFirestore.instance
          .collection('Users')
          .where('squadra', isEqualTo: societa)
          .where("accountType",
              whereIn: ["membro", "famiglia", "societa"]).get();
    } else {
      if (forEmail) {
        return FirebaseFirestore.instance
            .collection('Users')
            .where('squadra', isEqualTo: societa)
            .where("accountType", whereIn: ["membro", "famiglia", "societa"])
            .where('email', isGreaterThanOrEqualTo: _userEmail!.toLowerCase())
            .where('email',
                isLessThanOrEqualTo:
                    "${_userEmail?.toLowerCase() ?? ""}" '\uf8ff')
            .get();
      } else {
        return FirebaseFirestore.instance
            .collection('Users')
            .where('squadra', isEqualTo: societa)
            .where("accountType", whereIn: ["membro", "famiglia", "societa"])
            .where('nameLowerCase',
                isGreaterThanOrEqualTo: _userEmail!.toLowerCase())
            .where('nameLowerCase',
                isLessThanOrEqualTo:
                    "${_userEmail?.toLowerCase() ?? ""}" '\uf8ff')
            .get();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestione contatti"),
        actions: [
          FutureBuilder(
              future: society(),
              builder: (context, snapshot) {
                print("AAAAAAA");
                if (snapshot.hasData) {
                  var soc = snapshot.data!.docs;
                  var user = soc[0];

                  String email = user["email"];

                  return TextButton(
                      onPressed: () => Navigator.push(
                            context,
                            RightPageRoute(
                              child: EnableContacts(email: email),
                            ),
                          ),
                      child: Text(
                        "Contatti della società",
                        style: TextStyle(color: Colors.white),
                      ));
                } else {
                  return SizedBox();
                }
              }),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 700,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ToggleSwitch(
                    minWidth: 230.0,
                    initialLabelIndex: forEmail ? 0 : 1,
                    cornerRadius: 7.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.black.withOpacity(0.2),
                    inactiveFgColor: Colors.white,
                    totalSwitches: 2,
                    labels: const ["Cerca per email", "Cerca per nome"],
                    activeBgColors: [
                      [Colors.white.withOpacity(0.2)],
                      [Colors.white.withOpacity(0.2)]
                    ],
                    onToggle: (index) => setState(() {
                          if (index == 1) {
                            forEmail = false;
                          } else {
                            forEmail = true;
                          }
                        })),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) => setState(() {
                  value.isEmpty ? _userEmail = null : _userEmail = value;
                }),
                decoration: InputDecoration(
                  fillColor: Colors.white.withOpacity(0.3),
                  filled: true,
                  hintText: forEmail
                      ? "cerca utente per email..."
                      : "cerca utente per nome...",
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: getSocieta(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      return FutureBuilder(
                        future: allFalseUsers(snapshot.data),
                        builder: (context, snapshot2) {
                          if (snapshot2.hasData) {
                            var users = snapshot2.data!.docs;
                            if (users.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 100),
                                  child: Text('Nessun utente'),
                                ),
                              );
                            }

                            return Expanded(
                                child: ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                var user = users[index];
                                String name = user["name"];
                                String email = user["email"];
                                String account = user["accountType"];

                                return ManageContactComponent(
                                  name: name,
                                  email: email,
                                  contacts: account,
                                );
                              },
                            ));
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
