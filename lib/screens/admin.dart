import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:possiball_site/components/permission.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String? _userEmail;
  bool forEmail = true;

  Future<String?> getSocieta() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('id-societa');
  }

  Future<QuerySnapshot<Map<String, dynamic>>>? allFalseUsers(
      String? societa) async {
    if (_userEmail == null) {
      return FirebaseFirestore.instance
          .collection('Users')
          .where('squadra', isEqualTo: societa)
          .where("accountType", whereIn: ["membro"]).get();
    } else {
      if (forEmail) {
        return FirebaseFirestore.instance
            .collection('Users')
            .where('squadra', isEqualTo: societa)
            .where("accountType", whereIn: ["membro"])
            .where('email', isGreaterThanOrEqualTo: _userEmail!.toLowerCase())
            .where('email',
                isLessThanOrEqualTo:
                    "${_userEmail?.toLowerCase() ?? ""}" '\uf8ff')
            .get();
      } else {
        return FirebaseFirestore.instance
            .collection('Users')
            .where('squadra', isEqualTo: societa)
            .where("accountType", whereIn: ["membro"])
            .where('nameLowerCase',
                isGreaterThanOrEqualTo: _userEmail!.toLowerCase())
            .where('nameLowerCase',
                isLessThanOrEqualTo:
                    "${_userEmail?.toLowerCase() ?? ""}" '\uf8ff')
            .get();
      }
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>>? takeContacts() {
    return FirebaseFirestore.instance.collection('Users').get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account admin"),
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Utenti:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Accesso admin:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
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
                        builder: (context, usersData) {
                          if (usersData.hasData) {
                            return FutureBuilder(
                              future: takeContacts(),
                              builder: (context, userInfo) {
                                if (userInfo.hasData) {
                                  var users = usersData.data!.docs;
                                  var userInfoTook = userInfo.data!.docs[0];
                                  var userContacts =
                                      userInfoTook["contacts"] as List;
                                  if (users.isEmpty) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 100),
                                        child: Text('Nessun utente'),
                                      ),
                                    );
                                  }
                                  List<DocumentSnapshot> falseUsers = [];
                                  List<DocumentSnapshot> trueUsers = [];

                                  for (var user in users) {
                                    if (userContacts.contains(user["email"])) {
                                      trueUsers.add(user);
                                    } else {
                                      falseUsers.add(user);
                                    }
                                  }

                                  List<DocumentSnapshot> allUsers = [];
                                  allUsers.addAll(falseUsers);
                                  allUsers.addAll(trueUsers);

                                  return Expanded(
                                      child: ListView.builder(
                                    itemCount: allUsers.length,
                                    itemBuilder: (context, index) {
                                      var contact = allUsers[index];

                                      String name = contact["name"];
                                      String email = contact["email"];
                                      bool status = false;
                                      if (contact["ruolo"] == "admin") {
                                        status = true;
                                      } else {
                                        status = false;
                                      }

                                      return PermissionComponentAdmin(
                                        name: name,
                                        email: email,
                                        status: status,
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
                            return SizedBox();
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
