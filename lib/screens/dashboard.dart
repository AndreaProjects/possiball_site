import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:possiball_site/screens/admin.dart';
import 'package:possiball_site/screens/managecontacts.dart';
import 'package:possiball_site/screens/permissions.dart';
import 'package:possiball_site/screens/tornei/tornei.dart';
import 'package:possiball_site/utils/custompagetransitions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  Future<String> _getSocietyImage() async {
    String? email = FirebaseAuth.instance.currentUser?.email;

    if (email != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var document = querySnapshot.docs.first;
        String image;
        if (document.get('accountType') == "societa") {
          image = document.get('logo');
        } else {
          var idSocieta = document.get('squadra');

          DocumentSnapshot<Map<String, dynamic>> querySnapshot2 =
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(idSocieta)
                  .get();
          var document2 = querySnapshot2;

          image = document2.get('logo');
        }

        return image;
      }
      return "Logo non presente";
    } else {
      return "Utente non trovato";
    }
  }

  Future<String> _getNomeFromEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String? email = FirebaseAuth.instance.currentUser?.email;

    if (email != null) {
      dynamic querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var document = querySnapshot.docs.first;
        var nome;
        var societa;
        var societaId;
        var email;
        if (document.get("accountType") == "membro") {
          String squadraId = document.get("squadra");
          DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(squadraId)
                  .get();
          var data = documentSnapshot.data();
          nome = data!["name"];
          societa = data["societa"];
          societaId = documentSnapshot.id;
          email = data["email"];
        } else {
          nome = document.get('name');
          societa = document.get('societa');
          societaId = document.id;
          email = document.get('email');
        }
        await preferences.setString('id-societa', societaId);
        await preferences.setString('societa', societa);
        await preferences.setString('society-name', nome);
        await preferences.setString('email', email);
        return nome;
      }
      return "Email non presente";
    } else {
      return "Utente non trovato";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/logo.jpeg",
                width: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Dashboard società  ",
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                  ),
                  FutureBuilder<String>(
                    future: _getNomeFromEmail(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          '',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        );
                      } else if (snapshot.hasError) {
                        return const Text('icoa');
                      } else {
                        return Text(
                          snapshot.data ?? '',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(
                  width: 60,
                  height: 60,
                  child: FutureBuilder(
                    future: _getSocietyImage(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Nessuna immagine',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11),
                          ),
                        );
                      } else {
                        return Image.network(
                          snapshot.data ?? 'errr',
                        );
                      }
                    },
                  ))
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 1.5),
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                        RightPageRoute(child: const PermissionsScreen())),
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).cardColor,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.group,
                            size: 40,
                            color: Colors.black,
                          ),
                          Text(
                            "Gestisci permessi",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                        RightPageRoute(child: const ManageContactsScreen())),
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).cardColor,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.book,
                            size: 40,
                            color: Colors.black,
                          ),
                          Text(
                            "Gestisci contatti",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context, RightPageRoute(child: const TorneiScreen())),
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).cardColor,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.emoji_events_outlined,
                            size: 40,
                            color: Colors.black,
                          ),
                          Text(
                            "Tornei",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context, RightPageRoute(child: const AdminScreen())),
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).cardColor,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.admin_panel_settings,
                            size: 40,
                            color: Colors.black,
                          ),
                          Text(
                            "Gestisci admin",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.redAccent,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Logout"),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
