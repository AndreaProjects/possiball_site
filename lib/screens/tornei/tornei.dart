import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:possiball_site/screens/tornei/addtorneo.dart';
import 'package:possiball_site/screens/tornei/viewgironi.dart';
import 'package:possiball_site/screens/tornei/viewtornei.dart';
import 'package:possiball_site/utils/custompagetransitions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TorneiScreen extends StatefulWidget {
  const TorneiScreen({super.key});

  @override
  State<TorneiScreen> createState() => _TorneiScreenState();
}

class _TorneiScreenState extends State<TorneiScreen> {
  Future<String>? takeTargetId() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('Users');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? squadraEmail = preferences.getString('email');

    QuerySnapshot querySnapshot =
        await collectionReference.where('email', isEqualTo: squadraEmail).get();

    String documentId = "";
    querySnapshot.docs.forEach((doc) {
      // Ottieni l'id del documento
      documentId = doc.id;

      // Puoi fare qualcosa con l'id qui
    });

    return documentId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tornei"),
        actions: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).cardColor.withOpacity(0.1)),
            child: TextButton(
                onPressed: () async {
                  await Navigator.push(
                      context, RightPageRoute(child: AddTorneo()));
                },
                child: Text(
                  "Aggiungi torneo",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color),
                )),
          )
        ],
      ),
      body: FutureBuilder(
          future: takeTargetId(),
          builder: (context, targetIdSnapshot) {
            if (targetIdSnapshot.hasData && targetIdSnapshot.data != "") {
              print(targetIdSnapshot.data);
              return StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Tornei').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Errore: ${snapshot.error}');
                  } else {
                    // Filtrare i documenti che contengono almeno un campo con l'ID specificato
                    List<QueryDocumentSnapshot> matchingDocuments =
                        snapshot.data!.docs.where((document) {
                      Map<String, dynamic>? data =
                          document.data() as Map<String, dynamic>?;

                      if (data != null) {
                        for (Map field in data.values) {
                          for (var girone in field.values) {
                            if (girone[0]["id"] == targetIdSnapshot.data) {
                              return true;
                            }
                          }
                        }
                      }

                      return false; // Nessun ID trovato in questo documento
                    }).toList();

                    return GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 5,
                      children: [
                        // Visualizzare gli ID dei documenti corrispondenti
                        for (var document in matchingDocuments)
                          Builder(builder: (context) {
                            var torneo = document.data() as Map;
                            print(document.id);
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  RightPageRoute(
                                      child: ViewTornei(
                                    torneoId: document.id,
                                  ))),
                              onLongPress: () => deleteTorneo(document.id),
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).cardColor,
                                ),
                                child: Text(
                                  '${torneo.keys.first}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 21),
                                ),
                              ),
                            );
                          }),
                      ],
                    );
                  }
                },
              );
            } else {
              return SizedBox();
            }
          }),
    );
  }

  Future deleteTorneo(String id) async {
    showDialog(
        context: context,
        builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Container(
                  width: 300,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor.withOpacity(0.1),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Vuoi cancellare questo torneo?",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Indietro",
                              style: TextStyle(
                                  color: Colors.greenAccent, fontSize: 18),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                await FirebaseFirestore.instance
                                    .collection("Tornei")
                                    .doc(id)
                                    .delete();
                                print('Documento eliminato con successo.');
                              } catch (e) {
                                print(
                                    'Errore durante l\'eliminazione del torneo');
                              }
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Text(
                              "Cancella",
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 18),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )),
              ],
            ));

    setState(() {});
  }
}
